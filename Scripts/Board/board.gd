extends Node

class_name Board

signal tetromino_locked
signal game_over
signal shop
signal boss(ability: String)

var lines: Array[Line] = []
var in_shop = false
var fall_time = 1.0

# Boss vars
var is_boss = false
var double_point = false
var double_speed = false
var no_active = false
var no_next = false
var no_mult_point = false


const Tetromino = preload("res://Scenes/Tetrominos/tetromino.tscn")

@onready var panel_container = $"../PanelContainer"
@onready var line_scene = preload("res://Scenes/Board/Line/line.tscn")
@onready var score = $"../Score"

func _ready() -> void:
	lines.clear()
	
	var shop_info = get_node("../ShopInfo")
	shop_info.hide()
	
	var level_name_lbl = get_node("../LevelDescription/VBoxContainer/Name")
	var level_description_lbl = get_node("../LevelDescription/VBoxContainer/Description")
	level_name_lbl.text = "Normal Level"
	level_description_lbl.text = "No Level Modifiers."
	
	var points_lbl = get_node("../Stats_panel/GridContainer/Round_Info_Panel/VBoxContainer2/VBoxContainer3/PointsValue")
	points_lbl.text = str(0)
	
	score.set_goal(100)
	var goal_lbl = get_node("../Stats_panel/GridContainer/Round_Info_Panel/VBoxContainer2/VBoxContainer4/GoalValue")
	goal_lbl.text = str(score.goal)
	
	for pos in range(BoardShared.block_height):
		var line = line_scene.instantiate() as Line
		add_child(line)
		lines.append(line)

func spawn_tetromino(data: TetrominoShared.TetrominoData, is_played: bool, spawn_position: Vector2 = Vector2(0, 0)):
	# ACtually spawn the piece
	var tetromino = Tetromino.instantiate()
	tetromino.call_deferred("setup", data.shape, data.color, data.effect, is_played)
	
	# Seth the fall time
	if !double_speed:
		tetromino.get_node("Timer").wait_time = fall_time
	else:
		tetromino.get_node("Timer").wait_time = fall_time / 2

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

func set_boss_ability(level_description_lbl):
	randomize() 
	match 1 % 5:
		0: 
			double_point = true
			level_description_lbl.text = "Double the Points are Needed."
		1: 
			double_speed = true
			level_description_lbl.text = "Pieces Move at Double the Speed."
		2: 
			no_active = true
			level_description_lbl.text = "You cannot Use your Active "
		3: 
			no_next = true
			level_description_lbl.text = "You cannot See What is the Next Piece"
		4: 
			no_mult_point = true
			level_description_lbl.text = "You do not Get any Multiplier for More Lines Cleared"

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
	
		# Retain the "highest" line it reaches
		score.set_high(pos_y)
	
		var block_line: Line = lines[pos_y]
		block_line.add_block_at(pos_x, block)
	

# Shifts the lines Array + moves their global position too
func move_lines_down(start):
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
	var mult = 1
	var win
	for i in range(lines.size()):
		var line: Line = lines[i]
		if (line.is_full()):
			# Add the points
			win = score.add_points(line.calculate_points(mult))
			var points_lbl = get_node("../Stats_panel/GridContainer/Round_Info_Panel/VBoxContainer2/VBoxContainer3/PointsValue")
			points_lbl.text = str(score.points)
			mult *= 2
			
			if no_mult_point:
				mult = 1
			
			# Empty the line
			line.empty();
			move_lines_down(i);
	
	if win:
		go_shop()

func remove_panel_tetromino():
	var panel_tetromino: Tetromino = panel_container.get_children().filter(func (c): return c is Tetromino)[0]
	panel_tetromino.queue_free()

# Called when a tetromino got locked
func on_tetromino_locked(tetromino: Tetromino):
	# Add to line and free it
	add_tetromino_to_lines(tetromino);
	tetromino.queue_free()
	
	# Remove the child from the preview
	if !no_next:
		remove_panel_tetromino()
	
	# Check for full lines
	remove_full_lines();
	
	# Announce the spawer
	tetromino_locked.emit()
	
	# Check for game over
	check_game_over()

func empty_table():
	for line in lines:
		line.empty()
	

func _input(event):
	if in_shop && event.is_action_pressed("rotate_left"):
		var shop_info = get_node("../ShopInfo")
		shop_info.hide()
		in_shop = false
		shop.emit()
		
# When the level is complete
func go_shop():
	in_shop = true
	var shop_info = get_node("../ShopInfo")
	shop_info.show()
	
	# Calculate the money earned
	score.calculate_money_gain()
	var money_lbl = get_node("../Stats_panel/GridContainer/Game_Info_Panel/VBoxContainer/VBoxContainer/MoneyValue")
	print("Money: ", score.money)
	money_lbl.text = str(score.money) + '$'
	
	# Clear the table
	empty_table()
	
	# Remove the child from the preview
	remove_panel_tetromino()
	
	# Set next level
	score.level += 1;
	var score_lbl = get_node("../Stats_panel/GridContainer/Game_Info_Panel/VBoxContainer/VBoxContainer3/LevelValue")
	score_lbl.text = str(score.level)
	
	# See boss and choose one
	var level_name_lbl = get_node("../LevelDescription/VBoxContainer/Name")
	var level_description_lbl = get_node("../LevelDescription/VBoxContainer/Description")
	print(level_name_lbl)
	if score.level % 3 == 0:
		is_boss = true
		
		level_name_lbl.text = "Boss"
		
		set_boss_ability(level_description_lbl)
	else:
		level_name_lbl.text = "Normal"
		level_description_lbl.text = "No Level Modifiers."
		
		is_boss = false
		
		double_point = false
		double_speed = false
		no_active = false
		no_next = false
		no_mult_point = false
		
	# Set the next points
	score.set_points(0)
	score.calculate_next_goal()
	if double_point:
		score.set_goal(score.goal * 2)
	
	var points_lbl = get_node("../Stats_panel/GridContainer/Round_Info_Panel/VBoxContainer2/VBoxContainer3/PointsValue")
	points_lbl.text = str(0)
	
	var goal_lbl = get_node("../Stats_panel/GridContainer/Round_Info_Panel/VBoxContainer2/VBoxContainer4/GoalValue")
	goal_lbl.text = str(score.goal)
	
	# Calculate new fall time
	fall_time /= 1.2
	if (fall_time < 0.01):
		fall_time = 0.01
	
	# Emit a signal in case it is needed
	shop.emit()
	
func check_game_over():
	var is_game_over = lines[0].get_children().filter(func (c): return c is Block).size() != 0; # If there is a block on top line
	if is_game_over:
		game_over.emit()
