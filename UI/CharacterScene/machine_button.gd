extends TextureButton
class_name machineButton

@export var machineData:Resource
@export var machineTree: Node2D
@onready var descriptionbox = $Descriptionbox
@onready var machinename = $Descriptionbox/Name
@onready var description = $Descriptionbox/Description
@onready var img = $Descriptionbox/Sprite2D2
@onready var research_point_ui = $Descriptionbox/researchPoint



#take magic tree check if this magic unlock or not
var machineName: String
var isUnlock: bool 
var researchCurrency:int
var player:Player
#change magic skill tree class
@onready var panel = $Panel
@onready var line_2d = $Line2D


func _ready():
	await get_tree().create_timer(1).timeout
	
	set_texture_normal(machineData.texture) #image follow MagicData
	#Link between 2 button
	if get_parent() is machineButton:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)
		
	if PlayerGlobal.playerResearchPoint >0:
		researchCurrency = PlayerGlobal.playerResearchPoint
		
	else:
		researchCurrency = player.ResearchPointCurrency
		
func _process(delta):
	researchCurrency = player.ResearchPointCurrency
	if machineData.isUnlocked:
		panel.show_behind_parent = true

#When button pressed
func _on_pressed():
	if researchCurrency >= machineData.unlockAmount:
		panel.show_behind_parent = true
		line_2d.default_color = Color(0.6460919380188, 0.2988940179348, 0.0000004813075)
		#skill learned need to safe data as learned skill
		machineData.isUnlocked = true
		player.ResearchPointCurrency -= machineData.unlockAmount
		print(machineData.isUnlocked)
		var machines = get_children()
		for machine in machines:
			if machine is machineButton:
				machine.disabled = false # Replace with function body.


func _on_mouse_entered():
	descriptionbox.visible = true
	machinename.visible = true
	description.visible = true
	img.visible = true
	research_point_ui.visible = true
	machinename.text = machineData.name
	description.text = machineData.description
	research_point_ui.text = str(machineData.unlockAmount)
	machinename.add_theme_color_override("font_color", Color(0, 0, 0))
	description.add_theme_color_override("font_color", Color(0, 0, 0))
	research_point_ui.add_theme_color_override("font_color", Color(0, 0, 0))
	if researchCurrency < machineData.unlockAmount:
		machinename.add_theme_color_override("font_color", Color(1, 0, 0))
		description.add_theme_color_override("font_color", Color(1, 0, 0))
		research_point_ui.add_theme_color_override("font_color", Color(1, 0, 0))

func _on_mouse_exited():
	descriptionbox.visible = false
	machinename.visible = false
	description.visible = false
	img.visible = false
	research_point_ui.visible = false

