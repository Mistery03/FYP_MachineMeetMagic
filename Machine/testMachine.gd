extends Machine

@onready var ray_cast_3d = $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	ray = ray_cast_3d
	pos = self.position 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	super(delta)
