extends Control




func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/map/map.tscn")
	DialogueManager.show_dialogue_balloon(load("res://dialogue/tutorial.dialogue"),"tutorial_start")
	
	

func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/options.tscn")
	



func _on_quit_pressed():
	get_tree().quit()
