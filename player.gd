extends CharacterBody2D

var input_movement = Vector2.ZERO
var direction = Vector2.ZERO

var speed = 70
var health = player_data.health
var coin_count = player_data.coins

func _ready():
	pass

func _physics_process(delta):
	move(delta)

func move(delta):
	input_movement = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_movement != Vector2.ZERO:
		velocity = input_movement * speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()
		
func heal_life(amount):
	health += amount

func die():
	queue_free()

func collect_coin():
	coin_count += 1
