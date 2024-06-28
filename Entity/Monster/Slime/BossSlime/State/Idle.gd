extends State

var isDamaged:bool = false

func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO
	await get_tree().create_timer(3).timeout
	transitioned.emit("chase")

	

func exit() -> void:
	pass


func physics_update(delta: float) -> void:
	parent.move_and_slide()



