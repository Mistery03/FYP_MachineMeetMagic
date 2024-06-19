extends Node2D

@onready var level_selection = $CanvasLayer/LevelSelection
@onready var radial_loading = $RadialLoading
@onready var indicator_pop_up = $IndicatorPopUp


var player:Player
var hold_time = 0.0
var is_holding = false
var required_hold_time = 3.0
var decrease_speed = 1.0  # Speed at which the progress bar decreases when not holding

func _ready():
	var key_name = OS.get_keycode_string(InputMap.action_get_events("INTERACT")[0]["physical_keycode"])
	indicator_pop_up.text = "Hold ["+ key_name+ "] to teleport"
	indicator_pop_up.position = Vector2(-40,-52)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_holding:
		hold_time += delta
		if hold_time >= required_hold_time:
			on_hold_complete()
			is_holding = false
	else:
		hold_time -= decrease_speed * delta
		if hold_time < 0.0:
			hold_time = 0
			radial_loading.visible = false
			if player:
				indicator_pop_up.visible = true
	
	hold_time = clamp(hold_time,0,3)
	if radial_loading.value <= 3:
		radial_loading.value = hold_time
	


func _on_area_2d_body_entered(body):
	if body is Player:
		indicator_pop_up.visible = true
		player = body
		

func _on_area_2d_body_exited(body):
	if body is Player:
		indicator_pop_up.visible = false
		level_selection.visible = false
		player.itemHUDPlaceholder.visible = true
		player.playerHUD.visible = true
		player = null
		

func _input(event):
	if event is InputEventKey:
		if event.is_action("INTERACT"):
			if player:
				is_holding = true
				radial_loading.visible = true
				indicator_pop_up.visible = false
					
	
		if event.is_action_released("INTERACT"):
			if player:
				is_holding = false
					#ehold_time = 0.0

func on_hold_complete():
	if player:
		player.itemHUDPlaceholder.visible = false
		player.playerHUD.visible = false
		level_selection.visible = true
		player.isPressable = false
		hold_time = 0
		radial_loading.value = hold_time
		radial_loading.visible = false
		



