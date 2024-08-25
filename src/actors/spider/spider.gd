class_name Spider extends Actor


const DIR_ROT: Dictionary = {
	"left": 270,
	"right": 90,
	"top": 0,
	"bottom": 180
}


var next_move: String = "left"


@onready var move_arrow: Sprite2D = $MoveArrow


func _ready() -> void:
	Globals.player.player_acted.connect(act)
	get_next_move()


func act() -> void:
	try_move(Globals.DIR_DICT[next_move])
	get_next_move()


func get_next_move() -> void:
	next_move = get_random_move()
	move_arrow.rotation_degrees = DIR_ROT[next_move]


func get_random_move() -> String:
	var possible: Array = Globals.DIR_DICT.keys()
	for dir in possible:
		var area: Area2D = detection[dir]
		if area.has_overlapping_areas() or area.has_overlapping_bodies():
			possible.erase(dir)
	return possible.pick_random()
