class_name Square

extends Node

enum ROOMS {START, ENEMY, CHEST, SHOP, BOSS}

var exits_dict = {
	"up": null,
	"right": null,
	"down": null,
	"left": null,
}

var coords: Vector2i
var roomType: ROOMS
var completed: bool

func _init(coords: Vector2i = Vector2i(0,0), roomType: ROOMS = ROOMS.START):
	self.coords = coords
	self.roomType = roomType
	
	if (self.coords[1] == 0):
		exits_dict.erase("down")


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
