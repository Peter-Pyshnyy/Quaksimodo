extends Node2D

@onready var healthbar_enemy = $HealthBarEnemy
@onready var healthbar_frog = $HealthBarFrog
@onready var input1 = $Answer
@onready var input2 = $Answer2
@onready var input3 = $Answer3
@onready var lbl_question1 = $Question
@onready var lbl_question2 = $Question2
@onready var lbl_question3 = $Question3
@onready var option1 = $OptionButton
@onready var option2 = $OptionButton2
@onready var option3 = $OptionButton3
@onready var lbl_triangle = $Item3/lbl_triangle
@onready var lbl_flies = $Item4/lbl_flies
@onready var lbl_tooth = $Item5/lbl_tooth

var print_inputs = [$Question, $Question2, $Question3]
var option_inputs = [option1,option2,option3]
var question_lbls = [lbl_question1, lbl_question2, lbl_question3]

var enemy = "euler"
var rng = RandomNumberGenerator.new()
var enemy_health
var enemy_damage
var frog_health
var current_level
var current_question_number
var current_function:MFunc
var question:Question
var num_of_questions:int
var anwer_to_q1 = ""
var anwer_to_q2 = ""
var anwer_to_q3 = ""
var player_manager = PlayerManager.new()
var triangle_active = false
var enemy_max_hp

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = PlayerDataAl.current_level
	frog_health = PlayerDataAl.health
	load_enemy()
	healthbar_frog.init_health(PlayerDataAl.max_health)
	healthbar_frog.health = frog_health
	$Enemy/AnimationPlayer.play("idle")
	$Frog/AnimationPlayer.play("idle")
	$Background/AnimationPlayer.play("idle")
	
	lbl_triangle.text = str(PlayerDataAl.shield)
	lbl_flies.text = str(PlayerDataAl.heal)
	lbl_tooth.text = str(PlayerDataAl.tooth)

	gen_new_questions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func gen_new_questions():
	reset_scene()
	question = Question.new(current_level)
	current_function = question.fn
	num_of_questions = question.question_pool.size()
	print(question.fn)
	print(question.question_pool)
	
	$Function.text = "Funktion: " + current_function.to_string()
	$Question.text = ""
	$Question2.text = ""
	$Question3.text = ""
	input1.visible = false
	input2.visible = false
	input3.visible = false
	
	for n in num_of_questions:
		var q = question.question_pool.keys()[n]
		match n:
			0:
				$Question.text = question.question_to_str(n)
				if q in question.q_with_options:
					option1.visible = true
					option1.disabled = false
					
					for opt in question.q_with_options[q]:
						option1.add_item(opt)
					
				else:
					input1.visible = true
					input1.editable = true
			1:
				$Question2.text = question.question_to_str(n)
				if q in question.q_with_options:
					option2.visible = true
					option2.disabled = false
					
					for opt in question.q_with_options[q]:
						option2.add_item(opt)
				else:
					input2.visible = true
					input2.editable = true
			2:
				$Question3.text = question.question_to_str(n)
				if q in question.q_with_options:
					option3.visible = true
					option3.disabled = false
					
					for opt in question.q_with_options[q]:
						option3.add_item(opt)
				else:
					input3.visible = true
					input3.editable = true

func _on_attack_button_button_up():
	$AttackButton.texture_normal = load("res://assets/fight_scene/attack_btn_inverted.png")
	$AttackButton.position.y -= 2
	$AttackButton.disabled = true
	
	var ans:String = ""
	input1.editable = false
	input2.editable = false
	input3.editable = false
	$Item3/btn_triangle.disabled = true
	$Item4/btn_flies.disabled = true
	$Item5/btn_tooth.disabled = true
	#option1.disabled = true
	#option2.disabled = true
	#option3.disabled = true
	
	$Answer.grab_focus()
	ans = anwer_to_q1
	if option1.visible:
		ans = str(option1.selected)
	if(ans != null && question.give_answer(0, ans)):
		print("right")
		#Statistics._on_answer_received(true)
		input1.modulate = Color.GREEN
		option1.modulate = Color.GREEN
		hurt_enemy()
	else:
		input1.modulate = Color.LIGHT_CORAL
		option1.modulate = Color.LIGHT_CORAL
		hurt_frog()
		#Statistics._on_answer_received(false)
		print("wrong")
	
	await get_tree().create_timer(0.75).timeout
	
	$Answer2.grab_focus()
	if num_of_questions > 1:
		ans = anwer_to_q2
		if option2.visible:
			ans = str(option2.selected)
		if(ans != null && question.give_answer(1, ans)):
			print("right")
			#Statistics._on_answer_received(true)
			input2.modulate = Color.GREEN
			option2.modulate = Color.GREEN
			hurt_enemy()
		else:
			input2.modulate = Color.LIGHT_CORAL
			option2.modulate = Color.LIGHT_CORAL
			hurt_frog()
			#Statistics._on_answer_received(false)
			print("wrong")
	
		await get_tree().create_timer(0.75).timeout
	
	$Answer3.grab_focus()
	if num_of_questions > 2:
		ans = anwer_to_q3
		if option3.visible:
			ans = str(option3.selected)
			print("ANS3: ", ans)
		if(ans != null && question.give_answer(2, ans)):
			input3.modulate = Color.GREEN
			option3.modulate = Color.GREEN
			#Statistics._on_answer_received(true)
			hurt_enemy()
			print("right")
		else:
			input3.modulate = Color.LIGHT_CORAL
			option3.modulate = Color.LIGHT_CORAL
			#Statistics._on_answer_received(false)
			hurt_frog()
			print("wrong")
		
		await get_tree().create_timer(0.75).timeout
	input1.modulate = Color.WHITE
	input2.modulate = Color.WHITE
	input3.modulate = Color.WHITE
	option1.modulate = Color.WHITE
	option2.modulate = Color.WHITE
	option3.modulate = Color.WHITE
	if(enemy_health <= 0):
		PlayerDataAl.money += 1 + current_level
		MapAutoload.active_sqr.roomType = Square.ROOMS.PATH
		DialogueManager.show_dialogue_balloon(load("res://dialogue/tutorial.dialogue"),"%s_battle_victory" %enemy)
		
	elif(frog_health <= 0):
		MapAutoload.reset()
		PlayerDataAl.reset()
		DialogueManager.show_dialogue_balloon(load("res://dialogue/tutorial.dialogue"),"%s_battle_failure" %enemy)
	else:
		PlayerDataAl.shield_active = false
		gen_new_questions()

func hurt_frog():
	frog_health = player_manager.take_damage(enemy_damage + randi_range(-2, 2))
	
	healthbar_frog.health = frog_health
	$Frog.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Frog.modulate = Color.WHITE
	
func hurt_enemy():
	enemy_health = enemy_health - player_manager.deal_damage()
	healthbar_enemy.health = enemy_health
	$Enemy.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Enemy.modulate = Color.WHITE

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

func reset_scene():
	$AttackButton.texture_normal = load("res://assets/fight_scene/attack_btn.png")
	$AttackButton.disabled = false
	$Question.text = ""
	$Question2.text = ""
	$Question3.text = ""
	option1.clear()
	option2.clear()
	option3.clear()
	input1.text = ""
	input2.text = ""
	input3.text = ""
	input1.visible = false
	input2.visible = false
	input3.visible = false
	option1.visible = false
	option2.visible = false
	option3.visible = false
	$Item3/btn_triangle.disabled = false
	$Item4/btn_flies.disabled = false
	$Item5/btn_tooth.disabled = false

func _on_option_button_item_focused(index):
	print("FICUS")
	anwer_to_q1 = str(index)


func _on_option_button_2_item_focused(index):
	print("FICUS")
	anwer_to_q2 = str(index)


func _on_option_button_3_item_focused(index):
	print("FICUS")
	anwer_to_q3 = str(index)


func _on_btn_triangle_pressed():
	if PlayerDataAl.shield > 0 && PlayerDataAl.shield_active == false:
		PlayerDataAl.shield_active = true
		PlayerDataAl.shield -= 1
		lbl_triangle.text = str(PlayerDataAl.shield)


func _on_btn_triangle_mouse_entered():
	$Item3.position.y -= 1


func _on_btn_triangle_mouse_exited():
	$Item3.position.y += 1


func _on_btn_flies_mouse_entered():
	$Item4.position.y -= 1


func _on_btn_flies_mouse_exited():
	$Item4.position.y += 1


func _on_btn_tooth_mouse_entered():
	$Item5.position.y -= 1


func _on_btn_tooth_mouse_exited():
	$Item5.position.y += 1


func _on_btn_flies_pressed():
	if PlayerDataAl.heal > 0 && frog_health != PlayerDataAl.max_health:
		player_manager.heal_hp()
		PlayerDataAl.heal -= 1
		lbl_flies.text = str(PlayerDataAl.heal)
		frog_health = PlayerDataAl.health
		healthbar_frog.health = frog_health


func _on_btn_tooth_pressed():
	if PlayerDataAl.tooth > 0:
		$Enemy.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$Enemy.modulate = Color.WHITE
	
		enemy_health -= round(float(enemy_max_hp)/2)
		PlayerDataAl.tooth -= 1
		lbl_tooth.text = str(PlayerDataAl.tooth)
		healthbar_enemy.health = enemy_health
		
		if(enemy_health <= 0):
			MapAutoload.active_sqr.roomType = Square.ROOMS.PATH
			Transition.transition_scene("res://scenes/Map/Map.tscn")
	
func load_enemy():
	match rng.randi_range(1,3):
		1:
			enemy = "storch"
		2:
			enemy = "bieber"
		3:
			enemy = "igel"
		_:
			enemy = "euler"
	var path = "res://assets/fight_scene/enemy_sheet_%s.png" %enemy
	DialogueManager.show_dialogue_balloon(load("res://dialogue/tutorial.dialogue"),"%s_battle_start" %enemy)
	$Enemy.texture = load(path)
	enemy_max_hp = Levels.LevelDatabase[str(current_level)].enemy_health 
	enemy_damage = Levels.LevelDatabase[str(current_level)].enemy_damage
	enemy_health = enemy_max_hp
	healthbar_enemy.init_health(enemy_health)
	match current_level:
		1:
			$Background.texture = load("res://assets/fight_scene/background_animation_darker.png")
		2:
			$Background.texture = load("res://assets/fight_scene/dawn_animation.png")
		3:
			$Background.texture = load("res://assets/fight_scene/night_animation.png")



func _on_attack_button_button_down():
	$AttackButton.position.y += 2


func _on_help_button_button_down():
	$HelpButton.position.y += 2


func _on_help_button_button_up():
	$HelpButton.position.y -= 2
	DialogueManager.show_dialogue_balloon(load("res://dialogue/tutorial.dialogue"),"tutorial_start")
