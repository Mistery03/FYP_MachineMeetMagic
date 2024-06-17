extends State

@export var attack:State

var prevMouseTilePos = Vector2i(-1,-1)
var lerp_timer: Timer
var isBuildEnabled:bool = true


func enter() -> void:
	super()
	lerp_to_zero()
	parent.itemHUDPlaceholder.visible = true
	
	await parent.get_tree().create_timer(0.2).timeout
	
	parent.isPressable = true
	parent.velocity.x = 0.0

func exit()->void:
	pass
		
	
func update(delta: float) -> void:
	if parent.levelTilemap and !parent.isLevelTransitioning:
		var mouseTilePos = parent.levelTilemap.local_to_map(parent.mousePos)
		var parentPos = parent.levelTilemap.local_to_map(parent.position)
		
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
	
	isBuildEnabled = parent.isBuildEnabled
	
	if parent.staff:
		if parent.isStaffEquipped:
			#parent.staff.customAnimation.play("idleFront")
			pass
		else:
			parent.staff.customAnimation.play("RESETFRONT")
	
func process_input(event)->void:
	moveComponent.axis = moveComponent.get_movement_direction()

	if moveComponent.axis:
		transitioned.emit("move")
		
	if parent.levelTilemap and !parent.isLevelTransitioning:
		var mouseTilePos = parent.levelTilemap.local_to_map(parent.mousePos)
		var materialDroppedData = parent.levelTilemap.get_cell_tile_data(4,mouseTilePos)
		
		if materialDroppedData:
			var materialCategory = materialDroppedData.get_custom_data("materialCategory")
			if Input.is_action_pressed("ACTION") and materialCategory == "wood":
				transitioned.emit("cut")
				
	
	if Input.is_action_just_pressed("BUILD") and isBuildEnabled and !parent.playerInventoryController.visible:
		transitioned.emit("build")
	
	if Input.is_action_just_pressed("EXIT") and parent.isPressable:
		toggle_menu()
		
	if Input.is_action_just_pressed("ACTION") and parent.isStaffEquipped and parent.isAttackable:
		parent.staff.customAnimation.stop()
		attack.currStateName = "idle"
		transitioned.emit("attack")
		

func lerp_to_zero():
	# Gradually lerp the velocity to 0
	parent.velocity.x = lerp(parent.velocity.x, 0.0, 0.2)
	parent.velocity.y = lerp(parent.velocity.y, 0.0, 0.2)

# Check if the velocity is close enough to 0
	if abs(parent.velocity.x) < 0.01:
		parent.velocity.x = 0.0

func toggle_menu():
	# Toggle the visibility of the menu
	parent.playerInventoryController.visible = !parent.playerInventoryController.visible 

func update_text_on_mouse(material_name, prefix=""):
	parent.text_on_mouse.text = prefix + material_name
	parent.text_on_mouse.global_position = parent.mousePos + Vector2(-20, -10)
	parent.text_on_mouse.visible = true

func set_tilemap_cell(mouseTilePos):
	parent.levelTilemap.set_cell(5, mouseTilePos, 2, parent.levelTilemap.get_cell_atlas_coords(4, mouseTilePos))
	parent.levelTilemap.set_layer_modulate(5, Color8(255, 255, 255, 255))
