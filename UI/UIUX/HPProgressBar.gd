extends TextureProgressBar

var player: Player
signal increaseHP
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.2).timeout
	value = player.playerData.MaxHealth
	
	pass
	#update() # Replace with function body.
func init(player: Player):
	self.player = player
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = player.currHealth
	print("Player HP: ", value)
	pass

