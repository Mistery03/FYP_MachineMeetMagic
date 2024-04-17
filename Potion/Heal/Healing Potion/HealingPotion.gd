extends Potion

@export var healingPoints:float = 100

func execute():
	master.currHealth += healingPoints
	master.OnHealthIncrease.emit()
	print(master.currHealth)
