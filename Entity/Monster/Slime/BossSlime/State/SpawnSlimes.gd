extends State


func enter() -> void:
	super()
	if parent.localLevel.levelName == "BossRoom":
		pass
	else:
		print("Invalid level spawn area")
		transitioned.emit("Chase")
		
func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

