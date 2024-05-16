extends Control

@export var player:Player
@export var animation:AnimationPlayer
@onready var timer = $Timer


var isPressing:bool = false
func _ready():
	await get_tree().create_timer(0.5).timeout
	if player.localLevel.levelName == "Home":
		animation.play("fadeOut")
		


	

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("EQUIP") and !player.isMachineUI:
			animation.play("popIn")
			timer.start()
	
	


func _on_timer_timeout():
	animation.play("fadeOut")
