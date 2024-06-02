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
var active_sqr: Square
@onready var tile_map = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_map(7)
	print_map()
	draw_active_square()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#i = map size - 2
func generate_map(i: int = 6):
	#creates the first square with coords (0,0) of type START
	var start = Square.new(); 
	active_sqr = start
	squares_dict[start.coords] = start
	
	for n in i:
		var selected_square: Square;
		while true:
			#picks a square to attach new square to
			selected_square = squares_dict.values().pick_random(); 
			
			#if the square has no more free paths, different square gets picked
			if(!selected_square.get_free_paths().is_empty()): 
				break
		
		var new_path = selected_square.get_free_paths().pick_random();
		
		#new_square.coords = neigboring coords of selected_square.coords
		var new_square = Square.new(selected_square.coords + COORDS_ADD_DICT[new_path])
		
		#connects the new square to surrounding squares
		connect_surroundings(new_square)
		
		squares_dict[new_square.coords] = new_square
	
	#add boss square near the furthest square from (0,0)
	var furthest_square = squares_dict[find_furthest_square()]
	var new_path = furthest_square.get_free_paths().pick_random();
		
	#same as adding new square
	var boss_square = Square.new(furthest_square.coords + COORDS_ADD_DICT[new_path])
	connect_surroundings(boss_square)
	squares_dict[boss_square.coords] = boss_square


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
		#used to select a tile set
		var atlas_id = square.get_taken_paths().size()
		
		#tile with 4 exits in on QM_tiles_double
		if (atlas_id == 4):
			atlas_id = 2; 
		
		#used to select a tile from a tile set
		var atlas_coords = choose_tile(square)
		
		#sets a sprite on a cell (y reversed)
		tile_map.set_cell(0, Vector2i(square.coords.x, -1*square.coords.y), atlas_id, atlas_coords);

func draw_active_square():	
	var square = active_sqr
	
	#used to select a tile set
	var atlas_id = square.get_taken_paths().size()
	
	#tile with 4 exits in on QM_tiles_double
	if (atlas_id == 4):
		atlas_id = 2; 
	
	#used to select a tile from a tile set
	var atlas_coords = choose_tile(square)
	
	#sets a sprite on a cell (y reversed)
	tile_map.set_cell(0, Vector2i(square.coords.x, -1*square.coords.y), atlas_id, atlas_coords);


func choose_tile(square: Square) -> Vector2i:
	match square.get_taken_paths().size():
		1:
			#selects based on the single outgoing path
			var exit: int = DIR_INDX_DICT[square.get_taken_paths()[0]]
			return Vector2i(exit, 0)
		2:
			#uses the grid of the tile set to select a tile
			var exit_1: int = DIR_INDX_DICT[square.get_taken_paths()[0]]
			var exit_2: int = DIR_INDX_DICT[square.get_taken_paths()[1]]
			
			return Vector2i(exit_2, exit_1);
		3:
			#selects based on the single closed path
			if(square.get_free_paths().is_empty()):
				return Vector2i(2,0)
				
			var closed_exit: int = DIR_INDX_DICT[square.get_free_paths()[0]]
			return Vector2i(closed_exit, 0)
		_:
			return Vector2i(0,0)

	

func print_map():
	for square in squares_dict.values():
		print(square.coords)
		print(square.get_taken_paths())
		print()
