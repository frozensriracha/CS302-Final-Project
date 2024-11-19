extends Node2D

@onready var main = get_tree().get_root().get_node("main")
@onready var projectile = load("res://Bullet/player_bullet1.tscn")


func _physics_process(delta):
	rotation_degrees += 50 * delta


func _ready():
	shoot()

func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.spawnPos = global_position
	instance.spawnRot = global_rotation
	instance.zdex = z_index - 1
	main.add_child.call_deferred(instance)


func _on_cooldown_timeout():
	shoot()
