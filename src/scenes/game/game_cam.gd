class_name GameCamera extends Camera2D


func _enter_tree() -> void:
	Globals.camera = self


func _exit_tree() -> void:
	Globals.camera = null


func move_to_pos(pos: Vector2) -> void:
	global_position = pos * Room.ROOM_SIZE
