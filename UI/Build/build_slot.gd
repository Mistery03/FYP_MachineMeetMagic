extends Panel

@export var buildingData:BuildingData

@onready var build_menu = $"../../.."
@onready var texture_rect = $TextureRect



func _ready():
	texture_rect.texture = buildingData.texture

	
func _on_button_pressed():
	build_menu.atlasCoord =  buildingData.atlasCoord
	build_menu.parentUI.visible = false


func _on_button_mouse_entered():
	build_menu.timer.paused = true
	build_menu.description_board.visible = true
	build_menu.buildingName = buildingData.name
	build_menu.texture = buildingData.texture
	build_menu.description = buildingData.description
	build_menu.instance = buildingData.instance

func _on_button_mouse_exited():
	build_menu.timer.paused = false
	build_menu.timer.start()
	







