extends Panel

@export var potionData:PotionData
@export var potionAmount:int

@onready var potion_texture = $Container/PotionTexture
@onready var potion_amount = $PotionAmount
@onready var darkened = $Darkened

var potionInventory:Control
# Called when the nod ve enters the scene tree for the first time.
func _ready():
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if potionData:
		potionAmount = potionData.amount
		potion_texture.texture = potionData.texture
		
		if potionInventory.isPotionAmountShown:
			if potionAmount > 0:
				darkened.visible = false
			else:
				darkened.visible = true
				potionAmount = clamp(potionAmount,0,99)
			potion_amount.visible = potionInventory.isPotionAmountShown
			potion_amount.text = str(potionAmount)

				


func _on_button_pressed():
	potionInventory.visible = false
	if potionData:
		if potionAmount > 0:	
			potionInventory.currSlot.potionData = potionData
			potionInventory.currSlot.potionAmount = potionAmount
	


func _on_button_mouse_entered():
	if potionData:
		potionInventory.timer.paused = true
		potionInventory.description_board.visible = true
		potionInventory.potionName = potionData.name
		potionInventory.texture = potionData.texture
		potionInventory.description = potionData.description


func _on_button_mouse_exited():
	if potionData:
		potionInventory.timer.paused = false
		potionInventory.timer.start()


func _on_darkened_mouse_entered():
	if potionData:
		potionInventory.timer.paused = true
		potionInventory.description_board.visible = true
		potionInventory.potionName = potionData.name
		potionInventory.texture = potionData.texture
		potionInventory.description = potionData.description


func _on_darkened_mouse_exited():
	if potionData:
		potionInventory.timer.paused = false
		potionInventory.timer.start()
