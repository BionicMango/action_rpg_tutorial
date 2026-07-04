extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree;
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback");

const speed: float = 100.0;
const roll_speed: float = 125.0;
var input_vector: Vector2 = Vector2.ZERO;
var last_input_vector: Vector2 = Vector2.ZERO;

func _physics_process(delta: float) -> void:
	var state = playback.get_current_node();
	
	match state:
		"MoveState": move_state(delta);
		"AttackState": pass;
		"RollState": roll_state(delta);

func move_state(_delta: float) -> void:
	# Only update if NOT in roll or attack mode
	velocity = Vector2.ZERO;

	# Converts the (movement) keys that are currently being pressed into a vector
	# input_vector defaults to zero when not pressed
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	
	# update animation direction (e.g. run_up, stand_right)
	if input_vector != Vector2.ZERO:
		last_input_vector = input_vector; # "remember" the direction
		update_blend_positions(input_vector);

	if Input.is_action_just_pressed("attack"):
		playback.travel("AttackState");

	if Input.is_action_just_pressed("roll"):
		playback.travel("RollState");

	velocity = input_vector * speed;
	move_and_slide(); # move (based on velocity vector)

func roll_state(_delta: float) -> void:
	velocity = last_input_vector.normalized() * roll_speed;
	move_and_slide();

func update_blend_positions(direction_vector: Vector2) -> void:
	"""Update the blend positions for each respective animation blend states:
		- Run state
		- Stand state
		- Attack state
		- Roll state"""
	animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position", direction_vector);
	animation_tree.set("parameters/StateMachine/MoveState/StandState/blend_position", direction_vector);
	animation_tree.set("parameters/StateMachine/AttackState/blend_position", direction_vector);
	animation_tree.set("parameters/StateMachine/RollState/blend_position", direction_vector);
