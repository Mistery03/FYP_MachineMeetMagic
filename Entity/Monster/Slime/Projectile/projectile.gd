extends CharacterBody2D

@export var damagePoint:float = 20
@export var speed: float = 400
@export var life_time: float = 5.0
@export var spread: float = 5.0  # Spread factor for initial position offset
var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	position += Vector2(randf_range(-spread, spread), randf_range(-spread, spread))


func _physics_process(delta):
	velocity = direction * speed * delta
	position += velocity * delta
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body is Player:
		body.OnDamageTaken.emit(damagePoint)
		queue_free()


func _on_timer_timeout():
	queue_free()
