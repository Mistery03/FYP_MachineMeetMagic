class_name PlayerActivityState
extends State

@export_category("Roll Stamina Settings")
@export var rollStaminaComsumption:float
@export var punishMultiplier:float = 1 ##Set to 1 by default and increasing the multipler will consume more stamina

var isBuildEnabled:bool = true
var prevMouseTilePos = Vector2i(-1,-1)

func enter() -> void:
	super()

func exit() -> void:
	pass

func update(delta: float) -> void:
	if parent.currHealth <= 0:
		transitioned.emit("death")
		
	if !moveComponent.isDashing():
		parent.currStamina +=  rollStaminaComsumption * punishMultiplier * delta

	if parent.levelTilemap and !parent.isLevelTransitioning:
		var mouseTilePos = parent.levelTilemap.local_to_map(parent.mousePos)
		var parentPos = parent.levelTilemap.local_to_map(parent.position)
		
		if parent.levelTilemap.get_layer_name(4):
			var materialDroppedData = parent.levelTilemap.get_cell_tile_data(4,mouseTilePos)
			var is_in_area:bool = false

			for pos in parent.objectsPosInLevelList:
				for validPos in parent.levelTilemap.get_surrounding_cells(pos):
					if parentPos == validPos or parentPos == pos :
						if mouseTilePos == pos and parent.isStaffEquipped:
							is_in_area = true
							break

			if materialDroppedData:
				var materialName = materialDroppedData.get_custom_data("materialName")
				var materialCategory = materialDroppedData.get_custom_data("materialCategory")
				if is_in_area and materialCategory == "wood":
					parent.isAttackable = false
					update_text_on_mouse(materialName, "Cut ")
				elif is_in_area and materialCategory == "rock":
					update_text_on_mouse(materialName, "Mine ")
				else:
					update_text_on_mouse(materialName)
				set_tilemap_cell(mouseTilePos)

		if mouseTilePos != prevMouseTilePos:
			parent.levelTilemap.erase_cell(5,prevMouseTilePos)
			parent.text_on_mouse.visible = false
		prevMouseTilePos = mouseTilePos

func physics_update(delta: float) -> void:
	pass

func process_input(event)->void:

	if Input.is_action_just_pressed("ACTION") and parent.isStaffEquipped and parent.canInput and !parent.isMagicAvailable:
		parent.staff.customAnimation.stop()
		parent.canInput = false
		transitioned.emit("attack")

	if event is InputEventKey:
		if event.is_action_pressed("BUILD") and parent.isBuildEnabled and !parent.playerInventoryController.visible:
			transitioned.emit("build")

		if event.is_action_pressed("EXIT") and parent.isPressable:
			toggle_inventory()
			parent.isInInventory = !parent.isInInventory


		if event.is_action_pressed("ROLL") and !moveComponent.isDashing() and parent.canDash and parent.currStamina >= 20:
			parent.set_collision_layer_value(1,false)
			parent.currStamina -= 20
			transitioned.emit("roll")

		if event.is_action_pressed("CHARACTERSHEET") and !parent.isInInventory:
			parent.magicUI.visible = !parent.magicUI.visible
			parent.isPressable = !parent.isPressable

func toggle_inventory():
	# Toggle the visibility of the menu
	parent.playerInventoryController.visible = !parent.playerInventoryController.visible

func update_text_on_mouse(material_name, prefix=""):
	parent.text_on_mouse.text = prefix + material_name
	parent.text_on_mouse.global_position = parent.mousePos + Vector2(-20, -10)
	parent.text_on_mouse.visible = true

func set_tilemap_cell(mouseTilePos):
	parent.levelTilemap.set_cell(5, mouseTilePos, 2, parent.levelTilemap.get_cell_atlas_coords(4, mouseTilePos))
	parent.levelTilemap.set_layer_modulate(5, Color8(255, 255, 255, 255))
