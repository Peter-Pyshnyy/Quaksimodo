class_name PlayerManager

extends Node

func _ready():
	pass

func set_player_damage(damage):
	PlayerDataAl.player_damage = damage

func health_power_up():
	if PlayerDataAl.health_power_up:
		PlayerDataAl.health = PlayerDataAl.max_health
		PlayerDataAl.health_power_up = false

func map_power_up():
	if PlayerDataAl.map_power_up:
		print("map")
		PlayerDataAl.map_power_up = false
		
func frog_reduced_receive_damage_power_up():
	if PlayerDataAl.frog_reduced_receive_damage_power_up:
		PlayerDataAl.enemy_damage = PlayerDataAl.enemy_damage/2
		PlayerDataAl.frog_reduced_receive_damage_power_up = false

func frog_more_attack_damage_power_up():
	if PlayerDataAl.frog_more_attack_damage_power_up:
		PlayerDataAl.player_damage += 2
		PlayerDataAl.frog_more_attack_damage_power_up = false
		
func frog_shield_power_up():
	if PlayerDataAl.frog_shield_power_up:
		PlayerDataAl.enemy_damage = 0
		PlayerDataAl.frog_shield_power_up = false

func next_question_right_power_up():
	if PlayerDataAl.next_question_right_power_up:
		print("All Question right")
		PlayerDataAl.next_question_right_power_up = false


func take_damage(damage:int) -> int:
	if PlayerDataAl.passives_dict[PlayerDataAl.POWER_UPS.BUCKET]:
		PlayerDataAl.health -= round(damage/1.5)
		return PlayerDataAl.health
	else:
		PlayerDataAl.health -= damage
		return PlayerDataAl.health

func deal_damage() -> int:
	if PlayerDataAl.passives_dict[PlayerDataAl.POWER_UPS.FORK]:
		return round(PlayerDataAl.player_damage*1.5)
	else:
		return PlayerDataAl.player_damage
