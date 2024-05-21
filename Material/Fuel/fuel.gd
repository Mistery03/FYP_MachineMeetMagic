extends GameMaterial



func _on_area_2d_body_entered(body):
	if body is Player:
		body.inventory_manager.insert(self,amount)
		queue_free()
