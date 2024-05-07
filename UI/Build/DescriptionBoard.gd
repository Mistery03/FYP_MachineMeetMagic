extends NinePatchRect

@onready var building_icon = $BuildingIcon
@onready var buidling_name = $BuidlingName
@onready var building_description = $BuildingDescription
@onready var build_menu = $".."


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	building_icon.texture = build_menu.texture
	buidling_name.text = build_menu.buildingName
	building_description.text = build_menu.description
