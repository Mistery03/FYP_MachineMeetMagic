class_name InventoryHanlder
extends Control

@export var parentControl:Control
@export var playerInventory:Array[MaterialData]
@export var inventorySlot:PackedScene
@export var maxInventorySlot:int

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


func _ready():
	await get_tree().create_timer(0.5).timeout
	for child in player_grid_inventory.get_children():
		child.queue_free()
	
	for index in range(maxInventorySlot):
		var slot = inventorySlot.instantiate()
		player_grid_inventory.add_child(slot)
		slot.item = null
		slot.inventoryHandler = self
		#slot.connect("dropped",on_item_dropped)
		slotList.append(slot)
		slotSize = slot.custom_minimum_size	

	for item in playerInventory:
		if itemList.size() < maxInventorySlot:
			item.amount = 1
			itemList.push_back(item)
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
		if i < len(itemList):
			var GridSlotPos = Vector2i(slotList[i].position/slotSize)
			slotList[i].item = itemList[i]
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

"""func remove_item(item_amount: int) -> int:
	var to_remove = item_amount
	var removed = 0

	for index in range(maxInventorySlot):
		if slotList[index].amount > 0:
			if to_remove <= slotList[index].amount:
				slotList[index].amount -= to_remove
				removed += to_remove
				to_remove = 0
				break
			else:
				removed += slotList[index].amount
				to_remove -= slotList[index].amount
				slotList[index].amount = 0

	return removed"""
	
func removeItem(item:MaterialData,currAmount:int) -> bool:
	scaledSlotSize = slotSize * player_grid_inventory.scale
	for slot in slotList:
		var GridSlotPos = Vector2i(slot.global_position/scaledSlotSize)
		if slot.item == item:
			slot.item = null
			itemList.erase(item)
			return true
	return false

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
			if currSlot.item and currSlot.amount >= 99:
				_swapSlotsWithinInventory(currSlot,prevSlot)
			else:
				_addStack(currSlot,prevSlot,prevSlot.amount)
				prevSlot = null
				
			
			prevSlot = null
			currSlot = null
			
				
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
		
	print(index1)
	print(index2)
	
	
	
	return true	

func _addStack(currSlot:Panel=null,prevSlot:Panel=null,currAmount:int = 0):
	if currSlot.amount < MAXSTACKSIZE:
		currSlot.amount += currAmount
	


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
	
