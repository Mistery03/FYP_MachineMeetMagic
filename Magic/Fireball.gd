class_name Fireball extends Projectile

func _on_body_entered(body):
	if body is Entity:
		body.OnDamageTaken.emit(damagePoint)
		queue_free()
