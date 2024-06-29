class_name Fireball extends Projectile

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.rotation = 3.142/2.0
	animated_sprite_2d.play("Fireball")

func _on_body_entered(body):
	if body is Entity:
		body.OnDamageTaken.emit(damagePoint)
		queue_free()
