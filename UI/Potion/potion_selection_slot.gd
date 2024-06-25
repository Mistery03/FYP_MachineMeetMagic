extends Button

@export var potionData:PotionData
@export var maxChoice:int = 4


@onready var potionName = $Label
@onready var option_button = $Border2/OptionButton
@onready var potionTexture = $ItemTexture

var material_container
var multiplier:int = 1

func _ready():
	if potionData == null:
		print("WARNING: Missing Potion Data")
		queue_free()
	else:
		potionName.text = potionData.name
		potionTexture.texture = potionData.texture
		for i in maxChoice:
			option_button.set_item_metadata(i,autoOutput(i+1))
			
		


func _on_pressed():
	if material_container:
		material_container.recipe = potionData.craftingRecipe
		material_container.multiplier= multiplier

func autoOutput(n):
	var a = n*n - 2*n +2
	return a


func _on_option_button_item_selected(index):
	multiplier = option_button.get_item_metadata(index)
	
