class_name InventoryHandler
extends Control
##Item max stack szie
const MAXSTACKSIZE = 99

##The parent control is what this inventoryHandler is
@export var parentControl:Control
##Storing the reference to player inventory
@export var playerInventory:Array[SlotData]

##The slot is what enables the player to store and see the items (Using MVC pattern)
@export var inventorySlot:PackedScene

@export var maxInventorySlot:int

##Material instance is a universal wild card for materials meaning to say as long it has material data, it will morph into that material
@export var materialInstance:PackedScene

##Not to be confused with inventory, this one is the grid of the inventory
@onready var player_grid_inventory = $PlayerGridInventory

##Keep track of the slots with their data
var slotList:Array = []

##NOTE for debug purposes
var debugList:Array = []

##Keep track what is the current selected slot
var currSlot:Panel
var tempCurrSlot:Panel

var slotSize:Vector2
var scaledSlotSize
var overflow:int = 0

var gridMousePos:Vector2i

var player:Player

var isForExternalSlot:bool = false

##@NOTE The init function takes in player cause of the nature of fast loading, to ensure there no error I put a delay to ensure everything is assigned
func init(player:Player):
	await get_tree().create_timer(0.3).timeout
	self.player = player
	if self.player:
		self.player.inventory_manager.connect("OnInventoryChanged",OnInventoryChanged)

##NOTE same case for init function 
func _ready():
	await get_tree().create_timer(0.4).timeout
	for child in player_grid_inventory.get_children():
		child.queue_free()
	
	##WARNING To avoid any crashes or bugs, the slotList must have null items = N max inventory
	for index in range(maxInventorySlot):
		var slot = inventorySlot.instantiate()
		player_grid_inventory.add_child(slot)
		slot.item = null
		slot.inventoryHandler = self
		
		slotList.append(slot)
		slotSize = slot.custom_minimum_size	

	##NOTE keep this to avoid visual glitch
	if playerInventory.size() > 0:
		update_slots()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	##@NOTE The function below is for debug purposes only
	#_showDebugList()
	
	##NOTE The reason why the isDragging is in parentControl and not within the inventoryHanlder is cause the mouse will in global position of the parent rather than the inventory
	if !parentControl.isDragging:
		gridMousePos = Vector2i(get_global_mouse_position()/slotSize)
	
		if currSlot:
			##NOTE Reset the position
			currSlot.item_texture.global_position = currSlot.original_global_position
			currSlot.label.global_position = currSlot.original_label_global_position
		
		##NOTE Prevent weird bug	
		parentControl.isDragging = false
		currSlot = null
		

func _showDebugList():##Shows what data is in what slots
	await get_tree().create_timer(0.5).timeout
	debugList.clear()
	for i in range(maxInventorySlot):
		debugList.append(slotList[i].item)
	print(debugList)

##Whenever there changes to the slots we update the list accordingly
func update_slots()->bool:
	for i in range(maxInventorySlot):
		if playerInventory[i]:
			var GridSlotPos = Vector2i(slotList[i].position/slotSize)
			slotList[i].item = playerInventory[i].item
			slotList[i].amount =playerInventory[i].amount
			slotList[i].item_texture.position = GridSlotPos 
			slotList[i].label.position = GridSlotPos + Vector2i(120,100)
		else:
			slotList[i].item = null
	return true

##The reason we getting the slot positions is to do check logics with these, for example I want to check if the mouse is within the slot positions
##NOTE The position is converted from global to grid position similar to local_to_map() function
func getSlotPositions()->Array[Vector2i]:
	##NOTE SCALES MATTERS
	scaledSlotSize = slotSize * player_grid_inventory.scale
	
	var gridSlotPos:Vector2i
	var gridSlotPosList:Array[Vector2i]
	
	##To avoid memory leak
	gridSlotPosList.clear()
	
	for slot in slotList:
		gridSlotPos = Vector2i(slot.global_position/scaledSlotSize)
		gridSlotPosList.append(gridSlotPos)
	return gridSlotPosList

##NOTE The position is converted from global to grid position similar to local_to_map() function
func getSlotBasedOnPosition(globalMousePos:Vector2)->Panel:
	##NOTE SCALES MATTERS
	scaledSlotSize = slotSize * player_grid_inventory.scale
	
	gridMousePos = globalMousePosToLocalGrid(globalMousePos)
	
	##NOTE prevent weird bug
	var foundSlot:Panel = null
	
	for slot in slotList:
		var GridSlotPos = Vector2i(slot.global_position/scaledSlotSize)
		if gridMousePos == GridSlotPos:
			foundSlot = slot
	
	return foundSlot
	
##NOTE The position is converted from global to grid position similar to local_to_map() function
func globalMousePosToLocalGrid(globalMousePos:Vector2)->Vector2i:
	scaledSlotSize = slotSize * player_grid_inventory.scale
	var slotPos:Vector2i = Vector2i.ZERO
	slotPos = Vector2i(globalMousePos/scaledSlotSize)
	return slotPos

##Insert item have several logics that must take in for consideration
func insertItem(item:MaterialData,currAmount:int)->int:
	##1: We check for overflow of items because that we set max stacks to be 99, it's important to take account the chances that it will overflow (exp:99 + 5 then what?)
	##2: Hence we check for overflow
	
	##Because overflow is a class variable rather than a local variable, we need to check if it's zero else we add alongside with the other overflows
	if overflow <= 0:
		overflow = currAmount
	else:
		overflow += currAmount
	
	##CASE 1 when there no item then simply insert
	for index in range(maxInventorySlot):
		var GridSlotPos = Vector2i(slotList[index].position/slotSize)
		if slotList[index].item ==null:
			slotList[index].item = item
			slotList[index].amount = overflow
			slotList[index].item_texture.position = GridSlotPos 
			slotList[index].label.position = GridSlotPos + Vector2i(120,100)
			overflow = 0
			break##Break to ensure it is inserted once
		
		##CASE 2 when there are items then we need to check if it's the same and is the amount below the max stack size		
		elif slotList[index].item == item:
			if slotList[index].amount < MAXSTACKSIZE:
				##We keep track of available space to easily check for overflow 
				var availableSpace = MAXSTACKSIZE - slotList[index].amount 
				
				##If the overflow is below the available space we just increase the amount
				if overflow <= availableSpace:
					slotList[index].amount += overflow
					overflow = 0
					break##Break to ensure it is inserted once
				else:
					##Overflow too much? Just add the availablespace to the next slot
					slotList[index].amount += availableSpace
					overflow -= availableSpace
	return overflow

##WARNING removeItem function is unfortunately messy
##Similar to the InsertItem we need to take account several scenerios
func removeItem(item_amount: int,globalMousePos:Vector2) -> bool:
	##NOTE Only use when player is in the picture, when testing in debugmode it doesnt care if there player or not
	randomize()
	
	##1: We need to take account how many items the player will remove
	##2: For FYP, we will take account scenerio where player ONLY REMOVE ONE ITEM
	##3: In the future, this variable should take account multiple items being remove from inventory
	var to_remove = item_amount
	var removed = 0

	##We want to check if the mouse is hovering over the inventory
	##For FYP: to remove the item is pressing right click
	if globalMousePosToLocalGrid(globalMousePos) in getSlotPositions():
		var currGotSlot = getSlotBasedOnPosition(globalMousePos)
		##We need to check if there item in the selected current slot
		if currGotSlot.item and currGotSlot.amount > 0:
			if to_remove <= currGotSlot.amount:
				currGotSlot.amount -= to_remove
				##CASE 1: The current selected slot amount is equal to 0
				if currGotSlot.amount <= 0:
					if player and !isForExternalSlot:##We want to check if there player to begin with (the variaible is same as parentControl.player)
						for index in range(maxInventorySlot):
							##We need to check if the item selected is not null in the player inventory
							if playerInventory[index] != null:
								if currGotSlot.item == playerInventory[index].item:
									##We found the item? Then we null it cause the current selected slot is zero
									playerInventory[index] = null
									
									##isForExternalSlot is to prevent spawning items when the player removes the item to one of the slots in the machine
		
									##Here we create a new object called material instance and set the variables accordinly
									var itemDropped = materialInstance.instantiate()
									itemDropped.itemData = currGotSlot.item
									itemDropped.amount = to_remove
									##This is why randomize() is used so it can spawn in different positions relative to the player
									itemDropped.global_position = parentControl.player.global_position + Vector2(randi_range(-5,5),20)
									
									##So it spawns in the level and not the player or anywhere
									parentControl.player.localLevel.add_child(itemDropped)
										
									##To remove item from current selected slot
									currGotSlot.item = null	
									break##Break to ensure things run only once
				else:
					for index in range(maxInventorySlot):
						##Case 2 when player remove item only a few items either only 1 or {N:N!=0} items
						##Also to check if the playerInventory slotdata is not null
						if playerInventory[index]:
							if currGotSlot.item == playerInventory[index].item:
								playerInventory[index].amount -= to_remove
								break##Break to ensure things run only once
					
					##Spawn items		
					if parentControl.player:
						var itemDropped = materialInstance.instantiate()
						itemDropped .itemData = currGotSlot.item
						itemDropped.amount = to_remove
						itemDropped.global_position = parentControl.player.global_position + Vector2(randi_range(-5,5),20)
						parentControl.player.localLevel.add_child(itemDropped)
						
					removed += to_remove
					to_remove = 0
	return true




##@NOTE Name purposely vague to fit cases for item and no item
##Swap is a slightly complicated function because it's responsible for the movement/swapping of items in the inventory
func swap(item:MaterialData,currAmount:int, globalMousePos:Vector2):
	##We msut take account of two things, what is the previous Slot and what is the current slot
	var prevSlot = currSlot
	var currSlot = getSlotBasedOnPosition(globalMousePos)
	
	##We need to check where is the mouse is in the inventory
	if globalMousePosToLocalGrid(globalMousePos) in getSlotPositions():
		
		var currGotSlot = getSlotBasedOnPosition(globalMousePos)
		
		##Here I am checking for the frequency of the same item to take account if we need to add item amount or not
		if getSameItemCount(item) <= 1:
			##If the frequency of item is less than or equal to oner then just simply insert
			if currGotSlot.item == null:
				for temp in slotList:
					if temp.item == item:
						currGotSlot.item = item
						currGotSlot.amount = currAmount
						temp.item = null
						temp = null
						currGotSlot = null
						break##Break to ensure things run only once
			else:
				##If item is not the same then do swapping
				if currGotSlot .item != item:
					_swapSlotsWithinInventory(currGotSlot,prevSlot)
		else:
			##Here we check if the frequency of the same item is more than one 
			if currSlot.item:
				##Same thing not same then swap
				if currSlot.item != prevSlot.item:
					_swapSlotsWithinInventory(currSlot,prevSlot)
				##Same thing then add
				elif currSlot.item == item and currSlot.amount <= 99:
					if currSlot != prevSlot:
						_addStack(currSlot,prevSlot,prevSlot.amount)
						prevSlot = null
			else:
				##To ensure we can swap with null items
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

##Responsible to add the amount of the same item
func _addStack(currSlot:Panel=null,prevSlot:Panel=null,currAmount:int = 0)->bool:
	if currSlot.amount < MAXSTACKSIZE:
		currSlot.amount += currAmount
		prevSlot.item = null
		return true
	return false
	

##NOTE I forgot why I coded this so just keep it
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

##To communicate changes made by other objects (i.e Player object)
func OnInventoryChanged(inventory):
	update_slots()



func convertSlotListToInventoryData():
	var tempArray: Array = []
	for index in len(slotList):
		var slotToBeAdded = SlotData.new()
		if slotList[index].item:
			slotToBeAdded.item = slotList[index].item
			slotToBeAdded.amount = slotList[index].amount
			tempArray.append(slotToBeAdded)
		else:
			tempArray.append(null)

		slotList[index].item = null

	# Directly update the player inventory
		if player:
			for i in range(maxInventorySlot):
				if i < tempArray.size():
					player.inventory[i] = tempArray[i]
				

	tempArray.clear()	
	
	
			
				
