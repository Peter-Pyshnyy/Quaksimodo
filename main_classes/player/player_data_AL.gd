extends Node

var health = 10
var max_health = 10
var player_damage = 1
var enemy_damage = 1

enum POWER_UPS {MAP, FORK, BUCKET, TRIANGLE, FLIES, CHEAT_SHEET, NONE}

#active power-ups
var heal = 0
var shield = 0
var cheat_sheet = 0

#passive power-ups
var passives_dict = {
	POWER_UPS.MAP: false,
	POWER_UPS.FORK: false,
	POWER_UPS.BUCKET: false,
}



func activate_power_up(index:POWER_UPS):
	match index:
		0,1,2:
			self.passives_dict[index] = true
		3:
			self.shield += 2
		4:
			self.heal += 2
		5: 
			self.cheat_sheet += 1
		_:
			return
		

func reset():
	health = max_health
	player_damage = 1
	enemy_damage = 1
	heal = 0
	shield = 0
	cheat_sheet = 0
	
	for power_up in passives_dict.keys():
		passives_dict[power_up] = false
