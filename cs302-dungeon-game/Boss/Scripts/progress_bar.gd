extends ProgressBar

@onready var boss = get_parent()

func _physics_process(delta):
	value = boss.health
