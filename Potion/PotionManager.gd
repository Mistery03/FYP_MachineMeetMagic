class_name PotionManager
extends Node

 
@export var PotionHUD:Control
@export var potionDataList:Array[PotionData]


var player:Player
var _index:int = 0
var potionList:Array[Potion]
var utiliyPotion:Potion = null

func init(player:Player) -> void:
	if potionDataList.size() <= 0:
		return
	potionList.clear()
	for potionData in potionDataList:
		var potion = potionData.scene.instantiate()
		potion.master = player
		if potionData.category != "Utility":
			potionList.append(potion)
		else:
			utiliyPotion = potion

func _process(delta) -> void:
	if potionDataList.size() <= 0:
		return	
	if Input.is_action_just_pressed("ChangePotion") and potionList.size() > 1:
		if _index == 0:
			_index = 1
		elif _index == 1:
			_index = 0
			
	if Input.is_action_just_pressed("DrinkPotion") and potionDataList[_index].amount > 0:
		potionList[_index].execute()
		potionDataList[_index].amount -= 1
		print(potionDataList[_index].amount)
	
	if Input.is_action_just_pressed("UseUtility") and utiliyPotion != null:
		utiliyPotion.execute()
	
	
		
	
	
		
	
