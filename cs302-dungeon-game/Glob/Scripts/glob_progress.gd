extends ProgressBar
@onready var glob = get_parent()

#Let progress bar be equal to glob's health
func _physics_process(delta):
	value = glob.health
