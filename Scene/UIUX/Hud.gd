extends CanvasLayer

@onready var hp_progress_bar = %HPProgressBar
@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	hp_progress_bar.update(player)
	print(self.player)
	pass
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
