extends State

@export var zoom_duration: float = 2.0  # Duration for the camera zoom effect
@export var zoom_level: float = 0.5  # Target zoom level for the camera

var zoom_timer: float = 0.0
var original_zoom: Vector2
var target_zoom: Vector2

func enter() -> void:
	super()
	await animations.animation_finished
	animations.play("FALLEN")
	parent.set_collision_layer_value(1,false)
	parent.staff.visible = false
	parent.isDead = true
	original_zoom = parent.camera.zoom
	if original_zoom == Vector2.ZERO:
		original_zoom = Vector2(0.01,0.01)

	target_zoom = Vector2(zoom_level,zoom_level)
	if target_zoom== Vector2.ZERO:
		target_zoom = Vector2(0.01,0.01)
	zoom_timer = 0.0
	
	parent.itemHUDPlaceholder.visible = false
	parent.playerHUD.visible = false
	parent.playerCurrencyHUD.visible = false
	parent.MagicEssenceCurrency = 0
	PlayerGlobal.playerMagicEssence = 0


func exit() -> void:
	pass

func update(delta: float) -> void:
	zoom_timer += delta
	var camera = parent.camera
	if zoom_timer <= zoom_duration:
		var t = zoom_timer / zoom_duration
		var value = original_zoom.slerp(target_zoom,t)
		if value != Vector2.ZERO:
			camera.zoom = value
	else:
		get_tree().change_scene_to_file("res://Scene/Home/Home.tscn")

func physics_update(delta: float) -> void:
	pass

func process_input(event)->void:
	pass

