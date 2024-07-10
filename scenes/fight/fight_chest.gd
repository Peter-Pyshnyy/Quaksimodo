extends Node2D

@onready var input1 = $Answer
@onready var input2 = $Answer2
@onready var input3 = $Answer3
@onready var input4 = $Answer4
@onready var input5 = $Answer5
@onready var lbl_question1 = $Question
@onready var lbl_question2 = $Question2
@onready var lbl_question3 = $Question3
@onready var lbl_question4 = $Question4
@onready var lbl_question5 = $Question5
@onready var option1 = $OptionButton
@onready var option2 = $OptionButton2
@onready var option3 = $OptionButton3
@onready var option4 = $OptionButton4
@onready var option5 = $OptionButton5

var print_inputs = [$Question, $Question2, $Question3]
var option_inputs = [option1,option2,option3]
var question_lbls = [lbl_question1, lbl_question2, lbl_question3]

var current_level
var current_question_number
var current_function:MFunc
var question:Question
var num_of_questions:int
var anwer_to_q1 = ""
var anwer_to_q2 = ""
var anwer_to_q3 = ""
var anwer_to_q4 = ""
var anwer_to_q5 = ""
var player_manager = PlayerManager.new()
var correct = true
var prizes = [
	PlayerDataAl.POWER_UPS.MAP,
	PlayerDataAl.POWER_UPS.FORK,
	PlayerDataAl.POWER_UPS.BUCKET,
	PlayerDataAl.POWER_UPS.TRIANGLE,
	PlayerDataAl.POWER_UPS.FLIES,
	PlayerDataAl.POWER_UPS.TOOTH,
	20
]

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = PlayerDataAl.current_level
	gen_new_questions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func gen_new_questions():
	reset_scene()
	question = Question.new(current_level, true)
	current_function = question.fn
	num_of_questions = question.question_pool.size()
	print(question.fn)
	print(question.question_pool)
	
	$Function.text = "Function: " + current_function.to_string()
	$Question.text = ""
	$Question2.text = ""
	$Question3.text = ""
	$Question4.text = ""
	$Question5.text = ""
	input1.visible = false
	input2.visible = false
	input3.visible = false
	input4.visible = false
	input5.visible = false
	
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
			3:
				$Question4.text = question.question_to_str(n)
				if q in question.q_with_options:
					option4.visible = true
					option4.disabled = false
					
					for opt in question.q_with_options[q]:
						option4.add_item(opt)
				else:
					input4.visible = true
					input4.editable = true
			4:
				$Question5.text = question.question_to_str(n)
				if q in question.q_with_options:
					option5.visible = true
					option5.disabled = false
					
					for opt in question.q_with_options[q]:
						option5.add_item(opt)
				else:
					input5.visible = true
					input5.editable = true

func _on_attack_button_button_up():
	$AttackButton.texture_normal = load("res://assets/fight_scene/attack_btn_inverted.png")
	$AttackButton.position.y -= 2
	$AttackButton.disabled = true
	
	var ans:String = ""
	input1.editable = false
	input2.editable = false
	input3.editable = false
	input4.editable = false
	input5.editable = false
	
	$Answer.grab_focus()
	ans = anwer_to_q1
	if option1.visible:
		ans = str(option1.selected)
	if(ans != null && question.give_answer(0, ans)):
		print("right")
		#Statistics._on_answer_received(true)
		input1.modulate = Color.GREEN
		option1.modulate = Color.GREEN
	else:
		correct = false
		input1.modulate = Color.LIGHT_CORAL
		option1.modulate = Color.LIGHT_CORAL
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
		else:
			correct = false
			input2.modulate = Color.LIGHT_CORAL
			option2.modulate = Color.LIGHT_CORAL
			#Statistics._on_answer_received(false)
			print("wrong")
		await get_tree().create_timer(0.75).timeout
	
	$Answer3.grab_focus()
	if num_of_questions > 2:
		ans = anwer_to_q3
		if option3.visible:
			ans = str(option3.selected)
		if(ans != null && question.give_answer(2, ans)):
			input3.modulate = Color.GREEN
			option3.modulate = Color.GREEN
			#Statistics._on_answer_received(true)
			print("right")
		else:
			correct = false
			input3.modulate = Color.LIGHT_CORAL
			option3.modulate = Color.LIGHT_CORAL
			#Statistics._on_answer_received(false)
			print("wrong")
		await get_tree().create_timer(0.75).timeout
		
	$Answer4.grab_focus()
	if num_of_questions > 2:
		ans = anwer_to_q4
		if option4.visible:
			ans = str(option4.selected)
		if(ans != null && question.give_answer(3, ans)):
			input4.modulate = Color.GREEN
			option4.modulate = Color.GREEN
			#Statistics._on_answer_received(true)
			print("right")
		else:
			correct = false
			input4.modulate = Color.LIGHT_CORAL
			option4.modulate = Color.LIGHT_CORAL
			#Statistics._on_answer_received(false)
			print("wrong")
		await get_tree().create_timer(0.75).timeout
		
	$Answer5.grab_focus()
	if num_of_questions > 2:
		ans = anwer_to_q5
		if option5.visible:
			ans = str(option5.selected)
		if(ans != null && question.give_answer(4, ans)):
			input5.modulate = Color.GREEN
			option5.modulate = Color.GREEN
			#Statistics._on_answer_received(true)
			print("right")
		else:
			correct = false
			input5.modulate = Color.LIGHT_CORAL
			option5.modulate = Color.LIGHT_CORAL
			#Statistics._on_answer_received(false)
			print("wrong")
		await get_tree().create_timer(0.75).timeout
		
	input1.modulate = Color.WHITE
	input2.modulate = Color.WHITE
	input3.modulate = Color.WHITE
	input4.modulate = Color.WHITE
	input5.modulate = Color.WHITE
	option1.modulate = Color.WHITE
	option2.modulate = Color.WHITE
	option3.modulate = Color.WHITE
	option4.modulate = Color.WHITE
	option5.modulate = Color.WHITE
	
	$ColorRect.visible = true
	if correct:
		$Chest.texture = load(str("res://assets/fight_scene/chest_open.png"))
		$ColorRect/lbl_msg.text = "Ihr Preis:"
		$ColorRect/lbl_msg.visible = true
		
		for passive in PlayerDataAl.passives_dict.keys():
			if PlayerDataAl.passives_dict[passive] == true:
				prizes.erase(passive)
		
		var prize = prizes.pick_random()
		
		if prize == 20:
			player_manager.add_money(20)
			$ColorRect/lbl_20G.visible = true
		else:
			PlayerDataAl.activate_power_up(prize)
			$ColorRect/TextureRect.visible = true
			print("PREIS: ", prize)
			$ColorRect/TextureRect.texture = load(str("res://assets/powerups/item_", prize, ".png"))
			
			if prize == 3 || prize == 4:
				$ColorRect/lbl_amount.visible = true
		
	else:
		$ColorRect/lbl_msg.text = "Schade!"
		$ColorRect/lbl_msg.visible = true
	
	
	await get_tree().create_timer(1.5).timeout
	
	MapAutoload.active_sqr.roomType = Square.ROOMS.PATH
	Transition.transition_scene("res://scenes/Map/Map.tscn")


func _on_answer_focus_entered():
	if $Answer.text != null:
		anwer_to_q1 = $Answer.text


func _on_answer_2_focus_entered():
	if $Answer2.text != null:
		anwer_to_q2 = $Answer2.text


func _on_answer_3_focus_entered():
	if $Answer3.text != null:
		anwer_to_q3 = $Answer3.text


func _on_answer_4_focus_entered():
	if $Answer4.text != null:
		anwer_to_q4 = $Answer4.text


func _on_answer_5_focus_entered():
	if $Answer5.text != null:
		anwer_to_q5 = $Answer5.text


func reset_scene():
	$AttackButton.texture_normal = load("res://assets/fight_scene/attack_btn.png")
	$Question.text = ""
	$Question2.text = ""
	$Question3.text = ""
	$Question4.text = ""
	$Question5.text = ""
	option1.clear()
	option2.clear()
	option3.clear()
	option4.clear()
	option5.clear()
	input1.text = ""
	input2.text = ""
	input3.text = ""
	input4.text = ""
	input5.text = ""
	input1.visible = false
	input2.visible = false
	input3.visible = false
	input4.visible = false
	input5.visible = false
	option1.visible = false
	option2.visible = false
	option3.visible = false
	option4.visible = false
	option5.visible = false
	$AttackButton.disabled = false

func _on_attack_button_button_down():
	$AttackButton.position.y += 2


func _on_help_button_button_down():
	$HelpButton.position.y += 2


func _on_help_button_button_up():
	$HelpButton.position.y -= 2
