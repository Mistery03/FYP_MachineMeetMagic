extends Potion

@export var manaPoints:float = 100

func execute(master:Entity):
	manaPoints = master.maxMana * 0.35
	master.currMana += manaPoints
