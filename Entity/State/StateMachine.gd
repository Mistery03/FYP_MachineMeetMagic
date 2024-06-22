class_name StateMachine
extends Node

@export var current_state: State

var states: Dictionary = {}

func init(parent: Entity, animations: AnimatedSprite2D, moveComponent = null,camera:Camera2D = null) -> void:
	for state in get_children():
		if state is State or state.is_class("State"):
			# Add the state to the `Dictionary` using its `name`
			states[state.name] = state

			# Connect the state machine to the `transitioned` signal of all stateren
			state.transitioned.connect(on_state_transitioned)

			state.parent = parent
			state.animations = animations
			state.moveComponent = moveComponent
			if parent is Player:
				state.camera = camera
		else:
			print("State machine contains a node which is not a 'State' node, removing node")
			state.queue_free()


	current_state.enter()

func on_state_transitioned(new_state_name: StringName) -> void:
	# Get the next state from the `Dictionary`
	var new_state = states.get(new_state_name.to_pascal_case())
	if new_state != null:
		if new_state != current_state:
			# Exit the current state
			current_state.exit()

			# Enter the new state
			new_state.enter()

			# Update the current state to the new one
			current_state = new_state
	else:
		print("Called transition on a state that does not exist")

func _process(delta):
	current_state.update(delta)

func _physics_process(delta):
	current_state.physics_update(delta)

func _unhandled_input(event):
	current_state.process_input(event)
