extends NinePatchRect

@onready var potion_icon = $PotionIcon
@onready var potion_name = $PotionName
@onready var potion_description = $PotionDescription
@onready var potion_inventory = $".."




# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	potion_icon.texture = potion_inventory.texture
	potion_name.text = potion_inventory.potionName
	potion_description.text = potion_inventory.description
