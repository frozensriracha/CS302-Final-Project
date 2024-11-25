extends ProgressBar
@onready var sniper = get_parent()

func _physics_process(delta):
	value = sniper.health
