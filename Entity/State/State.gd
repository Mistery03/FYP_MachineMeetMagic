##@NOTE State interface
class_name State
extends Node

@export_category("Parent Animation")
@export
var animation_name: String = "IDLE"

signal transitioned(new_state_name: StringName)
# Hold a reference to the parent so that it can be controlled by the state
var parent: Entity
var animations: AnimatedSprite2D
var moveComponent: Node
var camera:Camera2D

func enter() -> void:
	animations.play(animation_name.to_upper())

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func process_input(event)->void:
	pass


