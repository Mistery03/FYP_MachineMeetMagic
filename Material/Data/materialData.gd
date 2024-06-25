class_name MaterialData
extends ObjectData

@export var name:String
@export_enum("Construction","Currency","Fuel","Infusion","Ingredient") var type:String
@export var texture:Texture2D
@export var amount:int
@export var magicEssenceAmountResult:int
@export var burnPerSecond:int 
@export var manaProducedPerSecond:int 
@export var durability:int

