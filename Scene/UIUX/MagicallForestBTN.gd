extends Button

@export var levelName:String = "Magical Forest"
@export var levelDesc:String = ""
@onready var level_selection = $".."





func _on_mouse_entered():
	level_selection.level_description.text = levelDesc
	level_selection.level_description.visible = true
	level_selection.select_level_text.visible = false


func _on_mouse_exited():
	level_selection.level_description.text = level_selection.defaultDescription
	level_selection.level_description.visible = false
	level_selection.select_level_text.visible = true


func _on_pressed():
	get_tree().change_scene_to_file("res://Scene/Forest/Forest.tscn")
