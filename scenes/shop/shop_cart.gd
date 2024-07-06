class_name Cart

extends Node

var item:PlayerDataAl.POWER_UPS
var hp_inc:int
var dmg_inc:int

func _init():
	self.item = 0
	self.hp_inc = PlayerDataAl.max_health
	self.dmg_inc = PlayerDataAl.player_damage


