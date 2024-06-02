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
	enemy_health = Levels.LevelDatabase[str(current_level)].enemy_health
	print(enemy_health)
	healthbar.init_health(enemy_health)
	load_questions()
	$Sprite2D/AnimationPlayer.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_questions():
	$Function.text = "Function: " + Levels.QuestionDatabase[str(current_question_number)].f
	$Question.text = Levels.QuestionDatabase[str(current_question_number)].q1
	$Question2.text = Levels.QuestionDatabase[str(current_question_number)].q2
	$Question3.text = Levels.QuestionDatabase[str(current_question_number)].q3

	

func _on_attack_button_pressed():
	$Answer.grab_focus()
	if(anwer_to_q1 == Levels.QuestionDatabase[str(current_question_number)].a1):
		enemy_health = enemy_health - 1
		healthbar.health = enemy_health
		print("right")
	else:
		print("wrong")
	
	await get_tree().create_timer(0.75).timeout
	
	$Answer2.grab_focus()
	if(anwer_to_q2 == Levels.QuestionDatabase[str(current_question_number)].a2):
		enemy_health = enemy_health - 1
		healthbar.health = enemy_health
		print("right")
	else:
		print("wrong")
	
	await get_tree().create_timer(0.75).timeout
	
	$Answer3.grab_focus()
	if(anwer_to_q3 == Levels.QuestionDatabase[str(current_question_number)].a3):
		enemy_health = enemy_health - 1
		healthbar.health = enemy_health
		print("right")
	else:
		print("wrong")
		
	await get_tree().create_timer(0.75).timeout
	$Button.grab_focus()



var anwer_to_q1
var anwer_to_q2
var anwer_to_q3

func _on_answer_focus_exited():
	anwer_to_q1 = $Answer.text

func _on_answer_2_focus_exited():
	anwer_to_q2 = $Answer2.text
	
func _on_answer_3_focus_exited():
	anwer_to_q3 = $Answer3.text



