extends Potion

@export var healingPoints:float = 100

func execute(master:Entity):
	healingPoints = int(master.maxHP * 0.5)
	master.currHealth += healingPoints

