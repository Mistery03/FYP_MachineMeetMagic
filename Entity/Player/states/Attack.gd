extends State

var currStateName:String
var actionPressed:bool = false

func enter() -> void:
	super()
	if parent.get_local_mouse_position().y > 0:
		parent.staff.customAnimation.play("SWINGFRONT")

	elif parent.get_local_mouse_position().y < 0: 
		parent.staff.customAnimation.play("SWINGBACK")
		
	parent.canInput = false
	actionPressed = false

	 
	

func exit() -> void:
	pass
	
func update(delta: float) -> void:
	await get_tree().create_timer(0.4).timeout
	transitioned.emit("idle")
	

func physics_update(delta: float) -> void:
	pass


