class_name IgnisNormalAttack extends CharacterBody2D

@export var magicData:MagicData
@onready var animation = $AnimatedSprite2D

var target_position = Vector2.ZERO
var speed = 300
var player:Player
var mousePos:Vector2
var direction:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("default")
	await animation.animation_finished
	queue_free()

func _process(delta):
	#mousePos = player.mousePos
	var offset = player.mousePos - global_position
	rotation = atan2(offset.y,offset.x)
	#need to fix
	pass
	
func _physics_process(delta):
	#velocity = -direction * speed
	#global_position += velocity * delta
	shoot_in_direction_of_mouse()
	
func shoot_in_direction_of_mouse() -> void:
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	position = global_position + direction * 5

	
func _on_area_2d_body_entered(body):
	if body is Entity:
		body.OnDamageTaken.emit(magicData.damage)
		pass
	pass # Replace with function body.
