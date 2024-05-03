extends Panel

@export var buildingName:String = "Generic"
@export var texture:Texture2D
@export var atlasCoord:Vector2i

signal OnBuildingSelect(atlasCoord)






func _on_button_pressed():
	OnBuildingSelect.emit(atlasCoord)
