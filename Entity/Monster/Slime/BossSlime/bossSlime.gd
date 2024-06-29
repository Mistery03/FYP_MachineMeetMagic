class_name BossSlime
extends Slime

@export var healthbarControl:Control
@export var bossName:String
@onready var boss_name = $RootUI/BossName

func _ready():
	super()
	healthbarControl.init(self,maxHP,currHealth)
	boss_name.text = bossName








