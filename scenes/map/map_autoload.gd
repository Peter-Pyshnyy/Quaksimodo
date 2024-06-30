extends Node


var squares_dict: Dictionary
var active_sqr: Square
var visited_squares: Array
var player_icon_pos: Vector2

func reset():
	squares_dict = {}
	active_sqr = null
	visited_squares = []
	player_icon_pos = Vector2(0,0)
