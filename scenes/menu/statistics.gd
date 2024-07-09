extends Control

var statistics := {
	"correct_answers": 0,
	"total_attempts": 0
}

func _ready() -> void:
	# Load statistics when the game starts
	load_statistics()
	print("Statistics file path: user://statistics.save")

# Function to update the statistics based on whether the answer was correct
func update_statistics(is_correct: bool) -> void:
	# Increment the correct answer count if the answer is correct
	if is_correct:
		statistics["correct_answers"] += 1
	
	# Always increment the total attempts count
	statistics["total_attempts"] += 1

# Save statistics to a file
func save_statistics() -> void:
	var file := FileAccess.open("user://statistics.save", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(statistics))
		file.close()
	else:
		print("Failed to open file for writing")

# Load statistics from a file
func load_statistics() -> void:
	var file := FileAccess.open("user://statistics.save", FileAccess.READ)
	if file:
		var data := file.get_as_text()
		var json = JSON.new()
		var result = json.parse(data)
		if result.error == OK:
			statistics = result.result
		else:
			print("Failed to parse JSON")
		file.close()
	else:
		print("No existing statistics file found, starting fresh")

# Handle window close request
func _notification(what):
	if what == DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
		save_statistics()
		get_tree().quit()

# Example function to simulate receiving an answer result
func _on_answer_received(is_correct: bool) -> void:
	# Update the statistics with the result of the answer
	update_statistics(is_correct)

func _on_back_pressed():
	save_statistics()
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
