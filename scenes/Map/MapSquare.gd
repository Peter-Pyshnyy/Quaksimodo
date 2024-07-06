class_name Square

extends Node

enum ROOMS {PATH, ENEMY, CHEST, SHOP, BOSS}

var exits_dict = {
	"up": null,
	"right": null,
	"left": null,
	"down": null,
}

var coords: Vector2i
var roomType: ROOMS
var boss: int
var visited: bool

func _init(coords: Vector2i = Vector2i(0,0), roomType: ROOMS = ROOMS.PATH):
	self.coords = coords
	self.roomType = roomType
	self.visited = false
	self.boss = 0
	
	#map limits
	if (self.coords[0] == -5):
		exits_dict.erase("left")
	if (self.coords[0] == 5):
		exits_dict.erase("right")
	if (self.coords[1] == -1):
		exits_dict.erase("down")
	if (self.coords[1] == 4):
		exits_dict.erase("up")


func get_free_paths() -> Array:
	var result: Array
	
	for exit in exits_dict:
		if (exits_dict[exit] == null):
			result.push_back(exit);
	
	return result

func get_taken_paths() -> Array:
	var result: Array
	
	for exit in exits_dict:
		if (exits_dict[exit] != null):
			result.push_back(exit);
	
	return result
