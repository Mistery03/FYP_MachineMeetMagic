extends State



@export
var idle_state: State

@onready var walk_timer = $"../../walkSFX"

var prevMouseTilePos = Vector2i(-1,-1)

func enter() -> void:
	super()
	parent.itemHUDPlaceholder.visible = true

	
func update(delta: float) -> void:
	if parent.homeTilemap:
		var parentPos = parent.homeTilemap.local_to_map(parent.position)
		var floorData:TileData = parent.homeTilemap.get_cell_tile_data(0,parentPos) 
		if floorData:
			if walk_timer.time_left <=0:
				parent.walking_on_wood_sfx.pitch_scale = randf_range(0.8,1.2)
				parent.walking_on_wood_sfx.play()
				walk_timer.start(0.5)
				
	if parent.levelTilemap and !parent.isLevelTransitioning:
		var mouseTilePos = parent.levelTilemap.local_to_map(parent.mousePos)
		var parentPos = parent.levelTilemap.local_to_map(parent.position)
		
		var materialDroppedData = parent.levelTilemap.get_cell_tile_data(4,mouseTilePos)
		var floorData:TileData = parent.levelTilemap.get_cell_tile_data(1,parentPos) 
		if floorData:
			if walk_timer.time_left <=0:
				parent.walking_on_grass_sfx.pitch_scale = randf_range(0.8,1.2)
				parent.walking_on_grass_sfx.play()
				walk_timer.start(0.5)
		var is_in_area:bool = false
		for pos in parent.objectsPosInLevelList:
			for validPos in parent.levelTilemap.get_surrounding_cells(pos):
				if parentPos == validPos or parentPos == pos:
					if mouseTilePos == pos and parent.isStaffEquipped:
						is_in_area = true
						break
						
		if materialDroppedData:
			var materialName = materialDroppedData.get_custom_data("materialName")
			var materialCategory = materialDroppedData.get_custom_data("materialCategory")
			if is_in_area and materialCategory == "wood":
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
	var movement_direction = moveComponent.get_movement_direction()	
	
	if !movement_direction:
		#resetStaffPosition()
		transitioned.emit("idle")

	updatePlayerVelocity(delta,movement_direction)
	#parent.velocity.x =  clamp(parent.velocity.x,-move_speed,move_speed)
	parent.move_and_slide()
	



func process_input(event)->void:
	if Input.is_action_just_pressed("EXIT"):
		toggle_menu()


	


	

func resetStaffPosition():
	parent.staff.z_index = -1
	#parent.staff.rotation = 1.5708
	#parent.staff.position = parent.staff.originalPos
	#parent.staff.animation.flip_v = false

func updatePlayerVelocity(delta, movement_direction):
	parent.velocity = movement_direction * parent.moveSpeed * delta
	parent.animation.flip_h = movement_direction.x < 0
	changeAnimationVelocity()
	
	if parent.staff:
		if !parent.isStaffEquipped:
			#parent.staff.animation.flip_v = movement_direction.y < 0
			updateStaffPosX()
			updateStaffPosY()
		else:
			if parent.velocity.y >0:
				parent.staff.customAnimation.play("idleFront")
			if parent.velocity.y < 0:
				parent.staff.customAnimation.play("idleBack")
			if parent.velocity.x <0:
				parent.staff.customAnimation.play("idleBack")
			if parent.velocity.x > 0:
				parent.staff.customAnimation.play("idleFront")

		
func changeAnimationVelocity():
	if parent.velocity.y < 0:
		animations.play("WALKBACKWARD")
	elif parent.velocity.y >0:
		animations.play("WALKFRONT")
	elif parent.velocity.x < 0 or parent.velocity.x > 0:
		animations.play(animation_name.to_upper())

func updateStaffPosX():
	#parent.staff.z_index = -1
	if parent.velocity.x < 0:
		parent.staff.customAnimation.play("RESETRIGHT")
		#parent.staff.position = Vector2(50, -20) 
	elif parent.velocity.x > 0:
		parent.staff.customAnimation.play("RESETLEFT")
		#parent.staff.position = Vector2(-50, -20)


func updateStaffPosY():
	
	if parent.velocity.y < 0:
		parent.staff.customAnimation.play("RESETBACK")
	elif parent.velocity.y >0:
		parent.staff.customAnimation.play("RESETFRONT")
		


	
func staffPosWhenXandY(zIndex:int): #when both action both x and y are pressed
	parent.staff.z_index = zIndex

	
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
