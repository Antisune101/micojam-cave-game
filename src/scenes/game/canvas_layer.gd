extends CanvasLayer


func _ready() -> void:
	Globals.player_enter_exit.connect(func():
		visible = true
		get_tree().paused = true
	)


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/main_menu.tscn")


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
