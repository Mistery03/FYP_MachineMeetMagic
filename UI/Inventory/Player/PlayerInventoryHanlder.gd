class_name InventoryHanlder
extends Control

@export var parentControl:Control
@export var playerInventory:Array[MaterialData]
@export var inventorySlot:PackedScene
@export var maxInventorySlot:int

@onready var player_grid_inventory = $PlayerGridInventory

var itemList:Array = []
var slotList:Array = []
var debugList:Array = []

var currSlot:Panel
var tempCurrSlot:Panel
var slotSize:Vector2

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
			slotList[i].label.position = GridSlotPos + Vector2i(150,100)
		else:
			slotList[i].item = null

func getSlotPositions()->Array[Vector2i]:
	var gridSlotPos:Vector2i
	var gridSlotPosList:Array[Vector2i]
	gridSlotPosList.clear()
	for slot in slotList:
		gridSlotPos = Vector2i(slot.position/slotSize)
		gridSlotPosList.append(gridSlotPos)
	return gridSlotPosList
