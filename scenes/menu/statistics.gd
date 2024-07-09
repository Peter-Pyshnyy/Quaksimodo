extends Control

var statistics := {
	"correct_answers": 0,
	"total_attempts": 0
}

# Function to update the statistics based on whether the answer was correct
func updateStatistics(is_correct: bool) -> void:
	# Increment the correct answer count if the answer is correct
	if is_correct:
		statistics["correct_answers"] += 1
	
	# Always increment the total attempts count
	statistics["total_attempts"] += 1
	
# Example function to simulate receiving an answer result
func _on_answer_received(is_correct: bool) -> void:
	# Update the statistics with the result of the answer
	updateStatistics(is_correct)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")



