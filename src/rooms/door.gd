class_name Door extends Node2D

signal player_enter_door

enum DoorType {
	ENTER,
	EXIT,
	WALL,
	OPEN
}

var type: DoorType
var is_setup: bool = false


@onready var area: Area2D = $Area2D


func setup_door(type_: DoorType) -> void:
	is_setup = true
	type = type_
	if type == DoorType.OPEN: return
	if type == DoorType.EXIT:
		$ExitSprite.visible = true
		return
	close()
	var sprite_ref = $EnterSprite if type == DoorType.ENTER else  $WallSprite
	sprite_ref.visible = true


func close() -> void:
	area.set_collision_layer_value(3, true)


func _on_area_2d_area_entered(area: Area2D) -> void:
	var sig = Globals.player_enter_exit if type == DoorType.EXIT else player_enter_door
	sig.emit()
