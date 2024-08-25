class_name Cave extends Node2D


const CAVE_SIZE: Vector2 = Vector2(5, 5)
const ROOM_SCENE := preload("res://src/rooms/room.tscn")

var rooms := []
static var spawned_rooms: Dictionary = {}
var start_dir: String = "bottom"
var start_pos: Vector2
var exit_dir: String = "top"


@onready var room_node: Node = $Rooms
@onready var camera: Camera2D = $Camera2D

@onready var win_gem: Label = %WinGem
@onready var game_gem: Label = %GameGem

var total_gems: int
var collected_gems: int 


func _ready() -> void:
	get_tree().paused = false
	generate_cave()
	$Player.global_position = spawned_rooms[start_pos].entrances[start_dir].global_position
	Globals.player_lose.connect($LoseSound.play)
	Globals.player_enter_exit.connect($WinSound.play)
	Globals.gem_picked_up.connect(on_gem_picked_up)
	win_gem.text = "Gems Collected %s/%s" % [collected_gems, total_gems]
	game_gem.text = "Gems %s/%s" % [collected_gems, total_gems]
	

func on_gem_picked_up() -> void:
	$Pickup.play()
	collected_gems += 1
	win_gem.text = "Gems Collected %s/%s" % [collected_gems, total_gems]
	game_gem.text = "Gems %s/%s" % [collected_gems, total_gems]
	

func generate_cave() -> void:
	rooms = init_rooms(CAVE_SIZE)
	start_pos = Vector2(randi_range(0, CAVE_SIZE.x -1), randi_range(0, CAVE_SIZE.y -1))
	rooms[start_pos.y][start_pos.x] = "start"
	print(branch_rooms(start_pos, 8))
	spawn_rooms()


# Recursive functions are pretty neat
func branch_rooms(pos: Vector2, max_depth: int, depth: int = 0) -> bool:
	var new_pos: Vector2 = pos
	var possible_dirs = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	var selection
	while true:
		if possible_dirs.is_empty(): return false
		selection = possible_dirs.pick_random()
		new_pos = pos + selection
		if is_valid_position( new_pos):
			break
		else:
			possible_dirs.erase(selection)
	if depth + 1 == max_depth:
		rooms[new_pos.y][new_pos.x] = "exit"
		exit_dir = Room.CONNECTED_DIR[Globals.VEC_TO_DIR[selection]]
		return true
	else:
		rooms[new_pos.y][new_pos.x] = "room"
		return branch_rooms(new_pos, max_depth, depth + 1)


func is_valid_position( pos: Vector2) -> bool:
	return (pos.x <= (CAVE_SIZE.x -1) && pos.x >= 0) && (pos.y <= (CAVE_SIZE.y -1) && pos.y >= 0) && rooms[pos.y][pos.x] == "empty"


func init_rooms(size: Vector2) -> Array:
	var empty_rooms = []
	for y in range(size.y):
		empty_rooms.append(empty_array(size.x))
	return empty_rooms


func empty_array(size: int) -> Array:
	var arr = []
	arr.resize(size)
	arr.fill("empty")
	return arr


func spawn_rooms() -> void:
	for y in range(len(rooms)):
		for x in range(len(rooms[y])):
			var id = rooms[y][x]
			if id == "empty":
				continue
			var pos: Vector2 = Vector2(x, y)
			var new_room = ROOM_SCENE.instantiate()
			room_node.add_child(new_room)
			spawned_rooms[pos] = new_room
			var type: Room.RoomType
			var dir: String
			match id:
				"start":
					camera.global_position = pos * Room.ROOM_SIZE
					type = Room.RoomType.START
					dir = start_dir
				"exit":
					type = Room.RoomType.EXIT
					dir = exit_dir
				"room":
					type = Room.RoomType.NORMAL
			total_gems += new_room.setup_room(rooms, pos, type, dir)


func spawn_room(type: Room.RoomType, pos: Vector2) -> void:
	var new_room = ROOM_SCENE.instantiate()
	new_room.setup_room(pos, type)


func get_filled_position(arr: Array) -> Array[Vector2]:
	var result: Array[Vector2] = []
	for y in range(len(rooms)):
		for x in range(len(rooms[y])):
			if rooms[y][x] != "empty":
				result.append(Vector2(x,y))
	return result
