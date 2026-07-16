extends CharacterBody2D

# how fast bat moves
const SPEED: float = 30.0
const FRICTION: float = 500.0

# how far can bat enemies see
@export var max_range: float = 64.0 # set in inspector
@export var min_range: float = 10.0 # set in inspector

# enemy stats (resource file)
@export var stats: Stats

# effects
const FX_HIT = preload("uid://dmqbw5bp25rnd")

const FX_DEATH = preload("uid://crv5q4amfh6dr")

# accessing child nodes
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var bat_center: Marker2D = $Center
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var navigation_marker: Marker2D = $NavigationMarker
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationMarker/NavigationAgent2D

func _ready() -> void:
	# ensure that every enemy has its OWN stats resource (not shared)
	stats = stats.duplicate()
	
	# connecting signals
	hurtbox.hurt.connect(take_hit.call_deferred) # when hurt
	stats.no_health.connect(die) # defeated

func _physics_process(delta: float) -> void:
	# switching between different states
	var state = playback.get_current_node()
	match state:
		"IdleState": pass
		"ChaseState": chase_state()
		"HitState": hit_state(delta)

# what happens when bat is hit by player
func take_hit(other_hitbox: Hitbox) -> void:
	# hit effect
	var hit_effect_instance = FX_HIT.instantiate()
	get_tree().current_scene.add_child(hit_effect_instance)
	hit_effect_instance.global_position = bat_center.global_position
	
	# hit sound effect
	
	
	# lose damage
	stats.health -= other_hitbox.damage
	
	# knockback effect
	velocity = other_hitbox.knockback_dir * other_hitbox.knockback_amount
	playback.start("HitState")
	
	# debugging
	print("Changed to the hit state")

# access the player node
func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")

# check if bat can "see" the player
func is_player_in_range() -> bool:
	var result: bool = false
	var player: Player = get_player()
	
	# check that player has not "died" etc. & return whether distance to player < range
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < max_range and distance_to_player > min_range:
			result = true
	
	return result

# what bat enemy will do if player is within range
func chase_state():
	var player = get_player()
	if player is Player:
		navigation_agent_2d.target_position = player.global_position
		var next_point = navigation_agent_2d.get_next_path_position()
		velocity = global_position.direction_to(next_point - navigation_marker.position) * SPEED
		sprite_2d.scale.x = sign(velocity.x)
	else:
		velocity = Vector2.ZERO
	move_and_slide()

# what bat will do if it is hit (i.e. knockback & damage)
func hit_state(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()

# checks if player is in line of sight (not behind other objects like trees)
func can_see_player() -> bool:
	if not is_player_in_range():
		return false
	
	# update raycast target position (force update on first frame)
	var player: Player = get_player()
	ray_cast_2d.target_position = player.global_position - global_position
	ray_cast_2d.force_raycast_update()
	var has_los_to_player = not ray_cast_2d.is_colliding() # los = line of sight
	return has_los_to_player

# when health is zero
func die() -> void:
	var death_effect_instance = FX_DEATH.instantiate()
	get_tree().current_scene.add_child(death_effect_instance)
	death_effect_instance.global_position = bat_center.global_position
	queue_free()
