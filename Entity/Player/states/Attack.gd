extends State

var actionPressed:bool = false

func enter() -> void:
	super()
	parent.staff.melee_hitbox.monitorable = true
	if parent.get_local_mouse_position().y > 0:
		parent.staff.customAnimation.play("SWINGFRONT")
	elif parent.get_local_mouse_position().y < 0:
		parent.staff.customAnimation.play("SWINGBACK")
	elif parent.get_local_mouse_position().x > 0:
		parent.staff.customAnimation.play("SWINGFRONT")
	elif parent.get_local_mouse_position().x < 0:
		parent.staff.customAnimation.play("SWINGBACK")

	parent.canInput = false
	actionPressed = false

func exit() -> void:
	#parent.staff.melee_hitbox.monitorable = false
	parent.staff.melee_hitbox.set_deferred("monitorable",false)
	parent.wasAttacking = true
	parent.canInput = true

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	lerp_to_zero()

	if !parent.staff.customAnimation.is_playing():
		transitioned.emit("idle")

func lerp_to_zero():
	# Gradually lerp the velocity to 0
	parent.velocity.x = lerp(parent.velocity.x, 0.0, 0.2)
	parent.velocity.y = lerp(parent.velocity.y, 0.0, 0.2)

# Check if the velocity is close enough to 0
	if abs(parent.velocity.x) < 0.01:
		parent.velocity.x = 0.0

