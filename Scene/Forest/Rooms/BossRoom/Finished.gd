extends Area2D

@onready var fade_out = $"../CanvasLayer/FadeOut"
@onready var label = $"../CanvasLayer/Label"
@onready var brew_btn = $"../CanvasLayer/brewBTN"

var isEntered:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isEntered:
		var tween = get_tree().create_tween()
		tween.tween_property(fade_out,"modulate:a",1,2)
		await tween.finished
		label.visible = true
		brew_btn.visible = true

func _on_body_entered(body):
	if body is Player:
		isEntered = true
		

func _on_brew_btn_pressed():
	get_tree().change_scene_to_file("res://Scene/Home/Home.tscn")
