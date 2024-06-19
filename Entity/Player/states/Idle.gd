extends PlayerActivityState

@export var attack:State


var lerp_timer: Timer


func enter() -> void:
	super()
	lerp_to_zero()
	if !parent.isMachineUI:
		parent.itemHUDPlaceholder.visible = true
		parent.playerHUD.visible = true
	
	await parent.get_tree().create_timer(0.2).timeout
	
	parent.isPressable = true
	parent.velocity.x = 0.0
	

func exit()->void:
	pass
		
	
func update(delta: float) -> void:
	super(delta)

	
	if parent.staff and parent.canInput:
		if parent.isStaffEquipped:
			parent.staff.customAnimation.play("idleFront")
		else:
			parent.staff.customAnimation.play("RESETFRONT")
			
	
func process_input(event)->void:
	super(event)
	moveComponent.axis = moveComponent.get_movement_direction()

	if moveComponent.axis:
		transitioned.emit("move")
		
	if parent.levelTilemap and !parent.isLevelTransitioning:
		var mouseTilePos = parent.levelTilemap.local_to_map(parent.mousePos)
		var materialDroppedData = parent.levelTilemap.get_cell_tile_data(4,mouseTilePos)
		
		if materialDroppedData:
			var materialCategory = materialDroppedData.get_custom_data("materialCategory")
			if Input.is_action_just_pressed("ACTION") and materialCategory == "wood":
				transitioned.emit("cut")
				
					
			
func lerp_to_zero():
	# Gradually lerp the velocity to 0
	parent.velocity.x = lerp(parent.velocity.x, 0.0, 0.2)
	parent.velocity.y = lerp(parent.velocity.y, 0.0, 0.2)

# Check if the velocity is close enough to 0
	if abs(parent.velocity.x) < 0.01:
		parent.velocity.x = 0.0


func _on_player_on_damage_taken(damageAmount:float):
	parent.currHealth -= damageAmount
	parent.currHealth = clamp(parent.currHealth,0,parent.playerData.MaxHealth)
	transitioned.emit("damaged")
