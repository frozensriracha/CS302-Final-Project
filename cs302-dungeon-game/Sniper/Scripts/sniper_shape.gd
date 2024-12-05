extends ColorRect
@onready var sniper = get_parent()
@onready var player = $"../../Player"
var direction
var Angle


#this function makes sure that the laser sight always points at the character
func _physics_process(delta):
	direction = player.position - sniper.position
	Angle = direction.angle()
	rotation = Angle
