class_name Player
extends Entity

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var playerData:EntityData
@export var localLevel:Node2D

@export_category("Potion")
@export var potionObject:PotionData

@export_category("Staff")
@export var staff:Staff = null
@export var isStaffEquipped:bool

@export_category("Player currency")
@export var MagicEssenceCurrency:int
@export var ResearchPointCurrency:int

@export_category("HUD")
@export var itemHUDPlaceholder:Control
@export var playerHUD:Control
@export var playerCurrencyHUD:Label

@export_category("Player Inventory")
@export var playerInventoryController:Control
@export var maxInventorySize:int
##InitSlot is just to ensure the inventory will return data, do not remove
@export var initSlot:SlotData
##Takes in Slot Data so we have a "dictionary"
@export var inventory:Array[SlotData] = [initSlot]

@export_category("Player Magic")
@export var magicUI:Control

@export_category("Camera Settings")
@export var min_zoom = 6
@export var max_zoom = 12
@export var zoom_step = 0.1
@export var zoom_duration = 0.3 # Duration for the zoom transition
@export var cameraZoom:float = 6

@onready var inventory_manager = $InventoryManager
@onready var potion_manager = $PotionManager
@onready var camera = $Camera

@onready var magic_manager = $MagicManager

@onready var place_sfx = $Audio/PlaceSFX
@onready var walking_on_wood_sfx = $Audio/walkingOnWoodSFX
@onready var walking_on_grass_sfx = $Audio/walkingOnGrassSFX
@onready var breaking_sfx = $Audio/breakingSFX

@onready var player_hitbox = $PlayerHitbox

@onready var text_on_mouse = $TextOnMouse



var potion:Potion
var isBuildEnabled:bool
var isBuildMode:bool
var homeTilemap:TileMap
var levelTilemap:TileMap
var mousePos:Vector2

var isAttackable:bool = true
var isPressable:bool = false
var isMachineUI:bool = false
var isLevelTransitioning:bool = false
var isInDestroyArea:bool = false
var wasAttacking:bool = false
var isInInventory:bool = false
var isMagicAvailable:bool = false

var canInput:bool = true
var canDash:bool = true

var objectsPosInLevelList:Array[Vector2i]

var zoomValue:float = 6

func _ready() -> void:
	playerCurrencyHUD.text = str(MagicEssenceCurrency)
	if PlayerGlobal.playerInventory:
		inventory = PlayerGlobal.playerInventory
	camera.zoom = Vector2(cameraZoom,cameraZoom)

	currHealth = playerData.MaxHealth
	currMana = playerData.MaxMana
	currStamina = playerData.MaxStamina

	inventory_manager.init(self)
	stateController.init(self,animation,moveComponent,camera)
	magic_manager.init(self)

	##NOTE we must declare an inventory of null items size of N max inventory or else there will be a bug
	#for i in range(maxInventorySize):
		#inventory.append(null)

func _process(delta) -> void:
	playerCurrencyHUD.text = str(MagicEssenceCurrency)
	mousePos = get_global_mouse_position()
	##NOTE Wai this is for you
	print("Player's researchpoint: ",ResearchPointCurrency)
	print("Player hitbox ",get_collision_layer_value(1))

func _input(event):
	if event is InputEventMouse:
		if event.is_action_released("ZOOMIN"):
			zoomValue+=zoom_step
			zoomValue = clamp(zoomValue,min_zoom,max_zoom)
			smooth_zoom(zoomValue)
		elif event.is_action_released("ZOOMOUT"):
			zoomValue-=zoom_step
			zoomValue = clamp(zoomValue,min_zoom,max_zoom)
			smooth_zoom(zoomValue)

func smooth_zoom(new_zoom):
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "zoom", Vector2(new_zoom, new_zoom), zoom_duration)






