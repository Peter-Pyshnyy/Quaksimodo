extends Node2D

#used for connecting squares correctly
const CONNECTION_DICT = {
	"up": "down",
	"right": "left",
	"down": "up",
	"left": "right",
}

#used to select a correct tile for the map
const DIR_INDX_DICT = {
	"up": 0,
	"right": 1,
	"down": 2,
	"left": 3,
}

#used to generate new square coordinates by adding to the previous coords
const COORDS_ADD_DICT = {
	"up": Vector2i(0,1),
	"right": Vector2i(1,0),
	"down": Vector2i(0,-1),
	"left": Vector2i(-1,0),
}

var squares_dict: Dictionary
@onready var tile_map = $TileMap
@onready var player_icon = $TileMap/player_icon
@onready var btn_fight = $TileMap/player_icon/Camera2D/btn_fight
@onready var btn_shop = $TileMap/player_icon/Camera2D/btn_shop
@onready var btn_chest = $TileMap/player_icon/Camera2D/btn_chest
@onready var btn_boss = $TileMap/player_icon/Camera2D/btn_boss

# Called when the node enters the scene tree for the first time.
func _ready():
	#redraw map after fight
	if(!MapAutoload.squares_dict.is_empty()):
		squares_dict = MapAutoload.squares_dict
		player_icon.position = MapAutoload.player_icon_pos
		btn_toggle(MapAutoload.active_sqr.roomType)
		
		for square in MapAutoload.visited_squares:
			draw_square(square)
			draw_neighbours(square)
		
		
	else:
		generate_map()
	
	if PlayerDataAl.passives_dict[PlayerDataAl.POWER_UPS.MAP]:
		draw_map()
	else:
		draw_active_square()


#i = map size - 2
func generate_map(i: int = 7):
	#creates the first square with coords (0,0) of type PATH
	var start = Square.new()
	start.visited = true
	MapAutoload.active_sqr = start
	squares_dict[start.coords] = start
	
	for n in i:
		var selected_square: Square
		
		while true:
			#selects a square to attach new square to
			selected_square = squares_dict.values().pick_random(); 
			
			#if the square has no more free paths, different square gets picked
			if(!selected_square.get_free_paths().is_empty()): 
				break
		
		var new_path = selected_square.get_free_paths().pick_random()
		
		#new_square.coords = neigboring coords of selected_square.coords
		var new_square = Square.new(selected_square.coords + COORDS_ADD_DICT[new_path])
		
		#connects the new square to surrounding squares
		connect_surroundings(new_square)
		
		new_square.roomType = Square.ROOMS.ENEMY
		
		squares_dict[new_square.coords] = new_square
	
	#add boss square near the furthest square from (0,0)
	var furthest_square = squares_dict[find_furthest_square()]
	var new_path = furthest_square.get_free_paths().pick_random();
		
	#same as adding new square
	var boss_square = Square.new(furthest_square.coords + COORDS_ADD_DICT[new_path])
	connect_surroundings(boss_square)
	boss_square.roomType = Square.ROOMS.BOSS
	boss_square.variation = randi_range(0,2)
	print(boss_square.variation)
	squares_dict[boss_square.coords] = boss_square
	
	#spawns a chest and a shop in the world
	var keys = squares_dict.keys()
	squares_dict[keys[round(squares_dict.size()/3)]].roomType = Square.ROOMS.CHEST
	squares_dict[keys[2*round(squares_dict.size()/3)]].roomType = Square.ROOMS.SHOP
	
	MapAutoload.squares_dict = squares_dict
	
	btn_toggle(MapAutoload.active_sqr.roomType)


func connect_squares(s1: Square, s2: Square, path: String):
	s1.exits_dict[path] = s2
	s2.exits_dict[CONNECTION_DICT[path]] = s1


func connect_surroundings(square: Square):
	#loops through all 4 direction
	for path in square.get_free_paths():
		var neighbor_coords = square.coords+COORDS_ADD_DICT[path]
		
		#if there is an unconnected neighbor, connects the squares
		if(squares_dict.has(neighbor_coords)):
			var neighbor = squares_dict[neighbor_coords]
			connect_squares(square, neighbor, path)


#finds the square furthest away from (0, 0) using AStar
func find_furthest_square() -> Vector2i:
	var astar = AStar2D.new()
	var map = squares_dict.keys()

	# add points to the AStar grid
	for coords in map:
		astar.add_point(map.find(coords), coords) #(id=index, coords)
	
	# connect points
	for coords in map:
		#loops through square's neighbors and connects them in astar
		for neighbor in squares_dict[coords].exits_dict.values():
			if neighbor != null:
				astar.connect_points(map.find(coords), map.find(neighbor.coords))
	
	var start_id = map.find(Vector2i(0, 0))
	var max_distance = -1
	var furthest_point = Vector2i(0, 0)
	
	# finds the furthest square from (0,0) by checking the distance to each one
	for node in map:
		var path = astar.get_point_path(start_id, map.find(node))
		var distance = path.size()
	
		if distance > max_distance:
			max_distance = distance
			furthest_point = node
	
	return furthest_point

func draw_map():
	for square: Square in squares_dict.values():
		square.visited = true
		draw_square(square)

func draw_active_square():	
	var square = MapAutoload.active_sqr
	MapAutoload.visited_squares.push_back(square)
	
	draw_square(square)
	draw_neighbours(square)

func draw_neighbours(square: Square):
	#if square.roomType == Square.ROOMS.ENEMY: return
	
	for neighbor in square.exits_dict.values():
			if neighbor != null && !neighbor.visited:
				draw_square(neighbor)

func draw_square(square: Square):
	#used to select a tile set
	var atlas_id = 0
	
	#usef for boss and bought item / opened chest
	if square.roomType == Square.ROOMS.BOSS:
		atlas_id = 1
	elif square.completed:
		atlas_id = square.roomType
	else:
		atlas_id = 0
	
	#used to select a tile from a tile set
	var atlas_coords = choose_tile(square)
	
	#sets a sprite on a cell (y reversed)
	tile_map.set_cell(0, Vector2i(square.coords.x, -1*square.coords.y), atlas_id, atlas_coords);

func choose_tile(square: Square) -> Vector2i:
	if !square.visited:
		return Vector2i(4, 0)
	
	if square.roomType == Square.ROOMS.BOSS || square.completed:
		return Vector2i(square.variation, 0)
	
	match square.roomType:
		1:
			return Vector2i(1, 0)
		2:
			return Vector2i(2, 0)
		3:
			return Vector2i(3, 0)
		_:
			return Vector2i(0, 0)

func print_map():
	for square in squares_dict.values():
		print(square.coords)
		print(square.get_taken_paths())
		print()

func btn_toggle(roomType: int):
	btn_fight.hide()
	btn_shop.hide()
	btn_chest.hide()
	btn_boss.hide()
	
	#if a path or completed -> don't show button
	if(MapAutoload.active_sqr.roomType == 0 || MapAutoload.active_sqr.completed):
		return
		
	match roomType:
		1: btn_fight.show()
		2: btn_chest.show()
		3: btn_shop.show()
		4: btn_boss.show()

func _on_btn_fight_pressed():
	Transition.transition_scene("res://scenes/fight/fight.tscn")

func _on_btn_shop_pressed():
	Transition.transition_scene("res://scenes/shop/shop.tscn")

func _on_btn_boss_pressed():
	Transition.transition_scene("res://scenes/fight/fight_boss.tscn")
