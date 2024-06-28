extends CharacterBody2D

var currPos: Vector2
@onready var map = $"../.."
var has_moved = false

func _input(event):
	var input_movement: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	currPos = self.position
	
	if input_movement == Vector2.ZERO:
		return
	
	if input_movement.x != 0 and input_movement.y != 0:
		return
	
	if not check_path(currPos + 16 * input_movement):
		return
	
	self.position += 16 * input_movement
	MapAutoload.player_icon_pos = self.position
	
	var square = Vector2i(self.position / 16)
	square.y *= -1
	MapAutoload.active_sqr = map.squares_dict[square]
	map.draw_active_square()
	map.btn_toggle()
	
	if not has_moved:
		has_moved = true
		player_data.movement = true

func check_path(pos: Vector2i) -> bool:
	var grid_coords = round(pos / 16)
	grid_coords.y *= -1

	return map.squares_dict.has(grid_coords)

