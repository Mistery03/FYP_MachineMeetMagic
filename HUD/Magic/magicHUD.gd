extends Control

@export var magicManager:Node
@export var player:Player

var currIndex:int = 0
var prevIndex:int = 0
var currIncrement:int = 0
var isMagicNull:bool = false
var unlocked_magic: Array = []
var magicSize:Array = [null, null, null, null,null]
@onready var texture_rect = $border/TextureRect

@onready var darkened = $Darkened
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func storeArray():
	var unlock_indices = magicManager.checkMagicUnlock()
	unlocked_magic.clear()  # Clear the current dynamic array
	
	for i in len(unlock_indices):
		#print("magicDataList:", magicManager.magicDataList[index])
		unlocked_magic.append(magicManager.magicDataList[i])
		
	transfer_to_fixed_array()

func transfer_to_fixed_array():
	# Clear the fixed array first
	for i in range(magicSize.size()):
		magicSize[i] = null
	# Transfer items from unlocked_magic to magicSize
	for i in range(min(unlocked_magic.size(), magicSize.size())):
		magicSize[i] = unlocked_magic[i]
		print("array", magicSize[i])
	
func _unhandled_key_input(event):
	
	if Input.is_action_just_pressed("EQUIPMAGIC"):
		storeArray()
		print("Fixed array size: ", magicSize.size())
		print("Fixed array content: ", magicSize)

		if magicSize.size() > 0:
			prevIndex = currIndex
			print("Incre ", currIncrement)

			currIndex = currIncrement % magicSize.size()
			print("Index ", currIndex)

			currIncrement += 1
			print("Logic", currIncrement >= magicSize.size())
			print("Logic2", currIndex != prevIndex)
			print('preindex', prevIndex)

			if currIncrement >= magicSize.size():
				currIncrement = 0

			var current_magic = magicSize[currIndex]
			if current_magic:
				player.isMagicAvailable = true

				if current_magic.attackBased:
					texture_rect.visible = true
					texture_rect.texture = current_magic.skillButton
					player.magic_manager.magicData = current_magic
				else:
					print("Magic not attack based")
			else:
				player.isMagicAvailable = false
				texture_rect.visible = false
				player.magic_manager.magicData = null
				isMagicNull = true

	if isMagicNull:
		print("magic", isMagicNull)
		currIncrement += 1
		prevIndex = currIndex
		currIndex = currIncrement % magicSize.size()

		currIncrement = clamp(currIncrement, 0, magicSize.size())

		if currIncrement == magicSize.size():
			currIncrement = 0

		var next_magic = magicSize[currIndex]
		if next_magic:
			isMagicNull = false
