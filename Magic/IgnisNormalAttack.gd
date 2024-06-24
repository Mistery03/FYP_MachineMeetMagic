class_name IgnisNormalAttack extends MagicManager

@export var MagicData:Resource
@onready var animation = $AnimatedSprite2D

var target_position = Vector2.ZERO
var speed = 300
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("default")

	set_process(true) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass
	#play animation
	
	
	  
