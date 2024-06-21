extends Control

@onready var option_button = $OptionButton
@onready var machine_animation = $MachineAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	option_button.add_item("Convert 9 magic essences to 6 research points")
	option_button.add_item("Convert 30 magic essences to 20 research points")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
