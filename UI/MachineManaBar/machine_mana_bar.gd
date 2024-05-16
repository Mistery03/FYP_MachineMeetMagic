class_name MachineManaBarUI
extends TextureProgressBar

@onready var mana_amount_display = $ManaAmountDisplay
@export var maxValue:float = 100
var currValue:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	value = currValue
	max_value = maxValue
	mana_amount_display.text = str(value) + "/" + str(max_value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = currValue
	mana_amount_display.text = str(value) + "/" + str(max_value)
