extends ProgressBar
@onready var sniper = get_parent()

#make progress bar always equal to sniper's health
func _physics_process(delta):
	value = sniper.health
