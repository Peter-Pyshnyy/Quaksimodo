extends ProgressBar

# Called when the node enters the scene tree for the first time
func _ready():
	# Optionally, initialize the progress bar with a default value (e.g., 0%)
	update_progress(0)

# Initialize a dictionary to track the number of correct answers and total attempts
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
	
	# Call the function to update the progress bar to reflect the new statistics
	updateProgressBar()

# Function to calculate the percentage of correct answers
func calculatePercentage() -> float:
	# If there are no attempts, return 0.0 to avoid division by zero
	if statistics["total_attempts"] == 0:
		return 0.0
	
	# Calculate the percentage of correct answers
	return float(statistics["correct_answers"]) / statistics["total_attempts"] * 100

# Function to update the progress bar based on the current statistics
func updateProgressBar() -> void:
	# Calculate the success percentage
	var percentage = calculatePercentage()
	
	# Update the progress bar with the calculated percentage
	update_progress(percentage)

# Function to update the progress bar value
func update_progress(percentage: float):
	# Set the progress bar value to the calculated percentage
	self.value = percentage

# Example function to simulate receiving an answer result
func _on_answer_received(is_correct: bool) -> void:
	# Update the statistics with the result of the answer
	updateStatistics(is_correct)
