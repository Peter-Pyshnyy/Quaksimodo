extends Node

@onready var infoGraphic = %balloon/InfoGraphic

func end_scene():
	Transition.transition_scene("res://scenes/transition/end.tscn")
	await get_tree().create_timer(10).timeout
	Transition.transition_scene("res://scenes/menu/main_menu.tscn")
	
