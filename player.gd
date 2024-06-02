extends CharacterBody2D

var input_movement = Vector2.ZERO
var direction = Vector2.ZERO

var speed = 70
var health = player_data.health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move()
	update_move_anim()

func move():
	input_movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_movement != Vector2.ZERO:
		velocity = input_movement * speed
		
	if input_movement == Vector2.ZERO:
		velocity = Vector2.ZERO
		
	move_and_slide()
	
func update_move_anim():
	if input_movement != Vector2.ZERO:
		if Input.is_action_pressed("ui_right"):
			direction = Vector2(1, 0)
			$anim.play("WalkRight")
		if Input.is_action_pressed("ui_left"):
			direction = Vector2(-1, 0)
			$anim.play("WalkLeft")
		if Input.is_action_pressed("ui_up"):
			direction = Vector2(0, -1)
			$anim.play("WalkUp")
		if Input.is_action_pressed("ui_down"):
			direction = Vector2(0, 1)
			$anim.play("WalkDown")
