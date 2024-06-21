class_name ScrollScriberUI
extends MachineControlUI

##NOTE because the documentation didnt mention any way to get the children, we manually set the size (this is for auto put metadata)
@export var optionSize:int = 0
@export var isPressed:bool = false
##NOTE Assume 0.2 is slowing down the loading bar by 20%
@export var slowMultiplier:float = 0.2

@export var resultedItem:MaterialData

@onready var progress_bar = $ProgressBar
@onready var converter_choice = $ConverterChoice
@onready var convert_btn = $convertBTN

var magicEssenceInputValue:int = -1
var researchPointOutValue:int
var valueInPercentage:float = 0
var timeToProgress:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	progress_bar.value = valueInPercentage
	##NOTE Even though the first index is the select thingy, you wont see 57 as an asnwer when i = 0 because it disabled
	for i in range(optionSize):
		converter_choice.set_item_metadata(i,autoInputSetter(i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isPressed:
		valueInPercentage += timeToProgress * delta
		valueInPercentage = clamp(valueInPercentage,0,1)
		parentMachine.changeAnimation("Processing")

		if valueInPercentage >= 1:
			produceResult()
			parentMachine.changeAnimation("End")
			isPressed = false
			convert_btn.disabled = false
			valueInPercentage = 0
		
	progress_bar.value = valueInPercentage


func autoInputSetter(n:int)->int:
	var output = 34.5 * (n*n) - 82.5 * n + 57
	return output

func _on_converter_choice_item_selected(index):
	magicEssenceInputValue = converter_choice.get_item_metadata(index)


func _on_convert_btn_pressed():
	if player.MagicEssenceCurrency >= magicEssenceInputValue and !magicEssenceInputValue < 0:
		player.MagicEssenceCurrency -= magicEssenceInputValue
		researchPointOutValue = ceil(0.66 * magicEssenceInputValue)
		timeToProgress = slowMultiplier *  abs(1.0 -  (float(magicEssenceInputValue)/100.00))
		isPressed = true
		convert_btn.disabled = true

func produceResult():
	if result_slot.item == null:
		result_slot.item = resultedItem
		result_slot.amount = researchPointOutValue
	else:
		result_slot.amount += researchPointOutValue
