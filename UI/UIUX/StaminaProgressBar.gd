extends TextureProgressBar

var player: Player
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.2).timeout
	max_value = player.playerData.MaxStamina
	value = player.playerData.MaxStamina

func init(player: Player):
	self.player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player.currStamina = clamp(player.currStamina,0,player.playerData.MaxStamina)
	value = player.currStamina
	#print("Player Stamina: ", value)
