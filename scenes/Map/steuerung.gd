extends Sprite2D

var movement = player_data.movement

func _process(delta):
	if player_data.movement:
		self.visible = false
	else:
		self.visible = true
