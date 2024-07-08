extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var health = 0: set = _set_health

func init_health(_health):
	health = _health
	max_value = health
	value = health
	$HealthNumber.text = str(health)
	
func _set_health(new_health):
	health = new_health
	value = health
	if(health < 0):
		health = 0
	$HealthNumber.text = str(health)
