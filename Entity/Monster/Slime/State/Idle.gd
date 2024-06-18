extends State

var isDamaged:bool = false

func enter() -> void:
	super()
	parent.collision_box.set_collision_mask_value(1,false)
	

func exit() -> void:
	pass

func update(delta: float) -> void:
	randomize()
	if parent.currHealth <= 0:
		transitioned.emit("death")
		
	await get_tree().create_timer(5).timeout
	if !isDamaged:
		transitioned.emit("Wander")

func physics_update(delta: float) -> void:
	parent.move_and_slide()


func _on_collision_box_area_entered(area):
	if area is staffMelee:
		isDamaged = true
		transitioned.emit("damaged")
