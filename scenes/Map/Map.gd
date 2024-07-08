extends Node2D

# used for connecting squares correctly
const CONNECTION_DICT = {
	"up": "down",
	"right": "left",
	"down": "up",
	"left": "right",
}

# used to select a correct tile for the map
const DIR_INDX_DICT = {
	"up": 0,
	"right": 1,
	"down": 2,
	"left": 3,
}

# used to generate new square coordinates by adding to the previous coords
const COORDS_ADD_DICT = {
	"up": Vector2i(0, 1),
	"right": Vector2i(1, 0),
	"down": Vector2i(0, -1),
	"left": Vector2i(-1, 0),
}

var squares_dict: Dictionary
@onready var tile_map = $TileMap
@onready var player_icon = $TileMap/player_icon
@onready var start_btn = $TileMap/player_icon/Camera2D/start
@onready var coin_label = get_node("/root/map/Laich")

@onready var pause_menu = $Control
var paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

# Diese Methode pausiert das Spiel und zeigt das Pausenmenü an
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused

# Wird aufgerufen, wenn der Knoten in die Szene eingefügt wird
func _ready():
	pause_menu.hide()
	if !MapAutoload.squares_dict.is_empty():
		squares_dict = MapAutoload.squares_dict
		player_icon.position = MapAutoload.player_icon_pos
		MapAutoload.active_sqr.completed = true
		btn_toggle()
		
		for square in MapAutoload.visited_squares:
			draw_square(square)
	else:
		generate_map(7)
	
	draw_active_square()
	_update_coin_display()

func generate_map(i: int = 6):
	var start = Square.new()
	start.completed = true
	MapAutoload.active_sqr = start
	squares_dict[start.coords] = start
	
	for n in i:
		var selected_square: Square
		while true:
			selected_square = squares_dict.values().pick_random()
			if !selected_square.get_free_paths().is_empty():
				break
		
		var new_path = selected_square.get_free_paths().pick_random()
		var new_square = Square.new(selected_square.coords + COORDS_ADD_DICT[new_path])
		connect_surroundings(new_square)
		squares_dict[new_square.coords] = new_square
	
	var furthest_square = squares_dict[find_furthest_square()]
	var new_path = furthest_square.get_free_paths().pick_random()
	var boss_square = Square.new(furthest_square.coords + COORDS_ADD_DICT[new_path])
	connect_surroundings(boss_square)
	squares_dict[boss_square.coords] = boss_square
	
	MapAutoload.squares_dict = squares_dict
	btn_toggle()

func connect_squares(s1: Square, s2: Square, path: String):
	s1.exits_dict[path] = s2
	s2.exits_dict[CONNECTION_DICT[path]] = s1

func connect_surroundings(square: Square):
	for path in square.get_free_paths():
		var neighbor_coords = square.coords + COORDS_ADD_DICT[path]
		if squares_dict.has(neighbor_coords):
			var neighbor = squares_dict[neighbor_coords]
			connect_squares(square, neighbor, path)

func find_furthest_square() -> Vector2i:
	var astar = AStar2D.new()
	var map = squares_dict.keys()

	for coords in map:
		astar.add_point(map.find(coords), coords)
	
	for coords in map:
		for neighbor in squares_dict[coords].exits_dict.values():
			if neighbor != null:
				astar.connect_points(map.find(coords), map.find(neighbor.coords))
	
	var start_id = map.find(Vector2i(0, 0))
	var max_distance = -1
	var furthest_point = Vector2i(0, 0)
	
	for node in map:
		var path = astar.get_point_path(start_id, map.find(node))
		var distance = path.size()
	
		if distance > max_distance:
			max_distance = distance
			furthest_point = node
	
	return furthest_point

func draw_map():
	for square: Square in squares_dict.values():
		var atlas_id = square.get_taken_paths().size()
		if atlas_id == 4:
			atlas_id = 2
		
		var atlas_coords = choose_tile(square)
		tile_map.set_cell(0, Vector2i(square.coords.x, -1 * square.coords.y), atlas_id, atlas_coords)

func draw_active_square():
	var square = MapAutoload.active_sqr
	MapAutoload.visited_squares.push_back(square)
	draw_square(square)

func draw_square(square: Square):
	var atlas_id = square.get_taken_paths().size()
	if atlas_id == 4:
		atlas_id = 2
	
	var atlas_coords = choose_tile(square)
	tile_map.set_cell(0, Vector2i(square.coords.x, -1 * square.coords.y), atlas_id, atlas_coords)

func choose_tile(square: Square) -> Vector2i:
	match square.get_taken_paths().size():
		1:
			var exit: int = DIR_INDX_DICT[square.get_taken_paths()[0]]
			return Vector2i(exit, 0)
		2:
			var exit_1: int = DIR_INDX_DICT[square.get_taken_paths()[0]]
			var exit_2: int = DIR_INDX_DICT[square.get_taken_paths()[1]]
			return Vector2i(exit_2, exit_1)
		3:
			if square.get_free_paths().is_empty():
				return Vector2i(2, 0)
				
			var closed_exit: int = DIR_INDX_DICT[square.get_free_paths()[0]]
			return Vector2i(closed_exit, 0)
		_:
			return Vector2i(0, 0)

func print_map():
	for square in squares_dict.values():
		print(square.coords)
		print(square.get_taken_paths())
		print()

func _on_start_pressed():
	_update_coin_display()
	get_tree().change_scene_to_file("res://scenes/fight/fight.tscn")

func btn_toggle():
	_update_coin_display()
	if MapAutoload.active_sqr.completed:
		start_btn.hide()
	else:
		start_btn.show()

func _update_coin_display():
	coin_label.set_text(str(PlayerDataAl.coins))


func _on_resume_pressed():
	pauseMenu()


func _on_main_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_option_pressed():
	pass # Replace with function body.
