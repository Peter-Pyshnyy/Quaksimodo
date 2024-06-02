extends Node2D

@onready var healthbar = $HealthBar
var rng = RandomNumberGenerator.new()
var enemy_health
var current_level
var current_question_number
# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = 1
	current_question_number = 1
	enemy_health = Levels.Database[str(current_level)].enemy_health
	print(enemy_health)
	healthbar.init_health(enemy_health)
	load_question()
	$Sprite2D/AnimationPlayer.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_question():
	$Question.text = Levels.Database[str(current_level)].questions[str(current_question_number)].q
	$Button.disabled = true
	

func _on_attack_button_pressed():
	print("works")
	enemy_health = enemy_health - rng.randf_range(4.0, 10.0)
	healthbar.health = enemy_health


func _on_answer_text_submitted(new_text):
	if(new_text == Levels.Database[str(current_level)].questions[str(current_question_number)].a):
		$Button.disabled = false
	else:
		print("wrong")
