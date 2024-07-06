extends Node2D

@onready var healthbar_enemy = $HealthBarEnemy
@onready var healthbar_frog = $HealthBarFrog
var rng = RandomNumberGenerator.new()
var enemy_health
var frog_health
var current_level
var current_question_number
# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = 1
	current_question_number = 1
	frog_health = PlayerDataAl.health
	enemy_health = Levels.LevelDatabase[str(current_level)].enemy_health

	healthbar_enemy.init_health(enemy_health)
	healthbar_frog.init_health(PlayerDataAl.max_health)
	healthbar_frog.health = frog_health
	load_questions()
	$Enemy/AnimationPlayer.play("idle")
	$Frog/AnimationPlayer.play("idle")
	$background/AnimationPlayer.play("idle")
	DialogueManager.show_dialogue_balloon(load("res://dialogue/tutorial.dialogue"),"storch_battle_start")


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
		print("right")
		$Answer.modulate = Color.GREEN
		hurt_enemy()
	else:
		$Answer.modulate = Color.RED
		hurt_frog()
		print("wrong")
	
	await get_tree().create_timer(0.75).timeout
	
	$Answer2.grab_focus()
	if(anwer_to_q2 == Levels.QuestionDatabase[str(current_question_number)].a2):
		print("right")
		$Answer2.modulate = Color.GREEN
		hurt_enemy()
	else:
		$Answer2.modulate = Color.RED
		hurt_frog()
		print("wrong")
	
	await get_tree().create_timer(0.75).timeout
	
	$Answer3.grab_focus()
	if(anwer_to_q3 == Levels.QuestionDatabase[str(current_question_number)].a3):
		$Answer3.modulate = Color.GREEN
		hurt_enemy()
		print("right")
	else:
		$Answer3.modulate = Color.RED
		hurt_frog()
		print("wrong")
		
	await get_tree().create_timer(0.75).timeout
	$Answer.modulate = Color.WHITE
	$Answer2.modulate = Color.WHITE
	$Answer3.modulate = Color.WHITE
	$Button.grab_focus()
	if(enemy_health <= 0):
		MapAutoload.active_sqr.roomType = Square.ROOMS.PATH
		activate_random_power_up()
		get_tree().change_scene_to_file("res://scenes/map/Map.tscn")
		DialogueManager.show_dialogue_balloon(load("res://dialogue/tutorial.dialogue"),"storch_battle_victory")
	elif(frog_health <= 0):
		MapAutoload.reset()
		PlayerDataAl.reset()
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
		DialogueManager.show_dialogue_balloon(load("res://dialogue/tutorial.dialogue"),"storch_battle_failure")
	else:
		if(current_question_number == 3 ):
			current_question_number = 1
		else:
			current_question_number += 1
		load_questions()

func hurt_frog():
	frog_health = frog_health - PlayerDataAl.enemy_damage
	healthbar_frog.health = frog_health
	$Frog.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Frog.modulate = Color.WHITE
	PlayerDataAl.health = frog_health
	
func hurt_enemy():
	enemy_health = enemy_health - PlayerDataAl.player_damage
	healthbar_enemy.health = enemy_health
	$Enemy.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Enemy.modulate = Color.WHITE

var anwer_to_q1
var anwer_to_q2
var anwer_to_q3

func _on_answer_focus_exited():
	anwer_to_q1 = $Answer.text

func _on_answer_2_focus_exited():
	anwer_to_q2 = $Answer2.text
	
func _on_answer_3_focus_exited():
	anwer_to_q3 = $Answer3.text

func activate_random_power_up():
	var power_up = randi() % 6
	match power_up:
		0:
			set_health_power_up()
		1:
			set_map_power_up()
		2:
			set_frog_reduced_receive_damage_power_up()
		3:
			set_frog_more_attack_damage_power_up()
		4:
			set_frog_shield_power_up()
		5:
			set_next_question_right_power_up()
	print("Zufälliges Power-Up aktiviert: ", power_up)
	
func set_health_power_up():
	PlayerDataAl.health_power_up = true

func set_map_power_up():
	PlayerDataAl.map_power_up = true

func set_frog_reduced_receive_damage_power_up():
	PlayerDataAl.frog_reduced_receive_damage_power_up = true

func set_frog_more_attack_damage_power_up():
	PlayerDataAl.frog_more_attack_damage_power_up = true

func set_frog_shield_power_up():
	PlayerDataAl.frog_shield_power_up = true

func set_next_question_right_power_up():
	PlayerDataAl.next_question_right_power_up = true
