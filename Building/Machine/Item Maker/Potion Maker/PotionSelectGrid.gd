extends GridContainer

@export var material_container:Control

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in get_children():
		button.material_container = material_container


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
