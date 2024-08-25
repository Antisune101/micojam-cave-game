extends Node

signal player_enter_exit
signal player_lose
signal gem_picked_up

const DIR_DICT: Dictionary = {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"top": Vector2.UP,
	"bottom": Vector2.DOWN
}

const VEC_TO_DIR: Dictionary = {
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right",
	Vector2.UP: "top",
	Vector2.DOWN: "bottom"
}


var camera: GameCamera
var player: Player
