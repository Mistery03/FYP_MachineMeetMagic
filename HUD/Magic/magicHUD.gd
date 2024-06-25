extends Control

@export var magicManager:Node

var currIndex:int = 0
var prevIndex:int = 0
var currIncreament:int = 0
var isMagicnull:bool = false
var unlocked_magic 
@onready var texture_rect = $border/TextureRect
@onready var player = $"../../.."
@onready var darkened = $Darkened
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_key_input(event):
	
	if Input.is_action_just_pressed("EQUIPMAGIC"):
		unlocked_magic = magicManager.checkMagicUnlock()
		print("size",unlocked_magic.size())
		if unlocked_magic.size() > 0:
			prevIndex = currIndex
			
			print("Incre ",currIncreament)
			currIndex = currIncreament % unlocked_magic.size()
			print("Index ",currIndex)
			currIncreament += 1
			print("Logic",currIncreament >= unlocked_magic.size())
			print("Logic2",currIndex != prevIndex)
			print('preindex', prevIndex)
			if currIncreament >= unlocked_magic.size() and currIndex != prevIndex:
				currIncreament = 0
			
			if unlocked_magic[currIndex]:
				player.isMagicAvailable = true
				if unlocked_magic[currIndex].attackBased:
					texture_rect.visible = true
					texture_rect.texture = unlocked_magic[currIndex].skillButton
					player.magic_manager.magicData = unlocked_magic[currIndex]
				else:
					print("Magic not attack based")
			else:
				player.isMagicAvailable =  false
				texture_rect.visible = false
				player.magicManager.magicData = null
				isMagicnull = true
			
	if isMagicnull:
		print("magic", isMagicnull)
		currIncreament += 1
		prevIndex = currIndex
		currIndex = currIncreament % unlocked_magic.size()
		
		currIncreament = clamp(currIncreament,0,unlocked_magic.size())
		if currIncreament == unlocked_magic.size() and currIndex != prevIndex:
			currIncreament = 0
		if unlocked_magic[currIndex]:
			isMagicnull = false
