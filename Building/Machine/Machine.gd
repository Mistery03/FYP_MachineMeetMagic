class_name Machine
extends Node

@export var isThereFuel:bool

var machine:Machine 
var next:Machine = null
var player:Player


var batteryList = []
var machineConnection = {}
var batteryConnection = {}




func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	print("test")


