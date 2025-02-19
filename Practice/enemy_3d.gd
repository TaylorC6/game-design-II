extends CharacterBody3D

@onready var atk_area = $AttackArea
@onready var dmg_area = $DamageArea
@onready var nav_agent = $NavigationAgent3D
@onready var animator: AnimationPlayer = $AuxScene/AnimationPlayer


var SPEED = 3.0
var WALKSPEED = 3.0
var RUNSPEED = 4.5
var ACCEL = 20
var ATTACK = 10
var KNOCKBACK = 16.0


func take_damage(_dmg):
	self.queue_free()

func _ready() -> void:
	nav_agent.target_position = global_position

func _physics_process(delta: float) -> void:
	for player in get_tree().get_nodes_in_group("Player"):
		if $AttackRange.overlaps_body(player):
			nav_agent.target_position = player.global_position
			SPEED = RUNSPEED
		else:
			SPEED = WALKSPEED
		#else:
			#nav_agent.target_position = self.global_position + \
			#randi_range(Vector3(0, 0, 0), Vector3(25, 25, 25))
		if atk_area.overlaps_body(player):
			animator.play("ZombieAttack0")
			player.take_damage(ATTACK)
			player.inertia = (player.global_position-self.global_position) \
							  .normalized() * KNOCKBACK
	var dir = (nav_agent.target_position-self.global_position)
	dir.y = 0
	if dir.length() > 0.01:
		var rot_angle = atan2(dir.x, dir.z)
		self.rotation.y = lerp_angle(rotation.y, rot_angle, 5 * delta)
	velocity = velocity.lerp(dir.normalized() * SPEED, ACCEL * delta)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if animator.current_animation != "ZombieAttack0":
		if velocity.length() <= 1:
			animator.play("ZombieIdle0")
		elif SPEED == WALKSPEED:
			animator.play("ZombieWalk0")
		elif SPEED == RUNSPEED:
			animator.play("ZombieRunning")
	
	move_and_slide()
