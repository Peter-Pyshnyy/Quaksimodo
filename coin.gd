extends Area2D




func _on_body_entered(body):
	if body.name == "Player":
		player_data.coins += 1
		print(player_data.coins)
		queue_free()
