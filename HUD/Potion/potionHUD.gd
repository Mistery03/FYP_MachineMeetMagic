extends Control

@export var actionInput:String
@export var texture:Texture2D
@export var inventoryUI:Control
@export var player:Player


@onready var texture_rect = $border/TextureRect

@onready var darkened = $Darkened
@onready var potion_amount = $PotionAmount

var poppedValue
var currTexture
var currPotionData = null
var prevPotionData = null

var potionList:Array = []

var currIndex:int = 0
var prevIndex:int = 0

##Is the head of circular linked list
var currIncreament:int = 0

var isPotionNull:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.texture = texture

func _process(delta):

	if Input.is_action_just_pressed("EQUIPPOTION"):

		player.playerData.potionList = inventoryUI.potion_grid_container_player.potionList
	
		if player.playerData.potionList.size() > 0:
			prevIndex = currIndex

			print("Incre ",currIncreament)
			currIndex = currIncreament % player.playerData.potionList.size()
			print("Index ",currIndex)
			currIncreament += 1

			if currIncreament >= player.playerData.potionList.size() and currIndex != prevIndex:
				currIncreament = 0

			if player.playerData.potionList[currIndex]:
				var amount = inventoryUI.potion_grid_container_player.getPotionAmount(player.playerData.potionList[currIndex])
				texture_rect.visible = true
				potion_amount.visible = true
				texture_rect.texture = player.playerData.potionList[currIndex].texture
				potion_amount.text = str(amount)
				player.potion_manager.potionData = player.playerData.potionList[currIndex]
			else:	
				texture_rect.visible = false
				potion_amount.visible = false
				player.potion_manager.potionData = null
				isPotionNull = true
			print(player.playerData.potionList)

	if isPotionNull:
		currIncreament += 1
		prevIndex = currIndex
		currIndex = currIncreament % player.playerData.potionList.size()

		currIncreament = clamp(currIncreament,0,player.playerData.potionList.size())
		if currIncreament >= player.playerData.potionList.size() and currIndex != prevIndex:
			currIncreament = 0
		if player.playerData.potionList[currIndex]:
			isPotionNull = false




	"""if potionGridHolderData:
		for potion in potionGridHolderData.potionList:
			if potion.potionData:
				texture_rect.texture = potion.potionData.texture"""


"""func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.is_action_pressed(actionInput.to_upper()) and !texture_rect.visible:
			texture_rect.visible = true
		elif event.is_action_pressed(actionInput.to_upper()) and texture_rect.visible:
			texture_rect.visible = false"""
