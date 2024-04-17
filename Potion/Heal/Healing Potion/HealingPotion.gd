extends Potion

@export var healingPoints:float = 100

func execute():
	master.currHealth += healingPoints
	print(master.currHealth)
