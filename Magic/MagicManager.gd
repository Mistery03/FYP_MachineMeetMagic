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


func _process(delta):
	mousePos = player.mousePos
	self.localLevel = player.localLevel

	pass

func checkMagicUnlock() -> Array[MagicData]:
	var unlockedIndices: Array[MagicData] = []
	for i in range(magicDataList.size()):
		if magicDataList[i].isUnlocked:
			unlockedIndices.append(magicDataList[i])
	return unlockedIndices

func normalAttack():
	if magicData:
		currMagic = magicData
		if currMagic.scene:
			if currMagic.name == "Seeking Fireball":

				var magicScene = currMagic.scene.instantiate()

				magicScene.global_position = staff.magic_spawn_point.global_position
				magicScene.player = player
					#magicScene.mousePos = mousePos
				magicScene.magicData = currMagic
				magicScene.staff = staff

				player.currMana -= currMagic.manaRequirement
				localLevel.add_child(magicScene)

			elif currMagic.name == "Explosion":
				var magicScene = currMagic.scene.instantiate()
				magicScene.global_position = mousePos
				magicScene.magicData = currMagic
				player.currMana -= currMagic.manaRequirement
				localLevel.add_child(magicScene)






