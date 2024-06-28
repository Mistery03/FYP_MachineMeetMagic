class_name Entity
extends CharacterBody2D
@export_category("Entity Settings")
@export var maxHP:float = 100
@export var maxStamina:float = 100
@export var maxMana:float = 100
@export var moveSpeed:float = 2000
@export var animation:AnimatedSprite2D
@export var moveComponent:Node

@export_category("State Machine")
@export var stateController:StateMachine

@export var entityNeighbour:Array
#Event
signal OnHealthIncrease
signal OnDamageTaken(damageAmount:float)

var currHealth:float = 0
var currStamina:float = 0
var currMana:float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



