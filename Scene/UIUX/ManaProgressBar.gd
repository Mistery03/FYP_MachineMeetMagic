extends TextureProgressBar

var player: Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update(player: Player):
	value = player.currMana
	self.player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
