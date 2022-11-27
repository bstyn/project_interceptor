extends KinematicBody2D

var health = 2
export (int) var speed = 80
var one_drop_chance_percent = 2
var velocity = Vector2(0, 5)

func _ready():
	shoot()
	pass 

func _physics_process(_delta: float) -> void:
	velocity.x += 1
	velocity = move_and_slide(velocity.normalized() * speed, Vector2.DOWN)

func _on_Area2D_area_entered(area):
	if area.name == "player_laser_bullet_area":
		area.get_parent().queue_free()
		health -= 1
		if health == 0:
			Global.Score += 1
			generate_drop()
			self.queue_free()
		
func shoot():
	var bullet_spawn_time = randi() % 5 + 1
	yield(get_tree().create_timer(bullet_spawn_time), "timeout")
	var laser = preload("res://src/nodes/Enemy_laser_bullet.tscn")
	var bullet = laser.instance()
	bullet.position = Vector2(position.x, position.y)
	get_parent().call_deferred("add_child", bullet)
	shoot()

func generate_drop():
	var drop_spawn_chance_range = randi() % 100 + 1
	var drop_node = preload("res://src/nodes/Drop.tscn")
	var drop = drop_node.instance()
	drop.position = Vector2(position.x, position.y)
	if (drop_spawn_chance_range <= one_drop_chance_percent * 1):
		drop.get_node("Blue").show()
	elif (drop_spawn_chance_range <= one_drop_chance_percent * 2):
		drop.get_node("Green").show()
	elif (drop_spawn_chance_range <= one_drop_chance_percent * 3):
		drop.get_node("Orange").show()
	elif (drop_spawn_chance_range <= one_drop_chance_percent * 4):
		drop.get_node("Pink").show()
	elif (drop_spawn_chance_range <= one_drop_chance_percent * 5):
		drop.get_node("Red").show()
	elif (drop_spawn_chance_range <= one_drop_chance_percent * 6):
		drop.get_node("White").show()
	get_parent().call_deferred("add_child", drop)
