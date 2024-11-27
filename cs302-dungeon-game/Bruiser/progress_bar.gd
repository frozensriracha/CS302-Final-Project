extends ProgressBar
@onready var bruiser = get_parent()

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	value = bruiser.health
