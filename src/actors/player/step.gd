extends AudioStreamPlayer


func _ready() -> void:
	Globals.player.player_acted.connect(play)
