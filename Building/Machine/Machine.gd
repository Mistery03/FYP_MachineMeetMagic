class_name Machine
extends Node

@export var isThereFuel:bool
@export var manaConsumptionPerSecond:float
@export var maxMana:float

var machine:Machine 
var next:Machine = null
var player:Player
var currMana:float
var percentage:float

var isSwitchedOn:bool

@onready var maxPercentage:float = maxMana/maxMana * 100

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("test")


