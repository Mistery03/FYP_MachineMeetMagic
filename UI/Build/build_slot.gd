extends Panel

@export var buildingData:BuildingData

@onready var build_menu = $"../../.."
@onready var texture_rect = $TextureRect

var material_container

func _ready():
	if buildingData == null:
		queue_free()
	else:
		texture_rect.texture = buildingData.texture

	
func _on_button_pressed():
	if buildingData:
		build_menu.atlasCoord =  buildingData.atlasCoord
		build_menu.parentUI.visible = false

func _on_button_mouse_entered():
	if buildingData:
		build_menu.timer.paused = true
		build_menu.description_board.visible = true
		build_menu.buildingName = buildingData.name
		build_menu.texture = buildingData.texture
		build_menu.description = buildingData.description
		build_menu.instance = buildingData.instance
	
	if material_container:
		material_container.recipe = buildingData.craftingRecipe

func _on_button_mouse_exited():
	build_menu.timer.paused = false
	build_menu.timer.start()
	







