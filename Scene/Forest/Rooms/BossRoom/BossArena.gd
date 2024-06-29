extends Room

@export var bossInstance:MobData

@onready var boss_spawn_point = $BossSpawnPoint
@onready var trigger_event = $TriggerEvent
@onready var world_camera = $WorldCamera
@onready var gate_keeper = $GateKeeper

func _ready():
	player.localLevel = self
	levelName = roomName

func spawnBoss():
	var boss = bossInstance.mobInstance.instantiate()
	boss.global_position = boss_spawn_point.global_position
	creatureManager.add_child(boss)
	creatureManager.setBoss(boss)
	creatureManager.init(player)


func _on_trigger_event_body_entered(body):
	if body is Player:
		gate_keeper.visible = true
		gate_keeper.set_collision_layer_value(6,true)
		world_camera.startDramaticBossEntrance(body)
		await get_tree().create_timer(1.5).timeout
		spawnBoss()
		await get_tree().create_timer(0.2).timeout
		trigger_event.queue_free()



