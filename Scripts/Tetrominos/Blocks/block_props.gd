extends Node

const DEFAULT_SCORE: int = 5;

enum BlockType {
	Cyan,
	Green,
	Orange,
	Blue,
	Purple,
	Yellow,
	Red
}

enum BlockEffect {
	Default
}

var BlockScores = {
	BlockType.Cyan: DEFAULT_SCORE,
	BlockType.Green: DEFAULT_SCORE,
	BlockType.Orange: DEFAULT_SCORE,
	BlockType.Blue: DEFAULT_SCORE,
	BlockType.Purple: DEFAULT_SCORE,
	BlockType.Yellow: DEFAULT_SCORE,
	BlockType.Red: DEFAULT_SCORE
}

func get_score(type: BlockType) -> int:
	return BlockScores[type];

func add_score(score: int, type: BlockType):
	BlockScores[type] += score
	
func reset_scores():
	for type in BlockScores.keys():
		BlockScores[type] = DEFAULT_SCORE
		
