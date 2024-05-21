class_name InventoryHanlder
extends Control

@export var parentControl:Control
@export var playerInventory:Array[SlotData]
@export var inventorySlot:PackedScene
@export var maxInventorySlot:int
@export var materialInstance:PackedScene

@onready var player_grid_inventory = $PlayerGridInventory

const MAXSTACKSIZE = 99

var itemList:Array = []
var slotList:Array = []
var debugList:Array = []

var currSlot:Panel

var tempCurrSlot:Panel
var slotSize:Vector2
var scaledSlotSize
var overflow:int = 0

var gridMousePos:Vector2i

var player:Player

var isForExternalSlot:bool = false



func init(player:Player):
	await get_tree().create_timer(0.3).timeout
	self.player = player
	if self.player:
		self.player.inventory_manager.connect("OnInventoryChanged",OnInventoryChanged)

	


func _ready():
	await get_tree().create_timer(0.4).timeout
	for child in player_grid_inventory.get_children():
		child.queue_free()
	
	for index in range(maxInventorySlot):
		var slot = inventorySlot.instantiate()
		player_grid_inventory.add_child(slot)
		slot.item = null
		slot.inventoryHandler = self
		
		slotList.append(slot)
		slotSize = slot.custom_minimum_size	

	if playerInventory.size() > 0:
		update_slots()

		
			
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	##@NOTE The function below is for debug purposes only
	#_showDebugList()
	if !parentControl.isDragging:
		gridMousePos = Vector2i(get_global_mouse_position()/slotSize)
		if gridMousePos in getSlotPositions():
			tempCurrSlot= currSlot
			
		else:
			if currSlot:
				currSlot.item_texture.global_position = currSlot.original_global_position
				currSlot.label.global_position = currSlot.original_label_global_position
			parentControl.isDragging = false
			currSlot = null
			tempCurrSlot= null

func _showDebugList():
	await get_tree().create_timer(0.5).timeout
	debugList.clear()
	for i in range(maxInventorySlot):
		debugList.append(slotList[i].item)
	print(debugList)

func update_slots():
	for i in range(maxInventorySlot):
		if playerInventory[i]:
			var GridSlotPos = Vector2i(slotList[i].position/slotSize)
			slotList[i].item = playerInventory[i].item
			slotList[i].amount =playerInventory[i].amount
			slotList[i].item_texture.position = GridSlotPos 
			slotList[i].label.position = GridSlotPos + Vector2i(120,100)
		else:
			slotList[i].item = null

func getSlotPositions()->Array[Vector2i]:
	scaledSlotSize = slotSize * player_grid_inventory.scale
	var gridSlotPos:Vector2i
	var gridSlotPosList:Array[Vector2i]
	gridSlotPosList.clear()
	for slot in slotList:
		gridSlotPos = Vector2i(slot.global_position/scaledSlotSize)
		gridSlotPosList.append(gridSlotPos)
	return gridSlotPosList
	
func getSlotBasedOnPosition(globalMousePos:Vector2)->Panel:
	scaledSlotSize = slotSize * player_grid_inventory.scale
	gridMousePos = globalMousePosToLocalGrid(globalMousePos)
	var foundSlot:Panel = null
	for slot in slotList:
		var GridSlotPos = Vector2i(slot.global_position/scaledSlotSize)
		if gridMousePos == GridSlotPos:
			foundSlot = slot
	
	return foundSlot

func globalMousePosToLocalGrid(globalMousePos:Vector2)->Vector2i:
	scaledSlotSize = slotSize * player_grid_inventory.scale
	var slotPos:Vector2i = Vector2i.ZERO
	slotPos = Vector2i(globalMousePos/scaledSlotSize)
	return slotPos

func insertItem(item:MaterialData,currAmount:int)->int:
	if overflow <= 0:
		overflow = currAmount
	else:
		overflow += currAmount
	
	for index in range(maxInventorySlot):
		var GridSlotPos = Vector2i(slotList[index].position/slotSize)
		if slotList[index].item ==null:
			slotList[index].item = item
			slotList[index].amount = overflow
			slotList[index].item_texture.position = GridSlotPos 
			slotList[index].label.position = GridSlotPos + Vector2i(120,100)
			overflow = 0
			break
				
		elif slotList[index].item == item:
			if slotList[index].amount < MAXSTACKSIZE:
				var availableSpace = MAXSTACKSIZE - slotList[index].amount 
		
				if overflow <= availableSpace:
					slotList[index].amount += overflow
					overflow = 0
					break
				else:
					slotList[index].amount += availableSpace
					overflow -= availableSpace
	return overflow
func removeItem(item_amount: int,globalMousePos:Vector2) -> int:
	randomize()
	var to_remove = item_amount
	var removed = 0

	if globalMousePosToLocalGrid(globalMousePos) in getSlotPositions():
		var currGotSlot = getSlotBasedOnPosition(globalMousePos)
		if currGotSlot.item:
			if currGotSlot.amount > 0:
				if to_remove <= currGotSlot.amount:
					currGotSlot.amount -= to_remove
					if currGotSlot.amount <= 0:
						for index in range(maxInventorySlot):
							if currGotSlot.item == playerInventory[index].item:
								playerInventory[index] = null
								if parentControl.player and !isForExternalSlot:
									var itemDropped = materialInstance.instantiate()
									itemDropped .itemData = currGotSlot.item
									itemDropped.amount = to_remove
									itemDropped.global_position = parentControl.player.global_position + Vector2(randi_range(-5,5),20)
									parentControl.player.localLevel.add_child(itemDropped)
								currGotSlot.item = null	
								break
					else:
						for index in range(maxInventorySlot):
							if currGotSlot.item == playerInventory[index].item:
								playerInventory[index].amount -= to_remove
								break
						if parentControl.player:
							var itemDropped = materialInstance.instantiate()
							itemDropped .itemData = currGotSlot.item
							itemDropped.amount = to_remove
							itemDropped.global_position = parentControl.player.global_position + Vector2(randi_range(-5,5),20)
							parentControl.player.localLevel.add_child(itemDropped)
						
					removed += to_remove
					to_remove = 0
	
	


	return removed
	


##@NOTE Name purposely vague to fit cases for item and no item
func swap(item:MaterialData,currAmount:int, globalMousePos:Vector2):
	var prevSlot = currSlot
	var currSlot = getSlotBasedOnPosition(globalMousePos)
	if globalMousePosToLocalGrid(globalMousePos) in getSlotPositions():
		var currGotSlot = getSlotBasedOnPosition(globalMousePos)
		if getSameItemCount(item) <= 1:
			if currGotSlot.item == null:
				for temp in slotList:
					if temp.item == item:
						currGotSlot.item = item
						currGotSlot.amount = currAmount
						temp.item = null
						temp = null
						currGotSlot = null
						break
			else:
				if currGotSlot .item != item:
					_swapSlotsWithinInventory(currGotSlot,prevSlot)
		else:
			if currSlot.item:
				if currSlot.item != prevSlot.item:
					_swapSlotsWithinInventory(currSlot,prevSlot)
				elif currSlot.item == item and currSlot.amount <= 99:
					if currSlot != prevSlot:
						_addStack(currSlot,prevSlot,prevSlot.amount)
						prevSlot = null
			else:
				_swapSlotsWithinInventory(currSlot,prevSlot)
				
			#if currSlot.item == prevSlot.item:
				#if currSlot.amount >= 99:
					
					#_swapSlotsWithinInventory(currSlot.item,prevSlot.item)
	
		
func _swapSlotsWithinInventory(oldPanel:Panel =null,newPanel:Panel=null) ->bool:
	var index1:int
	var index2 :int
	
	var temp_item = oldPanel.item
	var temp_amount = oldPanel.amount
	oldPanel.item = newPanel.item
	oldPanel.amount = newPanel.amount
	newPanel.item = temp_item
	newPanel.amount = temp_amount
		
	
	
	
	return true	

func _addStack(currSlot:Panel=null,prevSlot:Panel=null,currAmount:int = 0)->bool:
	if currSlot.amount < MAXSTACKSIZE:
		currSlot.amount += currAmount
		prevSlot.item = null
		return true
	return false
	


func _getItemIndex(item:MaterialData) -> int:
	for slot in range(maxInventorySlot):
		if slotList[slot].item == item:
			return slot
	
	return -1



func getSameItemCount(item:MaterialData)->int:
	var count:int = 0
	for slot in  range(maxInventorySlot):
		if slotList[slot].item == item:
			count +=1
	return count

func OnInventoryChanged(inventory):
	update_slots()
	
func convertSlotListToInventoryData():
	var tempArray:Array[SlotData]
	tempArray.clear()
	for index in len(slotList):
		var slotToBeAdded = SlotData.new()
		if slotList[index].item:
			slotToBeAdded.item = slotList[index].item
			slotToBeAdded.amount = slotList[index].amount
			tempArray.append(slotToBeAdded)
		else:
			tempArray.append(null)
		
		slotList[index].item = null
	player.inventory = tempArray
	
			
				
