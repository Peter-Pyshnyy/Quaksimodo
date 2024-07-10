extends CanvasLayer

signal transition_finished
func transition_scene(path: String) -> void:
	$TransitionAnimationPlayer.play("dissolve")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(path)
	$TransitionAnimationPlayer.play_backwards("dissolve")
	transition_finished.emit()



