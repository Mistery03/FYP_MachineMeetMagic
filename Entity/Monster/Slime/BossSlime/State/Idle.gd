extends State

var isDamaged:bool = false

func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO
	await get_tree().create_timer(2.5).timeout
	transitioned.emit("chase")

	

func exit() -> void:
	pass


func physics_update(delta: float) -> void:
	parent.move_and_slide()



func _on_boss_slime_on_damage_taken(damageAmount):
	parent.currHealth -= damageAmount
	parent.currHealth = clamp(parent.currHealth,0,parent.maxHP)
	transitioned.emit("damaged")
