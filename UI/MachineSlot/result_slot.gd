class_name ResultSlot
extends Panel

@export var parentControl:Control

@export var item:ObjectData = null
@export var amount:int = 1

@onready var border = $Border
@onready var item_texture = $Border/ItemTexture
@onready var label = $Label
@onready var pickup_sfx = $pickupSFX

var isMousePressed:bool = false

var scaledSlotSize

# Called when the node enters the scene tree for the first time.
func _ready():
	scaledSlotSize = custom_minimum_size * scale
	item = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if item:
		item_texture.texture = item.texture
		item_texture.visible = true
		label.visible = true
		label.text = str(amount)
		print(item.type)

	else:
		item_texture.visible = false
		label.visible = false

func _on_item_texture_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if item:
					if parentControl.player:
						match item.type:
							"Currency":
								if item.name == "Magic Essence" :
									parentControl.player.MagicEssenceCurrency += amount
								elif item.name == "Research Point":
									parentControl.player.ResearchPointCurrency += amount
							"Potion":
								item.amount += amount
								if parentControl.parentMachine.potion_sprite:
									parentControl.parentMachine.potion_sprite.texture = parentControl.parentMachine.originalTexture

					pickup_sfx.play()
					item = null
					amount = 0


