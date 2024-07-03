class_name researchTree extends Control

@onready var machine_tree = $machineTree
@onready var skill_tree = $skillTree
@onready var currency = $CurrencyHolder/Currency
@export var player:Player

var skill_name:String
var skill_description:String
var magicData: MagicData
var researchCurrency:int

var machine_name:String
var machine_description:String
var buildingData:BuildingData
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if PlayerGlobal.playerResearchPoint >0:
		researchCurrency = PlayerGlobal.playerResearchPoint
		
	else:
		researchCurrency = player.ResearchPointCurrency
	currency.text = str(researchCurrency)
	print("currency:", researchCurrency)
	#researchCurrency = skill_tree.skillButton.researchCurrency
	
	 # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	skill_tree.player = player
	machine_tree.player = player
	researchCurrency = player.ResearchPointCurrency
	currency.text = str(researchCurrency)
	print("currency:", researchCurrency)
	
