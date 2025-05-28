extends Node

class_name Board

signal tetromino_locked
signal game_over

var lines: Array[Line] = []

const Tetromino = preload("res://Scenes/Tetrominos/tetromino.tscn")

@onready var panel_container = $"../PanelContainer"
@onready var line_scene = preload("res://Scenes/Board/Line/line.tscn")


func _ready() -> void:
	lines.clear()
	for pos in range(BoardShared.block_height):
		var line = line_scene.instantiate() as Line
		add_child(line)
		lines.append(line)

func spawn_tetromino(data: TetrominoShared.TetrominoData, is_played: bool, spawn_position: Vector2 = Vector2(0, 0)):
	# ACtually spawn the piece
	var tetromino = Tetromino.instantiate()
	tetromino.call_deferred("setup", data.shape, data.color, data.effect, is_played)
	
	# Set the is played variable
	tetromino.is_played = is_played
	
	
	if tetromino.is_played:
		var other_pieces = get_all_blocks()
		tetromino.other_tetrominoes_pieces = other_pieces
		add_child(tetromino)
		tetromino.lock_tetromino.connect(on_tetromino_locked)
	else:
		tetromino.scale = Vector2(0.5, 0.5)
		panel_container.add_child(tetromino)
		tetromino.set_position(spawn_position)

func get_lines():
	return lines
	
# Return all the blocks that are locked on the board
func get_all_blocks():
	var blocks = []
	
	# Reverse the lines (last are at the bottom)
	var rev = lines.duplicate()
	rev.reverse()
	
	for line in rev:
		var new_blocks = line.get_children().filter(func (c): return c is Block);
		blocks.append_array(new_blocks)
		
		if (new_blocks.size() == 0):
			break
	return blocks

# Adds the blocks from the tetrominos to the lines
func add_tetromino_to_lines(tetromino: Tetromino):
	
	var tetromino_blocks: Array = tetromino.get_children().filter(func (c): return c is Block)
	for block in tetromino_blocks:
		var pos_y = (block.global_position.y + 456) / block.get_size().y
		var pos_x = (block.global_position.x + 216) / block.get_size().x
	
		var block_line: Line = lines[pos_y]
		block_line.add_block_at(pos_x, block)
	

# Shifts the lines Array + moves their global position too
func move_lines_down(start):
	# 1) Walk from the row just *above* start, down to the top
	for i in range(start, 0, -1):
		var target_line = lines[i]
		var source_line = lines[i - 1]

		for j in range(target_line.blocks.size()):
			if target_line.blocks[j]:
				target_line.remove_child(target_line.blocks[j])
				target_line.blocks[j] = null

		for j in range(source_line.blocks.size()):
			if source_line.blocks[j]:
				var block = source_line.blocks[j]
				target_line.add_block_at(j, block)
				source_line.blocks[j] = null
				block.position.y += 48


# Check to see what lines are full, and remove them
func remove_full_lines():
	for i in range(lines.size()):
		var line: Line = lines[i]
		if (line.is_full()):
			line.empty();
			move_lines_down(i);

# Called when a tetromino got locked
func on_tetromino_locked(tetromino: Tetromino):
	# Add to line and free it
	add_tetromino_to_lines(tetromino);
	tetromino.queue_free()
	
	# Remove the child from the preview
	var panel_tetromino: Tetromino = panel_container.get_children().filter(func (c): return c is Tetromino)[0]
	panel_tetromino.queue_free()
	
	# Check for full lines
	remove_full_lines();
	
	# Announce the spawer
	tetromino_locked.emit()
	
	# Check for game over
	check_game_over()

	
func check_game_over():
	var is_game_over = lines[0].get_children().filter(func (c): return c is Block).size() != 0; # If there is a block on top line
	if is_game_over:
		game_over.emit()
