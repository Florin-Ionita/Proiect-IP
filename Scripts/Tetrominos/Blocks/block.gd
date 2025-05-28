extends Area2D

class_name Block

@onready var sprite = $BlockSprite
@onready var collision_shape_2d = $CollisionShape2D

var type: BlockShared.BlockType
var effect: BlockShared.BlockEffect

func setup(t: BlockShared.BlockType, e: BlockShared.BlockEffect = BlockShared.BlockEffect.Default):
	self.type = t
	self.effect = e
	sprite.region_rect.position.x = type * sprite.region_rect.size.x

func get_size() -> Vector2:
	return collision_shape_2d.shape.get_rect().size

func change_type(new_type: BlockShared.BlockType):
	self.type = new_type

func change_effect(new_effect: BlockShared.BlockEffect):
	self.effect = new_effect

func get_type() -> BlockShared.BlockType:
	return self.type

func get_effect() -> BlockShared.BlockEffect:
	return self.effect

func get_score() -> int:
	return BlockShared.get_score(type);
