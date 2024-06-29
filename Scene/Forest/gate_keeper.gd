extends StaticBody2D

@export var creatureManager:CreatureManager
@export var localLevel:Node2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	if localLevel.levelName == "BossRoom":
		set_collision_layer_value(6,false)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if localLevel.levelName != "BossRoom":
		await get_tree().create_timer(3).timeout
		if creatureManager.getCreatureList().size() <= 0:
			queue_free()
	else:
		for creature in creatureManager.get_children():
			if creature is BossSlime:
				if !creature.is_inside_tree():
					queue_free()
