class_name PotionData
extends ObjectData


@export_enum("Buff","Consumable","Heal","Throwable","Utility") var category:String
@export var isThrowable:bool
@export var scene:PackedScene
@export var craftingRecipe:CraftingRecipe

