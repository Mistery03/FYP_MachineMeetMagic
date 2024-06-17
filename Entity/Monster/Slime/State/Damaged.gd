extends State

var escapeChance = 100  # 50% chance to escape
var timeSinceLastDamage = 0.0
var escapeDuration = 5.0  # Time to wait before returning to the normal state
var hasEscaped = false

func enter() -> void:
	super()
	timeSinceLastDamage = 0.0
	hasEscaped = false
	
	#if randi() % 100 < escapeChance:
		#transitioned.emit("escape")
	#else:
		#transitioned.emit("attack")

func exit() -> void:
	pass

func update(delta: float) -> void:
	#transitioned.emit("escape")
	await animations.animation_finished
	transitioned.emit("chase")
	

func physics_update(delta: float) -> void:
	pass

func process_input(event)->void:
	pass

