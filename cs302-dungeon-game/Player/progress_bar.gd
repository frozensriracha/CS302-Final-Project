extends ProgressBar
@onready var player = get_parent()
var counter = 0


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	counter += counter * delta
	value = player.player_health
	visible = true
	if counter == 100000:
		visible = false
		counter = 0
	
