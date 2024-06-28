extends State


func enter() -> void:
	super()
	parent.collision_box.set_collision_mask_value(1,true)


func exit() -> void:
	pass

func update(delta: float) -> void:
	#transitioned.emit("escape")
	await animations.animation_finished
	transitioned.emit("chase")
	

func physics_update(delta: float) -> void:
	pass


func _on_collision_box_area_entered(area):
	if area is staffMelee:
		parent.currHealth -= area.damagepoint
		parent.currHealth = clamp(parent.currHealth,0,parent.maxHP)
