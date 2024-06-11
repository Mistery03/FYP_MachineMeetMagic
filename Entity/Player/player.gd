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
@onready var animation = $Animation
@onready var move_component = $MoveComponent
@onready var camera = $Camera
@onready var localLevel:Node2D
@onready var magic_manager = $MagicManager


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
	
	for i in range(maxInventorySize):
		inventory.append(null)
	#print(inventory.size())
	inventory_manager.init(self)
	magic_manager.init(self, mousePos)
	

	
func _process(delta) -> void:
	mousePos = get_global_mouse_position()
	#print(inventory)
