extends Control

func _on_resume_pressed():
	pass

func _on_options_pressed():
	pass # Replace with function body.

func _on_main_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
