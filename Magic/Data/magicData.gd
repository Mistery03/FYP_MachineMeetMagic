class_name  MagicData
extends Resource

@export var name:String
@export var skillButton:Texture2D
@export var scene:PackedScene
@export var manaRequirement: float
@export var isUnlocked:bool
@export var burningTime:float
@export var efficientTime:float 
@export var damangeAmount:float

func getmagicData() -> Dictionary:
	return{
		"name": name,
		"skillButton": skillButton,
		"scene": scene,
		"manaRequirement": manaRequirement,
		"isUnlocked": isUnlocked,
		"burningTime": burningTime,
		"efficientTime": efficientTime,
		"damangeAmount": damangeAmount
	}
