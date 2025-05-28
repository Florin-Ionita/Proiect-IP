extends Node2D

class_name Tetromino

const BlockScene = preload("res://Scenes/Tetrominos/Blocks/block.tscn")

signal lock_tetromino(tetromino: Tetromino)

# Movement and bounds
var bounds = {
	"min_x": -216,
	"max_x": 216,
	"max_y": 457
}

var rotation_index = 0

var wall_kicks = []
var tetromino_type: TetrominoShared.Tetromino

var blocks: Array[Area2D] = []
var tetromino_cells = []

var other_tetrominoes_pieces = [] 
var ghost_tetromino

@onready var timer = $Timer
@onready var ghost_tetromino_scene = preload("res://Scenes/ghost_tetromino.tscn")

var is_played = false

# Initialise the tetronimo
func setup(
	tetromino: TetrominoShared.Tetromino, 
	block_type: BlockShared.BlockType, 
	block_effect: BlockShared.BlockEffect = BlockShared.BlockEffect.Default, 
	is_played: bool = true
):
	self.tetromino_type = tetromino
	self.is_played = is_played
	
	# Initialize cells for this tetromino type
	tetromino_cells = TetrominoShared.cells[tetromino_type].duplicate()

	# Get the position based on type
	if is_played:
		position = TetrominoShared.spawn_position[tetromino]
	
	# Create blocks via factory and position them
	for cell in tetromino_cells:
		var block = BlockScene.instantiate()
		add_child(block)
		
		block.call_deferred("setup", block_type, block_effect)
		block.position = cell * block.get_size()
		
		blocks.append(block)
	
	if is_played:
		wall_kicks = TetrominoShared.wall_kicks_i if (tetromino_type == TetrominoShared.Tetromino.I) else TetrominoShared.wall_kicks_jlostz
		
		# Ghost block things
		#ghost_tetromino = ghost_tetromino_scene.instantiate()
		#ghost_tetromino.tetromino_data = tetromino_data
		#get_tree().root.add_child(ghost_tetromino)
		#hard_drop_ghost()
	else:
		timer.stop()
		set_process_input(false)

func is_colliding_with_other_tetrominos(direction: Vector2, start_global_pos: Vector2) -> bool:
	for other_block in other_tetrominoes_pieces:
		# Check if it was removed at some point
		for block in blocks:
			if start_global_pos + block.position + direction * block.get_size() == other_block.global_position:
				return true
	return false

func is_within_game_bounds(direction: Vector2, start_global_pos: Vector2) -> bool:
	for block in blocks:
		var new_pos = block.position + start_global_pos + direction * block.get_size()
		if new_pos.x < bounds.min_x or new_pos.x > bounds.max_x or new_pos.y >= bounds.max_y:
			return false
	return true


func calculate_global_position(direction: Vector2, start_global_pos: Vector2):
	# If it is from a rogue timer
	if blocks.size() == 0:
		return null
	
	if is_colliding_with_other_tetrominos(direction, start_global_pos):
		return null
	if !is_within_game_bounds(direction, start_global_pos):
		return null
	return start_global_pos + direction * blocks[0].get_size().x


func hard_drop_ghost():
	var final_hard_drop_position = null
	var ghost_position_update = calculate_global_position(Vector2.DOWN, global_position)
	
	while ghost_position_update != null:
		final_hard_drop_position = ghost_position_update
		ghost_position_update = calculate_global_position(Vector2.DOWN, ghost_position_update)
	
	if final_hard_drop_position != null:
		var pieces_position = []
		for block in blocks:
			pieces_position.append(block.position)
		#ghost_tetromino.set_ghost_tetromino(final_hard_drop_position, pieces_position)
	
	return final_hard_drop_position

func test_wall_kicks(rot_index: int, rot_direction: int) -> bool:
	var wall_kick_index = get_wall_kick_index(rot_index, rot_direction)
	for offset in wall_kicks[wall_kick_index]:
		if move(offset):
			return true
	return false

func get_wall_kick_index(rot_index: int, rot_direction: int) -> int:
	var idx = rot_index * 2
	if rot_direction < 0:
		idx -= 1
	return wrap(idx, 0, wall_kicks.size())

func apply_rotation(direction: int):
	var rotation_matrix = TetrominoShared.clockwise_rotation_matrix if (direction == 1) else TetrominoShared.counter_clockwise_rotation_matrix
	
	for i in range(tetromino_cells.size()):
		var cell = tetromino_cells[i]
		var x = rotation_matrix[0].x * cell.x + rotation_matrix[0].y * cell.y
		var y = rotation_matrix[1].x * cell.x + rotation_matrix[1].y * cell.y
		tetromino_cells[i] = Vector2(x, y)
	
	for i in range(blocks.size()):
		blocks[i].position = tetromino_cells[i] * blocks[i].get_size()

func hard_drop():
	while move(Vector2.DOWN):
		continue
	lock()

func lock():
	timer.stop()
	timer.disconnect("timeout", Callable(self, "_on_timer_timeout"))
	emit_signal("lock_tetromino", self)
	set_process_input(false)
	queue_free()


func move(direction: Vector2) -> bool:
	# If it is not played -> fo not need to move it
	if !self.is_played:
		return false
	
	var new_position = calculate_global_position(direction, global_position)
	if new_position:
		global_position = new_position
		#if direction != Vector2.DOWN:
			#hard_drop_ghost()
		return true
	return false
	

func rotate_tetromino(direction: int):
	if tetromino_type == TetrominoShared.Tetromino.O:
		return  # O piece doesn't rotate
	
	var original_rotation_index = rotation_index
	apply_rotation(direction)
	rotation_index = wrap(rotation_index + direction, 0, 4)
	
	if !test_wall_kicks(rotation_index, direction):
		print("SDJHGDJS")
		rotation_index = original_rotation_index
		apply_rotation(-direction)
	
	#hard_drop_ghost()

func _input(event):
	if event.is_action_pressed("left"):
		move(Vector2.LEFT)
	elif event.is_action_pressed("right"):
		move(Vector2.RIGHT)
	elif event.is_action_pressed("down"):
		move(Vector2.DOWN)
	elif event.is_action_pressed("hard_drop"):
		hard_drop()
	elif event.is_action_pressed("rotate_left"):
		rotate_tetromino(-1)
	elif event.is_action_pressed("rotate_right"):
		rotate_tetromino(1)
	#ghost_tetromino.queue_free()

func _on_timer_timeout():
	if self.is_played && !move(Vector2.DOWN):
		lock()
