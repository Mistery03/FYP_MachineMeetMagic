class_name IgnisNormalAttack extends Area2D

@export var magicData:MagicData
@export var steer_force = 50.0
@export var speed = 300
@onready var animation = $AnimatedSprite2D

var acceleration = Vector2.ZERO

var target_position = Vector2.ZERO

var player:Player
var mousePos:Vector2
var direction:Vector2
var staff:Node2D
var velocity = Vector2.ZERO

var mouse_position

var travel_distance: float = 500

var target_reached: bool = false

var target = null

var isHitCount:int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var mouse_position = player.get_global_mouse_position()

	direction = (mouse_position - global_position).normalized()
	rotation = atan2(direction.y, direction.x)
	animation.play("Fireball")
	await animation.animation_finished
	queue_free()

func _process(delta):
	mouse_position = player.get_global_mouse_position()
	direction = (mouse_position - global_position).normalized()

	if isHitCount >2:
		queue_free()
	#mousePos = player.mousePos

func _physics_process(delta):
	shoot_in_direction_of_mouse(delta)



func shoot_in_direction_of_mouse(delta) -> void:
	if direction != Vector2.ZERO:
		rotation = atan2(direction.y, direction.x)
		velocity = direction * speed * delta
		position += velocity * delta


func _on_body_entered(body):
	if body is Entity:
		body.OnDamageTaken.emit(magicData.damage)
		isHitCount += 1
