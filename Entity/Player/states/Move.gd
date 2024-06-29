extends PlayerActivityState

@export_category("State Setting")
@export var attack:State

@export_category("Timer Setting")
@export var walk_timer:Timer

var currAnimation

func enter() -> void:
	super()

func update(delta: float) -> void:
	super(delta)
	if parent.isInCutscene:
		transitioned.emit("idle")
	if parent.homeTilemap:
		var parentPos = parent.homeTilemap.local_to_map(parent.position)
		var floorData:TileData = parent.homeTilemap.get_cell_tile_data(0,parentPos)
		if floorData:
			if walk_timer.time_left <=0:
				parent.walking_on_wood_sfx.pitch_scale = randf_range(0.8,1.2)
				parent.walking_on_wood_sfx.play()
				walk_timer.start(0.5)

	if parent.levelTilemap and !parent.isLevelTransitioning:
		var parentPos = parent.levelTilemap.local_to_map(parent.position)
		var floorData:TileData = parent.levelTilemap.get_cell_tile_data(1,parentPos)
		if floorData:
			if walk_timer.time_left <=0:
				parent.walking_on_grass_sfx.pitch_scale = randf_range(0.8,1.2)
				parent.walking_on_grass_sfx.play()
				walk_timer.start(0.5)

func physics_update(delta: float) -> void:
	var movement_direction = moveComponent.get_movement_direction()

	if !movement_direction:
		#resetStaffPosition()
		transitioned.emit("idle")

	updatePlayerVelocity(delta,movement_direction)
	#parent.velocity.x =  clamp(parent.velocity.x,-move_speed,move_speed)
	parent.move_and_slide()

func process_input(event)->void:
	super(event)

func resetStaffPosition():
	parent.staff.z_index = -1

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
		currAnimation = "WALKBACKWARD"
		animations.play(currAnimation)

	elif parent.velocity.y >0:
		currAnimation = "WALKFRONT"
		animations.play(currAnimation)

	elif parent.velocity.x < 0 or parent.velocity.x > 0:
		currAnimation =animation_name.to_upper()
		animations.play(currAnimation)

func updateStaffPosX():
	#parent.staff.z_index = -1
	if parent.velocity.x < 0:
		parent.staff.customAnimation.play("RESETRIGHT")

	elif parent.velocity.x > 0:
		parent.staff.customAnimation.play("RESETLEFT")

func updateStaffPosY():
	if parent.velocity.y < 0:
		parent.staff.customAnimation.play("RESETBACK")
	elif parent.velocity.y >0:
		parent.staff.customAnimation.play("RESETFRONT")

func staffPosWhenXandY(zIndex:int): #when both action both x and y are pressed
	parent.staff.z_index = zIndex





