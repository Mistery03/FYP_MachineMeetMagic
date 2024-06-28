class_name IgnisSkillAttack extends MagicManager

@export var MagicData:Resource
@onready var animation = $AnimatedSprite2D

var target_position = Vector2.ZERO
var speed = 300
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("default")
	await animation.animation_finished
	queue_free()
	
func _process(delta):
	pass
	
func _on_area_2d_body_entered(body):
	if body is Entity:
		body.OnDamageTaken.emit(magicData.damage)
		pass
	pass # Replace with function body.
