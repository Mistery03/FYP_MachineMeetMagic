extends GameMaterial

func _ready():
	sprite.texture = itemData.texture
	if TutorialGlobal.tutorialThree:
		queue_free()
	#amount = itemData.amount

func _on_area_2d_body_entered(body):
	if body is Player:
		pickup_sfx.play()
		body.inventory_manager.insert(self,amount)
		visible = false
		await pickup_sfx.finished
		TutorialGlobal.tutorialThree = true
		
		queue_free()
