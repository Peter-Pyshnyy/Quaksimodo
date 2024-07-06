extends Sprite2D


func _process(delta):
	if PlayerDataAl.frog_more_attack_damage_power_up:
		self.visible = true
	else:
		self.visible = false
