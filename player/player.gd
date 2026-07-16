class_name Player extends CharacterBody2D

# child Nodes
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $Node2D/HurtAudioStreamPlayer

# player stats
@export var stats: Stats
@export var speed: float = 100.0
@export var roll_speed: float = 125.0

# movement input from wasd/direction keys & controller
var input_vector: Vector2 = Vector2.ZERO
var last_input_vector: Vector2 = Vector2.DOWN # save previous direction

func _ready() -> void:
	# connecting signals
	hurtbox.hurt.connect(take_hit.call_deferred) # hurt/damage taken
	stats.no_health.connect(die)

func _physics_process(delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"MoveState": move_state(delta)
		"AttackState": pass
		"RollState": roll_state(delta)

func die() -> void:
	"""Game over. First player is hidden.
	Then removed from group "player" so it is no longer recognized.
	Then process is disabled so it no longer updates (i.e. paused)."""
	hide()
	remove_from_group("player")
	process_mode = Node.PROCESS_MODE_DISABLED
	
func take_hit(other_hitbox: Hitbox) -> void:
	# hurt sound effect
	audio_stream_player.play();
	
	stats.health -= other_hitbox.damage
	blink_animation_player.play("blink")

func move_state(_delta: float) -> void:
	# Only update if NOT in roll or attack mode
	velocity = Vector2.ZERO

	# Converts the (movement) keys that are currently being pressed into a vector
	# input_vector defaults to zero when not pressed
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# update animation direction (e.g. run_up, stand_right)
	if input_vector != Vector2.ZERO:
		last_input_vector = input_vector # "remember" the direction
		update_blend_positions(input_vector)

	if Input.is_action_just_pressed("attack"):
		playback.travel("AttackState")

	if Input.is_action_just_pressed("roll"):
		playback.travel("RollState")

	velocity = input_vector * speed
	move_and_slide() # move (based on velocity vector)

func roll_state(_delta: float) -> void:
	velocity = last_input_vector.normalized() * roll_speed
	move_and_slide()

func update_blend_positions(direction_vector: Vector2) -> void:
	"""Update the blend positions for each respective animation blend states:
		- Run state
		- Stand state
		- Attack state
		- Roll state"""
	animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/MoveState/StandState/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/AttackState/blend_position", direction_vector)
	animation_tree.set("parameters/StateMachine/RollState/blend_position", direction_vector)
