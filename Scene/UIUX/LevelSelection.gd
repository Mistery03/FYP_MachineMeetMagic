extends Control

@export var defaultDescription:String = "Select destination"

@onready var level_description = $LevelDescription
@onready var select_level_text = $SelectLevelText

# Called when the node enters the scene tree for the first time.
func _ready():
	level_description.text = defaultDescription


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if visible:
		if event is InputEventKey:
			if event.is_action_pressed("EXIT"):
				visible = false
				



