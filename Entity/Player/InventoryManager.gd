class_name  InventoryManager
extends Node

##WARNING InitSlot is just to ensure the inventory will return data, DO NOT REMOVE
@export var initSlot:SlotData

##Max Stack size
const MAXSTACKSIZE:int = 99

##To communicate to other objects that have the inventory system
signal OnInventoryChanged(inventory)

var inventory:Array[SlotData]  = [initSlot]

##Of course we need reference to the player's inventory
var player:Player

var overflow:int = 0

##To ensure everything is assigned
func init(player:Player):
	inventory = player.inventory
	self.player = player
	#print(inventory)

##Insert item have several logics that must take in for consideration
##1: We check for overflow of items because that we set max stacks to be 99, it's important to take account the chances that it will overflow (exp:99 + 5 then what?)
##2: Hence we check for overflow

func insert(droppedItem: GameMaterial, amount: int):
	var overflow = amount

	while overflow > 0:
		var inserted = false

	## Check existing inventory for the same item and add if there's available space
		for index in range(len(inventory)):
			if inventory[index] != null and inventory[index].item == droppedItem.itemData:
				if inventory[index].amount < MAXSTACKSIZE:
					var availableSpace = MAXSTACKSIZE - inventory[index].amount
					if overflow <= availableSpace:
						inventory[index].amount += overflow
						overflow = 0
						inserted = true
						break
					else:
						inventory[index].amount += availableSpace
						overflow -= availableSpace
						inserted = true

		## If overflow still exists and there are empty slots, create new SlotData
		if overflow > 0:
			for index in range(len(inventory)):
				if inventory[index] == null:
					var slotToBeAdded = SlotData.new()
					slotToBeAdded.item = droppedItem.itemData
					if overflow <= MAXSTACKSIZE:
						slotToBeAdded.amount = overflow
						overflow = 0
					else:
						slotToBeAdded.amount = MAXSTACKSIZE
						overflow -= MAXSTACKSIZE
					inventory[index] = slotToBeAdded
					inserted = true
					break

		## If there was no empty slot to insert the overflow, stop the loop to prevent infinite loop
		if not inserted:
			break

	## To communicate to other objects
	OnInventoryChanged.emit(inventory)

func remove(selectedItem:MaterialData,amount:int):
	var remainingToRemove:int = amount

	while remainingToRemove > 0:
		var removed:bool = false

		for index in range(len(inventory)):
			if inventory[index] != null && inventory[index].item == selectedItem:
				if inventory[index].amount >= remainingToRemove:
					inventory[index].amount -= remainingToRemove
					remainingToRemove = 0

					if inventory[index].amount == 0:
						inventory[index] = null

					removed = true
					break
				else:
					remainingToRemove -= inventory[index].amount
					inventory[index] = null
					removed = true
		if !removed:
			break
	OnInventoryChanged.emit(inventory)

func getSameItemCount(item:MaterialData)->int:
	var count:int = 0
	for slot in len(inventory):
		if inventory[slot].item == item:
			count +=1
	return count

##NOTE I forgot why I coded this so just keep it
func _getItemIndex(item:MaterialData) -> int:
	for slot in len(inventory):
		if inventory[slot].item == item:
			return slot

	return -1


