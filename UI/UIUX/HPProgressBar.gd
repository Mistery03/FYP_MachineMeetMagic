extends TextureProgressBar

var parent: Entity
signal increaseHP
var maxHP:float
# Called when the node enters the scene tree for the first time.

	#update() # Replace with function body.
func init(parent: Entity,maxHP:float, currHp:float):
	self.parent = parent
	self.maxHP = maxHP
	max_value = maxHP
	value = currHp
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	value = parent.currHealth
	value = clamp(value,0,maxHP)
	


