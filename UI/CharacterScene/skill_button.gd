extends TextureButton
class_name skillButton

@export var MagicData:Resource
@export var magicSkillTree: Node2D
@onready var descriptionbox = $Descriptionbox
@onready var magicname = $"Descriptionbox/Name"
@onready var description = $"Descriptionbox/Description"

#take magic tree check if this magic unlock or not
var magicName: String
var isUnlock: bool 

#change magic skill tree class
@onready var panel = $Panel
@onready var line_2d = $Line2D

func _ready():
	set_texture_normal(MagicData.skillButton) #image follow MagicData
	
	#Link between 2 button
	if get_parent() is skillButton:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)
	
	
		
func _process(delta):
	if MagicData.isUnlocked:
		panel.show_behind_parent = true
#When button pressed
func _on_pressed():
	panel.show_behind_parent = true
	line_2d.default_color = Color(0.6460919380188, 0.2988940179348, 0.0000004813075)
	#skill learned need to safe data as learned skill
	MagicData.isUnlocked = true
	print(MagicData.isUnlocked)
	var skills = get_children()
	for skill in skills:
		if skill is skillButton:
			skill.disabled = false

func _on_timer_timeout():
	descriptionbox.visible = false

func _on_mouse_entered():
	descriptionbox.visible = true
	magicname.visible = true
	description.visible = true
	magicname.text = MagicData.name
	description.text = MagicData.description


func _on_mouse_exited():
	descriptionbox.visible = false
	magicname.visible = false
	description.visible = false
