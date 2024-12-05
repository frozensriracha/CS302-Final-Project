extends ProgressBar
@onready var boss = get_parent()

#progress bar is equal to health of boss
func _physics_process(delta):
	value = boss.health
