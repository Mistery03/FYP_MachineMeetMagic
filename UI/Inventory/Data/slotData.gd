class_name SlotData
extends Resource

const MAXSTACKSIZE:int = 99

@export var item:MaterialData
@export_range(1,MAXSTACKSIZE) var amount:int = 1
