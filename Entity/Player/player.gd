class_name Player
extends Entity

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var playerData:EntityData
@export var potionObject:PotionData

@export var staff:Staff = null
@export var isStaffEquipped:bool

@export var playerInventoryController:Control
@export var itemHUDPlaceholder:Control
@export var maxInventorySize:int

##InitSlot is just to ensure the inventory will return data, do not remove
@export var initSlot:SlotData
##Takes in Slot Data so we have a "dictionary"
@export var inventory:Array[SlotData] = [initSlot]

@onready var inventory_manager = $InventoryManager
@onready var potion_manager = $PotionManager
@onready var state_manager = $StateManager
@onready var animation = $Animation
@onready var move_component = $MoveComponent
@onready var camera = $Camera
@onready var localLevel:Node2D


var potion:Potion
var isBuildEnabled:bool
var isBuildMode:bool
var homeTilemap:TileMap
var mousePos:Vector2

var isPressable:bool = false
var isMachineUI:bool = false


func _ready() -> void:
	currHealth = playerData.MaxHealth
	currMana = playerData.MaxMana
	currStamina = playerData.MaxStamina
	inventory_manager.init(self)
	state_manager.init(self,animation,move_component,camera)

	

func _unhandled_input(event: InputEvent) -> void:
	state_manager.process_input(event)
	

func _physics_process(delta) -> void:
	state_manager.process_physics(delta)
	
func _process(delta) -> void:
	mousePos = get_global_mouse_position()
	state_manager.process_frame(delta)
	print(inventory)
