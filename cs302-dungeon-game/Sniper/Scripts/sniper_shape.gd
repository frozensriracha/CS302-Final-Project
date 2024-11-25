extends ColorRect
@onready var sniper = get_parent()
@onready var player = $"../../Player"
var direction
var target_angle

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	direction = player.position - sniper.position  # Calculate the direction vector
	target_angle = direction.angle()  # Get the angle towards the player
	rotation = target_angle
