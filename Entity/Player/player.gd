class_name Player
extends Entity

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var playerData:EntityData
@export var potionObject:PotionData

@onready var potion_manager = $PotionManager
@onready var state_manager = $StateManager
@onready var animation = $Animation
@onready var move_component = $MoveComponent
@onready var camera = $Camera

var potion:Potion
var isBuildEnabled:bool
var homeTilemap:TileMap
var mousePos:Vector2
var localLevel:Node2D

func _ready() -> void:
	currHealth = playerData.MaxHealth
	currMana = playerData.MaxMana
	currStamina = playerData.MaxStamina
	potion_manager.init(self)
	state_manager.init(self,animation,move_component,camera)

func _unhandled_input(event: InputEvent) -> void:
	state_manager.process_input(event)

func _physics_process(delta) -> void:
	state_manager.process_physics(delta)
	
func _process(delta) -> void:
	mousePos = get_global_mouse_position()
	state_manager.process_frame(delta)
	
func on_item_picked_up(material:Materials):
	print("I got a ", material.name)			

