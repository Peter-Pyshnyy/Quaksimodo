extends Control


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/tutorial/tutorial.tscn")
	
	
func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/options.tscn")

func _on_quit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	if PlayerDataAl.map_scene:
		get_tree().change_scene_to_file("res://scenes/Map/Map.tscn")
	if PlayerDataAl.fight_scene:
		get_tree().change_scene_to_file("res://scenes/fight/fight.tscn")
