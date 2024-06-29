extends Potion

@export var manaPoints:float = 100

func execute(master:Entity):
	master.currMana += manaPoints
