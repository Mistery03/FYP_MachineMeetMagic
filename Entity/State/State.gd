class_name State
extends Node

@export
var animation_name: String = "IDLE"
@export
var move_speed: float = 100
@export
var accel:float = 10
@export
var animationList: Dictionary={
	"WalkFront":"",
	"WalkBackward":""
}

# Hold a reference to the parent so that it can be controlled by the state
var parent: Player
var animations: AnimatedSprite2D
var move_component: IMoveComponent

func enter() -> void:
	animations.play(animation_name.to_upper())

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
