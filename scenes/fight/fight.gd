extends Node2D

@onready var healthbar_enemy = $HealthBarEnemy
@onready var healthbar_frog = $HealthBarFrog
@onready var input1 = $Answer
@onready var input2 = $Answer2
@onready var input3 = $Answer3
@onready var option1 = $OptionButton
@onready var option2 = $OptionButton2
@onready var option3 = $OptionButton3
var rng = RandomNumberGenerator.new()
var enemy_health
var frog_health
var current_level
var current_question_number
var current_function:MFunc
var question:Question
var num_of_questions:int
var anwer_to_q1 = ""
var anwer_to_q2 = ""
var anwer_to_q3 = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = 1
	current_question_number = 1
	frog_health = PlayerDataAl.health
	enemy_health = Levels.LevelDatabase[str(current_level)].enemy_health

	healthbar_enemy.init_health(enemy_health)
	healthbar_frog.init_health(10)
	healthbar_frog.health = frog_health
	$Enemy/AnimationPlayer.play("idle")
	$Frog/AnimationPlayer.play("idle")
	$Background/AnimationPlayer.play("idle")
	gen_new_questions()
	load_sprites()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func gen_new_questions():
	input1.visible = true
	reset_option_visible()
	question = Question.new(current_level)
	current_function = question.fn
	num_of_questions = question.question_pool.size()
	print(question.fn)
	print(question.question_pool)
	
	
	
	$Question2.text = ""
	$Question3.text = ""
	
	input1.text = ""
	input2.text = ""
	input3.text = ""
	input1.editable = true
	input2.editable = true
	input3.editable = true
	input2.visible = false
	input3.visible = false
	
	$Function.text = "Function: " + current_function.to_string()
	$Question.text = question.question_to_str(0)
	$Question2.text = ""
	$Question3.text = ""
	
	if num_of_questions == 2:
		$Question2.text = question.question_to_str(1)
		input2.visible = true
	elif num_of_questions == 3:
		$Question2.text = question.question_to_str(1)
		$Question3.text = question.question_to_str(2)
		input2.visible = true
		input3.visible = true

func _on_attack_button_pressed():
	input1.editable = false
	input2.editable = false
	input3.editable = false
	
	$Answer.grab_focus()
	if(anwer_to_q2 != null && question.give_answer(0, anwer_to_q1)):
		print("right")
		Statistics._on_answer_received(true)
		$Answer.modulate = Color.GREEN
		hurt_enemy()
	else:
		$Answer.modulate = Color.LIGHT_CORAL
		hurt_frog()
		Statistics._on_answer_received(false)
		print("wrong")
	
	await get_tree().create_timer(0.75).timeout
	
	$Answer2.grab_focus()
	if num_of_questions > 1:
		if(anwer_to_q2 != null && question.give_answer(1, anwer_to_q2)):
			print("right")
			Statistics._on_answer_received(true)
			$Answer2.modulate = Color.GREEN
			hurt_enemy()
		else:
			$Answer2.modulate = Color.LIGHT_CORAL
			hurt_frog()
			Statistics._on_answer_received(false)
			print("wrong")
	
		await get_tree().create_timer(0.75).timeout
	
	$Answer3.grab_focus()
	if num_of_questions > 2:
		print("HEREER")
		if(anwer_to_q3 != null && question.give_answer(2, anwer_to_q3)):
			$Answer3.modulate = Color.GREEN
			Statistics._on_answer_received(true)
			hurt_enemy()
			print("right")
		else:
			$Answer3.modulate = Color.RED
			Statistics._on_answer_received(false)
			hurt_frog()
			print("wrong")
		
		await get_tree().create_timer(0.75).timeout
	$Answer.modulate = Color.WHITE
	$Answer2.modulate = Color.WHITE
	$Answer3.modulate = Color.WHITE
	if(enemy_health <= 0):
		MapAutoload.active_sqr.completed = true
		get_tree().change_scene_to_file("res://scenes/map/Map.tscn")
	elif(frog_health <= 0):
		MapAutoload.reset()
		PlayerDataAl.reset()
		get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
	else:
		gen_new_questions()

func hurt_frog():
	frog_health = frog_health - 1
	healthbar_frog.health = frog_health
	$Frog.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Frog.modulate = Color.WHITE
	PlayerDataAl.health = frog_health
	
func hurt_enemy():
	enemy_health = enemy_health - 1
	healthbar_enemy.health = enemy_health
	$Enemy.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Enemy.modulate = Color.WHITE

func _on_answer_focus_exited():
	#if $Answer.text != null:
		#anwer_to_q1 = $Answer.text
		pass

func _on_answer_2_focus_exited():
	#if $Answer2.text != null:
		#anwer_to_q2 = $Answer2.text
	pass
	
func _on_answer_3_focus_exited():
	#if $Answer3.text != null:
		#anwer_to_q3 = $Answer3.text
	pass

func _on_answer_focus_entered():
	if $Answer.text != null:
		anwer_to_q1 = $Answer.text


func _on_answer_2_focus_entered():
	if $Answer2.text != null:
		anwer_to_q2 = $Answer2.text


func _on_answer_3_focus_entered():
	if $Answer3.text != null:
		anwer_to_q3 = $Answer3.text

	
func turn_input_to_option(options: Array, input_nr: int):
	var option_button
	var input
	match input_nr:
		1:
			option_button = option1
			input = input1
		2: 
			option_button = option2
			input = input2
		3: 
			option_button = option3
			input = input3
	
	option_button.visible = true
	input.visible = false
	option_button.clear()
	for item in options:
		option_button.add_item(item)

func reset_option_visible():
	option1.visible = false
	option2.visible = false
	option3.visible = false


func _on_option_button_item_selected(index):
	anwer_to_q1 = option1.get_item_text(index)


func _on_option_button_2_item_selected(index):
	anwer_to_q2 = option2.get_item_text(index)


func _on_option_button_3_item_selected(index):
	anwer_to_q3 = option3.get_item_text(index)
	
func load_sprites():
	var path = "res://assets/fight_scene/enemy_sheet_" + str(rng.randi_range(1,3)) + ".png"
	$Enemy.texture = load(path)
	match current_level:
		1:
			$Background.texture = load("res://assets/fight_scene/background_animation_darker.png")
		2:
			$Background.texture = load("res://assets/fight_scene/dawn_animation.png")
		3:
			$Background.texture = load("res://assets/fight_scene/night_animation.png")
			
