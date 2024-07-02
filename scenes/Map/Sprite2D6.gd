extends Sprite2D


func _process(delta):
	if PlayerDataAl.frog_reduced_receive_damage_power_up:
		self.visible = true
	else:
		self.visible = false
