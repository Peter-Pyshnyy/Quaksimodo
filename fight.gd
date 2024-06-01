extends Node2D

@onready var healthbar = $HealthBar
var rng = RandomNumberGenerator.new()
var player_health
# Called when the node enters the scene tree for the first time.
func _ready():
	player_health = 100
	healthbar.init_health(player_health)
	$Sprite2D/AnimationPlayer.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attack_button_pressed():
	print("works")
	player_health = player_health - rng.randf_range(4.0, 10.0)
	healthbar.health = player_health
