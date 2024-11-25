extends ProgressBar
@onready var glob = get_parent()

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	value = glob.health
