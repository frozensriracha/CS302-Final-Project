extends ProgressBar
@onready var bruiser = get_parent()


#progress bar equals health of bruiser
func _physics_process(delta):
	value = bruiser.health
