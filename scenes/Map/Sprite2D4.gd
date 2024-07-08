extends Sprite2D


func _process(delta):
	if PlayerDataAl.health_power_up:
		self.visible = true
	else:
		self.visible = false
