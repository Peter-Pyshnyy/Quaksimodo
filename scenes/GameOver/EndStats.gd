extends ProgressBar

# Initialize a dictionary to track the number of correct answers and total attempts


# Called when the node enters the scene tree for the first time
func _ready():
	# Optionally, initialize the progress bar with a default value (e.g., 0%)
	updateProgressBar()

# Function to calculate the percentage of correct answers
func calculatePercentage() -> float:
	# If there are no attempts, return 0.0 to avoid division by zero
	if Statistics.statistics["total_attempts"] == 0:
		return 0.0
	
	# Calculate the percentage of correct answers
	return float(Statistics.statistics["correct_answers"]) / Statistics.statistics["total_attempts"] * 100

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
