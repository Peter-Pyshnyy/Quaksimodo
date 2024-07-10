extends Control





func _on_play_pressed():
	Transition.transition_scene("res://scenes/Map/Map.tscn")

	DialogueManager.show_dialogue_balloon(load("res://dialogue/tutorial.dialogue"),"tutorial_start")
	
	

func _on_options_pressed():
	Transition.transition_scene("res://scenes/menu/statistics.tscn")
	



func _on_quit_pressed():
	get_tree().quit()
