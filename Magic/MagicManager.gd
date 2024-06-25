class_name MagicManager
extends Node

@export var magicInventory:Control
@export var magicGridInventory:Control #OPTIONAL
@export var magicHUD:Control
@export var magic_tree_ui:Control
@export var staff:Node #need to change later

var mousePos:Vector2
var player:Player
var magicData:MagicData
var currMagic = null
var localLevel:Node2D
var attackTimer:Timer
@export var magicDataList:Array[MagicData] = []

func init(player:Player):
	self.player = player
	await get_tree().create_timer(2.5).timeout
	self.localLevel = player.localLevel
	
	
func _process(delta):
	mousePos = player.mousePos
	pass

func checkMagicUnlock() -> Array[MagicData]:
	var unlockedIndices: Array[MagicData] = []
	for i in range(magicDataList.size()):
		if magicDataList[i].isUnlocked:
			unlockedIndices.append(magicDataList[i])
			print("unlocked : ", unlockedIndices[i])
	return unlockedIndices

func checkMagicEquip():
	
	pass
	
func normalAttack():
	if magicData:
		currMagic = magicData
		var magicScene = currMagic.scene.instantiate()
		magicScene.global_position = mousePos
		localLevel.add_child(magicScene)
		
	
	
	#var unlocked_magic = checkMagicUnlock()
	#if 0 in unlocked_magic:
		#var magicScene = magicDataList[0].scene.instantiate()
		#magicScene.position = mousePos
		#get_parent().add_child(magicScene)
		#print(magicDataList)
	
	#call trackposition
	#play animation, call ignisNormalAttack?
	#staff call this
	
	
