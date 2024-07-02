extends Node

var health = 10
var max_health = 10
var player_damage = 1
var enemy_damage = 1
var health_power_up = false
var map_power_up = false
var frog_reduced_receive_damage_power_up = false
var frog_more_attack_damage_power_up = false
var frog_shield_power_up = false
var next_question_right_power_up = false

func reset():
	health = max_health
	player_damage = 1
	enemy_damage = 1
	health_power_up = false
	map_power_up = false
	frog_reduced_receive_damage_power_up = false
	frog_more_attack_damage_power_up = false
	frog_shield_power_up = false
	next_question_right_power_up = false
