class_name  InventoryManager
extends Node

##InitSlot is just to ensure the inventory will return data, do not remove
@export var initSlot:SlotData

signal OnInventoryChanged(Inventory)
signal OnInventoryAdded(Inventory)

var inventory:Array[SlotData]  = [initSlot]

func init(player:Player):
	inventory = player.inventory


func insert(item:GameMaterial,amount:int):
	for slot in inventory:
		if slot.item == item.materialData:
			slot.amount += 1
		else:
			var slotToBeAdded = SlotData.new()
			slotToBeAdded.item = item.materialData
			slotToBeAdded.amount = amount
			
			inventory.append(slotToBeAdded)
			
			OnInventoryChanged.emit(inventory)
	print(inventory)
