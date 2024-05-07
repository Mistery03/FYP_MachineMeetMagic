extends Panel

@export var buildingName:String = "Generic"
@export var texture:Texture2D
@export var atlasCoord:Vector2i = Vector2i(-1,-1)
@export var description:String = ""

@onready var build_menu = $"../../.."
@onready var texture_rect = $TextureRect



func _ready():
	texture_rect.texture = texture

	
func _on_button_pressed():
	build_menu.atlasCoord = atlasCoord
	build_menu.parentUI.visible = false


func _on_button_mouse_entered():
	build_menu.timer.paused = true
	build_menu.description_board.visible = true
	build_menu.buildingName = buildingName
	build_menu.texture = texture
	build_menu.description = description
	print(build_menu.timer.time_left)

func _on_button_mouse_exited():
	build_menu.timer.paused = false
	build_menu.timer.start()
	







