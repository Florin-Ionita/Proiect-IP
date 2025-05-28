extends Node

@onready var board = $"../Board" as Board
@onready var ui = $"../UI" as UI


var current_data
var next_data 

var is_game_over = false

func _ready():
	# Create data for the next 2 pieces
	current_data = create_tetromino_data()
	next_data = create_tetromino_data()
	
	# Add them to the board
	board.spawn_tetromino(current_data, true)
	board.spawn_tetromino(next_data, false, Vector2(90, 50))
	
	# Add the signals
	board.tetromino_locked.connect(on_tetromino_locked)
	board.game_over.connect(on_game_over)
	

func create_tetromino_data() -> TetrominoShared.TetrominoData:
	var data = TetrominoShared.TetrominoData.new()
	data.shape = TetrominoShared.Tetromino.values().pick_random()
	data.color = BlockShared.BlockType.values().pick_random()
	data.effect = BlockShared.BlockEffect.Default
	return data

func on_tetromino_locked():
	if is_game_over:
		return
	current_data = next_data	
	next_data = create_tetromino_data()
	board.spawn_tetromino(current_data, true)
	board.spawn_tetromino(next_data, false, Vector2(90, 50))

func on_game_over():
	is_game_over = true
	ui.show_game_over()
