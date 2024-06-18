extends State


func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO

func exit() -> void:
	pass

func update(delta: float) -> void:
	await animations.animation_finished
	transitioned.emit("idle")

func physics_update(delta: float) -> void:
	pass

func process_input(event)->void:
	pass
