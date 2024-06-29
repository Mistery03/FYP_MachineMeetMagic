extends Control

@onready var machine_mana_bar = $MachineManaBar
@onready var sprite = $Sprite

var currValue

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	machine_mana_bar.currValue = currValue

func changeSpriteFrame(frame:int):
	sprite.frame = frame
	
