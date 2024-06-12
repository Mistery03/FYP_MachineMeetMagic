class_name PotionSlotPlayer
extends Panel

@export var potionData:PotionData
@export var potionAmount:int

@export var defaultTexture:Texture2D

@onready var potion_texture = $Container/PotionTexture 
@onready var potion_amount = $PotionAmount
@onready var darkened = $Darkened
@onready var select = $Select

var potionInventory:Control

# Called when the nod ve enters the scene tree for the first time.
func _ready():
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if potionInventory.potionData:
		#potionData = potionInventory.potionData
	if potionData:
		potion_texture.texture = potionData.texture
		
		if potionInventory.isPotionAmountShown:
			if potionAmount > 0:
				darkened.visible = false
			else:
				darkened.visible = true
				potionAmount = clamp(potionAmount,0,99)
			potion_amount.visible = potionInventory.isPotionAmountShown
			potion_amount.text = str(potionAmount)
	

	


func _on_button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
				
			MOUSE_BUTTON_RIGHT:
				if potionData:
					potionData = null
					potion_texture.texture = defaultTexture
					potion_amount.visible = false

func _on_darkened_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if potionData:
					if potionAmount > 0:
						print(potionData.name)
				
			MOUSE_BUTTON_RIGHT:
				if potionData:
					potionData = null
					potion_texture.texture = defaultTexture
					darkened.visible = false
					potion_amount.visible = false



func _on_button_focus_entered():
	select.visible = true
	if potionData:
		if potionAmount > 0:
			print(potionData.name)
	else:
		
		potionInventory.visible = true
		potionInventory.currSlot = self
		


func _on_button_focus_exited():
	select.visible = false
	



