extends State


func enter() -> void:
	super()
	parent.bossDied = true
	await animations.animation_finished
	parent.queue_free()

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass


