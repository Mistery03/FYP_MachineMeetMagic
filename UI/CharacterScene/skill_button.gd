extends TextureButton
class_name skillButton

@export var magicSkillTree: Node2D
#take magic tree check if this magic unlock or not
var magicName: String
var isUnlock: bool 

#change magic skill tree class
@onready var panel = $Panel
@onready var line_2d = $Line2D

func _ready():
	if get_parent() is skillButton:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)

func _on_pressed():
	panel.show_behind_parent = true
	line_2d.default_color = Color(0.6460919380188, 0.2988940179348, 0.0000004813075)
	#skill learned need to safe data as learned skill
	print("pressed")
	var skills = get_children()
	for skill in skills:
		if skill is skillButton:
			skill.disabled = false
