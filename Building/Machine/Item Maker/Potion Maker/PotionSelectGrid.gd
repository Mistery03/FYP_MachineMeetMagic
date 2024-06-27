extends GridContainer

@export var material_container:Control
@export var parentControl:Control

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in get_children():
		button.material_container = material_container
		button.parentControl = parentControl


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for button in get_children():
		button.disabled = parentControl.isBrewPressed
		button.option_button.disabled = parentControl.isBrewPressed
