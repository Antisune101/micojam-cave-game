class_name Room extends Node2D


enum RoomType {
	START,
	EXIT,
	NORMAL
}

const ROOM_SIZE := Vector2(144, 112)

const CONNECTED_DIR: Dictionary = {
		"left": "right",
		"right": "left",
		"bottom": "top",
		"top": "bottom"
}


const SPIDER_SCENE := preload("res://src/actors/spider/spider.tscn")
const GEM_SCENE := preload("res://src/actors/gem_pickup.tscn")

var grid_position: Vector2

@onready var entrances: Dictionary = {
	"top": $Entrances/Top,
	"bottom": $Entrances/Bottom,
	"left": $Entrances/Left,
	"right": $Entrances/Right,
}

@onready var doors: Dictionary = {
	"top": $Doors/Top,
	"bottom": $Doors/Bottom,
	"left": $Doors/Left,
	"right": $Doors/Right,
}

@onready var bug_node = $Bugs
@onready var gem_node = $Gems




func setup_room(rooms: Array, pos: Vector2, type: RoomType, special_door: String = "") -> int:
	grid_position = pos
	global_position = grid_position * ROOM_SIZE
	if special_door != "":
		doors[special_door].setup_door(Door.DoorType.ENTER if type == RoomType.START else Door.DoorType.EXIT)
	for door_key in doors.keys():
		var door: Door = doors[door_key]
		if door.is_setup:
			continue
		var dtype : Door.DoorType
		dtype = Door.DoorType.WALL if is_wall_position(rooms, pos + Globals.DIR_DICT[door_key]) else Door.DoorType.OPEN
		if dtype == Door.DoorType.OPEN:
			door.player_enter_door.connect(func(): door_stuff(door_key))
		door.setup_door(dtype)
	return spawn_spiders_and_gems()

func is_wall_position(rooms: Array, pos: Vector2) -> bool:
	return (pos.x > (Cave.CAVE_SIZE.x -1) || pos.x < 0) || (pos.y > (Cave.CAVE_SIZE.y -1) || pos.y < 0) || rooms[pos.y][pos.x] == "empty" #|| rooms[pos.y][pos.x] == "exit"

func door_stuff(dir: String) -> void:
	Globals.camera.move_to_pos(grid_position + Globals.DIR_DICT[dir])
	Globals.player.global_position = Cave.spawned_rooms[grid_position + Globals.DIR_DICT[dir]].entrances[CONNECTED_DIR[dir]].global_position


func spawn_spiders_and_gems() -> int:
	var positions: Array[Vector2] = get_positions(Vector2(7, 5))
	print(positions)
	var spider_count: int = randi_range(0, 2)
	for spider in spider_count:
		var new_spider = SPIDER_SCENE.instantiate()
		bug_node.add_child(new_spider)
		var pos = positions.pick_random()
		new_spider.position = (pos * 16) + Vector2(24, 24)
		positions.erase(pos)
	var gem_count: int = randi_range(0,3)
	for gem in gem_count:
		var pos = positions.pick_random()
		var new_gem = GEM_SCENE.instantiate()
		gem_node.add_child(new_gem)
		new_gem.position = (pos * 16) + Vector2(24, 24)
		positions.erase(pos)
	return gem_count


func get_positions(room_size: Vector2) -> Array[Vector2]:
	var arr: Array[Vector2] = []
	const NO: Array[Vector2] = [Vector2(2, 0), Vector2(2, 6), Vector2(3, 4), Vector2(3, 0)]
	for y in room_size.y:
		for x in room_size.x:
			var pos = Vector2(x, y)
			if pos in NO:
				continue
			arr.append(Vector2(x, y))
	return arr
