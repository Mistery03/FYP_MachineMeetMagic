extends State

@export_category("Creatre Manager")
@export var creatureList:Array[MobData]
@export var maxCreatureSpawn:int

var validSpawnPositions = []

func enter() -> void:
	super()
	if parent.localLevel.levelName == "BossRoom" and parent.localLevel.creatureManager.get_child_count() <= 7:
		spawnSlimes()
	else:
		await get_tree().create_timer(5).timeout
		transitioned.emit("Chase")
		
func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func spawnSlimes():
	var grassGridPosList = parent.localLevel.tile_map.get_used_cells(1)
	for pos in grassGridPosList:
		var grassData = parent.localLevel.tile_map.get_cell_tile_data(1,pos)
		##Reusing the canGenerateCollectibles cause lazy
		var validSpawn = grassData.get_custom_data("canGenerateCollectibles")
		if validSpawn:
			validSpawnPositions.append(pos)
		
	for i in range(maxCreatureSpawn):
		if validSpawnPositions.size() == 0:
			break # No more valid positions to spawn creatures
		
		# Pick a random valid position
		var randomIndex = randi() % validSpawnPositions.size()
		var spawnPos = validSpawnPositions[randomIndex]

		# Remove the chosen position from the list to avoid spawning multiple creatures at the same position
		validSpawnPositions.remove_at(randomIndex)
		
		##NOTE Creature list returns MobData
		var creatureData= creatureList.pick_random()
		var creatureInstance = creatureData.mobInstance.instantiate()
		print(parent.localLevel.tile_map.map_to_local(spawnPos))
		creatureInstance.global_position = parent.localLevel.tile_map.map_to_local(spawnPos)
		creatureInstance.localLevel = self
		creatureInstance.chaseSpeed = 8500
		creatureInstance.maxHP = 60
		parent.localLevel.creatureManager.add_child(creatureInstance)
		parent.localLevel.creatureManager.init(parent.player)
		creatureInstance.animation.play("SPAWN")

		await get_tree().create_timer(0.2).timeout
		
	await get_tree().create_timer(2).timeout
	transitioned.emit("Chase")
