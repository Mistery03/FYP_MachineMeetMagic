extends HBoxContainer

@export var recipe:CraftingRecipe = null

@export_category("Inventory Controller")
@export var inventoryHandler:InventoryHandler

var ingredients:Array[SlotData] = [null,null,null]
var multiplier:int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if recipe:
		ingredients = recipe.craftingList
	update_material_slots()

	
func update_material_slots():
	var material_slots = get_children()
	for i in range(len(material_slots)):
		if i < len(ingredients) and ingredients[i] != null:
			var ingredient = ingredients[i]
			var required_amount = ingredient.amount * multiplier
			var itemAmount = inventoryHandler.checkTotalItemAmount(ingredient.item)
		
			material_slots[i].visible = true
			material_slots[i].texture = ingredients[i].item.texture
			material_slots[i].amount.text = str(required_amount)
			
			if itemAmount < required_amount:
				material_slots[i].amount.set("theme_override_colors/font_color", Color(1, 0, 0))
			else:
				material_slots[i].amount.set("theme_override_colors/font_color", Color(0, 1, 0))
		else:
			material_slots[i].visible = false
