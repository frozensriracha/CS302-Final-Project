extends CollisionShape2D


# Called when the node enters the scene tree for the first time.
@onready var player = get_parent()
var weapon_direction

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	weapon_direction = (get_global_mouse_position() - global_position)
	rotation = weapon_direction.angle()
