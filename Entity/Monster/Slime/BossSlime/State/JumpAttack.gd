extends State

@export var projectile: PackedScene
@export var bullet_count: int = 8
@export var shoot_radius: float = 50.0

func enter() -> void:
	super()
	await animations.animation_finished
	shoot_radial()
	transitioned.emit("Chase")

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func shoot_radial() -> void:	
	for i in range(bullet_count):
		var angle = i * (PI * 2 / bullet_count)
		var direction = Vector2(cos(angle), sin(angle))

		var bullet = projectile.instantiate()
	
		bullet.global_position = parent.global_position + direction * shoot_radius
		bullet.direction = direction
		bullet.scale = Vector2(0.8,0.8)
		
		parent.localLevel.add_child(bullet)
