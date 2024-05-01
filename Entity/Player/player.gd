class_name Player
extends Entity

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var playerData:EntityData
@export var potionObject:PotionData

@onready var potion_manager = $PotionManager
@onready var state_manager = $StateManager
@onready var player_sprite = $PlayerSprite
@onready var animation = $Animation


var potion:Potion

func _ready() -> void:
	currHealth = playerData.MaxHealth
	currMana = playerData.MaxMana
	currStamina = playerData.MaxStamina
	potion_manager.init(self)
	state_manager.init(self,animation)

func _unhandled_input(event: InputEvent) -> void:
	state_manager.process_input(event)

func _physics_process(delta) -> void:
	state_manager.process_physics(delta)

	

func _process(delta) -> void:
	state_manager.process_frame(delta)
		

