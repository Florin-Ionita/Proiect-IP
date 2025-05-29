extends CanvasLayer

class_name UI

@onready var center_container = $CenterContainer

func show_game_over():
	center_container.show()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	

func _on_exit_pressed() -> void:
	get_tree().quit()
