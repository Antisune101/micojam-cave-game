class_name Actor extends Node2D


static var actors: Array[Actor] = []


@onready var detection: Dictionary = {
	"top": $Detection/Up,
	"bottom": $Detection/Down,
	"left": $Detection/Left,
	"right": $Detection/Right
}


func _enter_tree() -> void:
	actors.append(self)


func _exit_tree() -> void:
	actors.erase(self)


func act() -> void:
	pass


func try_move(dir: Vector2) -> void:
	var area: Area2D = detection[Globals.VEC_TO_DIR[dir]]
	if area.has_overlapping_areas():
		var overlap = area.get_overlapping_areas()[0]
		if overlap is Actor:
			overlap.take_damage()
		return
	elif area.has_overlapping_bodies():
		return
	else:
		global_position += dir * 16
