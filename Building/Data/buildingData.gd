class_name BuildingData
extends Resource

@export var name:String
@export_enum("Electricity","Item Maker","Logistic","Material Exchange","Material Processor","Upgrader") var category:String
@export var texture:Texture2D
@export var atlasCoord:Vector2i = Vector2i(-1,-1)
@export var description:String = ""
@export var instance:PackedScene 
@export var isUnlocked:bool
@export var unlockAmount:int
@export var craftingRecipe:CraftingRecipe
