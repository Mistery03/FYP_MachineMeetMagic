class_name CreatureManager
extends Node

@export var player:Player
@export var localLevel:Node2D

@export var separationWeight: float = 1.0  # Adjust the influence of separation
@export var separationDistance: float = 100.0  # Maximum distance for separation effect
# Called when the node enters the scene tree for the first time.

var bossSlime
func _ready():
	for entity in get_children():
		entity.player = player
		entity.localLevel = localLevel
		
func init(player):
	for entity in get_children():
		entity.player = player
		entity.localLevel = localLevel
		if entity is Slime:
			entity.bossDied = bossSlime.bossDied
		
func setBoss(bossSlime:BossSlime):
	self.bossSlime = bossSlime

func getCreatureList():
	return get_children()
	
func _compute_separation(entity, entities):
	var sum_repel = Vector2.ZERO
	var count = 0

	for other in entities:
		if entity != other:
			var repel_velocity = entity.global_position - other.global_position
			var dist = repel_velocity.length()

			if dist < separationDistance:
				var weight = 1.0 / (dist * dist + 1.0)
				var repel_direction = repel_velocity.normalized()
				sum_repel += weight * repel_direction
				count += 1

	if count > 0:
		sum_repel /= count

	return sum_repel


