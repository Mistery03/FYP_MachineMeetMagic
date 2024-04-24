class_name Player
extends Entity

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var playerData:EntityData
@export var potionObject:PotionData

@onready var potion_manager = $PotionManager
@onready var state_manager = $StateManager
@onready var animation = $Animation
@onready var player_sprite = $PlayerSprite

var potion:Potion

func _ready() -> void:
	currHealth = playerData.MaxHealth
	currMana = playerData.MaxMana
	currStamina = playerData.MaxStamina
	potion_manager.init(self)
	
	

func _physics_process(delta) -> void:
	

	


	move_and_slide()

func _process(delta) -> void:
	pass
		

