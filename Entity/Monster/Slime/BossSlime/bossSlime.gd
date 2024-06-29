class_name BossSlime
extends Slime

@export var healthbarControl:Control
@export var bossName:String
@onready var boss_name = $RootUI/BossName
@onready var hp_amount = $RootUI/HPAmount

func _ready():
	super()
	healthbarControl.init(self,maxHP,currHealth)
	boss_name.text = bossName
	
func _process(delta):
	hp_amount.text = str(currHealth) + "/" + str(maxHP) 




