extends Camera2D

@onready var boss_spawn_point = $"../BossSpawnPoint"

var originalPos
# Called when the node enters the scene tree for the first time.
func _ready():
	originalPos = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func startDramaticBossEntrance(player:Player):
	var tween = get_tree().create_tween()
	player.camera.enabled = false
	player.HUDHolder.visible = false
	player.isInCutscene = true
	player.animation.play("WALKBACKWARD")
	enabled = true
	tween.tween_property(self,"global_position",boss_spawn_point.global_position,2.5)
	tween.set_ease(Tween.EASE_IN_OUT)
	await  get_tree().create_timer(4).timeout
	player.camera.enabled = true
	player.smooth_zoom(3.5)
	player.HUDHolder.visible = true
	enabled = false
	player.isInCutscene = false
	player.animation.play("IDLE")
	
