extends Panel

@export var buildingName:String = "Generic"
@export var texture:Texture2D
@export var atlasCoord:Vector2i = Vector2i(5,5)
@onready var build_menu = $"../../.."
@onready var texture_rect = $TextureRect

func _ready():
	texture_rect.texture = texture

func _on_button_pressed():
	build_menu.atlasCoord = atlasCoord
	build_menu.visible = false
	





func _on_mouse_entered():
	build_menu.isInMenu = true
	print(build_menu.isInMenu )


func _on_mouse_exited():
	build_menu.isInMenu = false
