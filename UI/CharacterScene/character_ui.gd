class_name researchTree extends Control

@onready var machine_tree = $machineTree
@onready var skill_tree = $skillTree
@onready var description_box = $"Description box"

var skill_name:String
var skill_description:String
var magicData: MagicData

var machine_name:String
var machine_description:String
var buildingData:BuildingData
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		pass
