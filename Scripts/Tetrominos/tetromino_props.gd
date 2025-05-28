extends Node

class TetrominoData:
	var shape
	var color
	var effect

enum Tetromino {
	I, O, T, J, L, S, Z
}

var cells = {
	Tetromino.I: [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)],
	#-------------------------------------------------------------------
	Tetromino.J: [Vector2(-1, 1), Vector2(-1, 0), Vector2(0,0), Vector2(1, 0 )],
	#-------------------------------------------------------------------
	Tetromino.L: [Vector2(1,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Tetromino.O: [Vector2(0,1), Vector2(1,1), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Tetromino.S: [Vector2(0,1), Vector2(1,1), Vector2(-1, 0), Vector2(0,0)],
	#-------------------------------------------------------------------
	Tetromino.T: [Vector2(0,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	Tetromino.Z: [Vector2(-1, 1), Vector2(0, 1), Vector2(0,0), Vector2(1, 0)]
}

var spawn_position = {
	Tetromino.I: Vector2(-24, -456),
	#-------------------------------------------------------------------
	Tetromino.J: Vector2(-24, -456),
	#-------------------------------------------------------------------
	Tetromino.L: Vector2(-24, -456),
	#-------------------------------------------------------------------
	Tetromino.O: Vector2(-24, -456),
	#-------------------------------------------------------------------
	Tetromino.S: Vector2(24, -456),
	#-------------------------------------------------------------------
	Tetromino.T: Vector2(-24, -456),
	#-------------------------------------------------------------------
	Tetromino.Z: Vector2(-24, -456)
}

const wall_kicks_i = [
	[Vector2(0,0), Vector2(-2,0), Vector2(1,0), Vector2(-2,-1), Vector2(1,2)],
	[Vector2(0,0), Vector2(2,0), Vector2(-1, 0), Vector2(2,1), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(-1, 0), Vector2(2,0), Vector2(-1,2), Vector2(2, -1)],
	[Vector2(0,0), Vector2(1,0), Vector2(-2, 0), Vector2(1, -2), Vector2(-2, 1)],
	[Vector2(0,0), Vector2(2,0), Vector2(-1, 0), Vector2(2,1), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(-2,0), Vector2(1, 0), Vector2(-2, -1), Vector2(1, 2)],
	[Vector2(0,0), Vector2(1,0), Vector2(-2,0), Vector2(1, -2), Vector2(-2,1)],
	[Vector2(0,0), Vector2(-1, 0), Vector2(2, 0), Vector2(-1,2), Vector2(2, -1)]
]

const wall_kicks_jlostz = [
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,1), Vector2(0,-2), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1, -1), Vector2(0,2), Vector2(1, 2)],
	[Vector2(0,0), Vector2(1, 0), Vector2(1,-1), Vector2(0,2), Vector2(1, 2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1, 1), Vector2(0, -2), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1, 1), Vector2(0,-2), Vector2(1, -2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1, -1), Vector2(0, 2), Vector2(-1, 2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0, 2), Vector2(-1, 2)],
	[Vector2(0,0), Vector2(1, 0), Vector2(1, 1), Vector2(0,-2), Vector2(1, -2)]
]

const clockwise_rotation_matrix = [Vector2(0, -1), Vector2(1, 0)]
const counter_clockwise_rotation_matrix = [Vector2(0,1), Vector2(-1, 0)]
