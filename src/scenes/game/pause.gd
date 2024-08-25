extends CanvasLayer


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = true
		get_tree().paused = true



func _on_continue_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/game/cave.tscn")
