extends Room

func _ready():
	super()		
		

func spawnEnemies():
	var grassGridPosList = tile_map.get_used_cells(1)
	for pos in grassGridPosList:
		var grassData = tile_map.get_cell_tile_data(1,pos)
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
		creatureInstance.global_position = tile_map.map_to_local(spawnPos)
		creatureManager.add_child(creatureInstance)
		creatureManager.init(player)
		creatureInstance.animation.play("SPAWN")

		await get_tree().create_timer(0.2).timeout
