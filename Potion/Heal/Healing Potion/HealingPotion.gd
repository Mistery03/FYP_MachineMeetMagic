extends Potion

@export var healingPoints:float = 100

func execute(master:Entity):
	master.currHealth += healingPoints

