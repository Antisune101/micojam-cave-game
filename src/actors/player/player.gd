class_name Player extends Actor


signal player_acted


func _enter_tree() -> void:
	Globals.player = self
	super._enter_tree()


func _input(event: InputEvent) -> void:
	var input: Vector2 = Vector2.ZERO
	if Input.is_action_just_pressed("move_left"):
		input.x = -1
	elif Input.is_action_just_pressed("move_right"):
		input.x = 1
	if Input.is_action_just_pressed("move_up"):
		input.y = -1
	elif Input.is_action_just_pressed("move_down"):
		input.y = 1
	if input == Vector2.ZERO or (input.x != 0 &&  input.y != 0):
		return
	player_acted.emit()
	try_move(input)


func _on_actor_collider_area_entered(area: Area2D) -> void:
	Globals.player_lose.emit()
