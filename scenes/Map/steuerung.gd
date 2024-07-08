extends Sprite2D

func _process(delta):
	if player_data.movement:
		self.visible = false
	else:
		self.visible = true
