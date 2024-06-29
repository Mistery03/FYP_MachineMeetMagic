extends TextureButton
class_name skillButton

@export var magicData:MagicData
@export var magicSkillTree: Node2D
@onready var descriptionbox = $Descriptionbox
@onready var magicname = $"Descriptionbox/Name"
@onready var description = $"Descriptionbox/Description"
@onready var img = $Descriptionbox/Sprite2D2
@onready var research_point_ui = $Descriptionbox/researchPoint

#take magic tree check if this magic unlock or not
var magicName: String
var isUnlock: bool 
var researchCurrency:int
var player: Player
#change magic skill tree class
@onready var panel = $Panel
@onready var line_2d = $Line2D

func _ready():
	#get_child(4).player = player
	await get_tree().create_timer(1).timeout
	print("child",get_children())
	set_texture_normal(magicData.skillButton) #image follow MagicData
	if PlayerGlobal.playerResearchPoint >0:
		researchCurrency = PlayerGlobal.playerResearchPoint
		
	else:
		researchCurrency = player.ResearchPointCurrency
	#Link between 2 button
	if get_parent() is skillButton:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)
	
	
		
func _process(delta):
	researchCurrency = player.ResearchPointCurrency
	if magicData.isUnlocked:
		panel.show_behind_parent = true
#When button pressed
func _on_pressed():
	#if player research >= to requirement then unlock if not  description box
	if researchCurrency >= magicData.unlockAmount:
		panel.show_behind_parent = true
		line_2d.default_color = Color(0.6460919380188, 0.2988940179348, 0.0000004813075)
		#skill learned need to safe data as learned skill
		magicData.isUnlocked = true
		player.ResearchPointCurrency -= magicData.unlockAmount
		print(magicData.isUnlocked)
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
	img.visible = true
	research_point_ui.visible = true
	magicname.text = magicData.name
	description.text = magicData.description
	research_point_ui.text = str(magicData.unlockAmount)
	magicname.add_theme_color_override("font_color", Color(0, 0, 0))
	description.add_theme_color_override("font_color", Color(0, 0, 0))
	research_point_ui.add_theme_color_override("font_color", Color(0, 0, 0))
	if researchCurrency < magicData.unlockAmount:
		magicname.add_theme_color_override("font_color", Color(1, 0, 0))
		description.add_theme_color_override("font_color", Color(1, 0, 0))
		research_point_ui.add_theme_color_override("font_color", Color(1, 0, 0))

func _on_mouse_exited():
	descriptionbox.visible = false
	magicname.visible = false
	description.visible = false
	img.visible = false
	research_point_ui.visible = false
