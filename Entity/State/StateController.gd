class_name StateMachine
extends Node

@export var current_state: State
var states: Dictionary = {}

func init(parent: Entity, animations: AnimatedSprite2D, moveComponent = null,camera:Camera2D = null) -> void:
	for child in get_children():
		child.parent = parent
		child.animations = animations
		if parent is Player:
			child.moveComponent = moveComponent
			child.camera = camera
	current_state.enter()

func _ready():
	for child in get_children():
		if child is State:
			# Add the state to the `Dictionary` using its `name`
			states[child.name] = child
 
			# Connect the state machine to the `transitioned` signal of all children
			child.transitioned.connect(on_child_transitioned)
		else:
			push_warning("State machine contains child which is not 'State'")
			child.queue_free()
			
	# Start execution of the initial state
	

func on_child_transitioned(new_state_name: StringName) -> void:
	# Get the next state from the `Dictionary`
	var new_state = states.get(new_state_name.to_pascal_case())
	print(new_state_name)
	if new_state != null:
		if new_state != current_state:
			# Exit the current state
			current_state.exit()
 
			# Enter the new state
			new_state.enter()
 
			# Update the current state to the new one
			current_state = new_state
	else:
		push_warning("Called transition on a state that does not exist")

func _process(delta):
	current_state.update(delta)
		
func _physics_process(delta):
	current_state.physics_update(delta)

func _unhandled_input(event):
	current_state.process_input(event)
