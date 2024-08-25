extends CanvasLayer


func _ready() -> void:
	Globals.player_lose.connect(queue_free)
	Globals.player_enter_exit.connect(queue_free)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		visible = false


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PAUSED:
			visible = false
		NOTIFICATION_UNPAUSED:
			visible = true
