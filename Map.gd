extends Node2D

#used for connecting squares correctly
const CONNECTION_DICT = {
	"up": "down",
	"right": "left",
	"down": "up",
	"left": "right",
}

#used to generate new square coordinates by adding to the previous coords
const COORDS_ADD_DICT = {
	"up": Vector2i(0,1),
	"right": Vector2i(1,0),
	"down": Vector2i(0,-1),
	"left": Vector2i(-1,0),
}

var squares_dict: Dictionary;

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_map()
	print_map()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func generate_map(i: int = 6):
	#creates the first square with coords (0,0) of type START
	var start = Square.new(); 
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


func print_map():
	for square in squares_dict.values():
		print(square.coords)
		print(square.get_taken_paths())
		print()
