extends TextureProgressBar

var player: Player
signal increaseHP
# Called when the node enters the scene tree for the first time.
func _ready():
	#value = player.currHealth
	pass
	#update() # Replace with function body.

func update(player: Player):
	value = player.currHealth
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func increaseHealth():
	
