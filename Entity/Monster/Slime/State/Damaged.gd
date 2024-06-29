extends State

@export var chase_probability: float = 40.0
@export var jump_attack_probability: float = 60.0


func enter() -> void:
	super()
	parent.collision_box.set_collision_mask_value(1,true)


func exit() -> void:
	pass

func update(delta: float) -> void:
	var random_value = randi() % 100 # Generate a random value between 0 and 99
	#transitioned.emit("escape")
	await animations.animation_finished
	if random_value < chase_probability:
		transitioned.emit("chase")
	elif random_value < jump_attack_probability + chase_probability:
		await get_tree().create_timer(0.2).timeout
		transitioned.emit("JumpAttack")
	

func physics_update(delta: float) -> void:
	pass


func _on_collision_box_area_entered(area):
	if area is staffMelee:
		parent.currHealth -= area.damagepoint
		parent.currHealth = clamp(parent.currHealth,0,parent.maxHP)
