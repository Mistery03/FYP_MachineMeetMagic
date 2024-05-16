extends Label

@export var promptMessage = "DEFAULT"
@export var promptAction= "DEFAULT"

var key_name = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	updateKeyBindings()

func updateKeyBindings():
	var key_name = ""
	for action in InputMap.action_get_events(promptAction.to_upper()):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.physical_keycode)
			text = key_name.to_upper() + promptMessage.to_upper()
		elif action is InputEventMouse:
			key_name = action.button_index
			text = "MOUSE" +str(key_name) + promptMessage.to_upper()
