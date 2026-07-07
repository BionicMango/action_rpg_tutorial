extends CharacterBody2D

# how fast bat moves
const SPEED: float = 30.0; # set in inspector

# how far can bat enemies see
@export var sight_range: float = 64.0; # set in inspector

# accessing child nodes
@onready var sprite_2d: Sprite2D = $Sprite2D;
@onready var animation_tree: AnimationTree = $AnimationTree;
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback");
@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _physics_process(_delta: float) -> void:
	# switching between different states
	var state = playback.get_current_node();
	match state:
		"Idle": pass;
		"Chase": chase_state();

# access the player node
func get_player() -> Player:
	return get_tree().get_first_node_in_group("player");

# check if bat can "see" the player
func is_player_in_range() -> bool:
	var result: bool = false;
	var player: Player = get_player();
	
	# check that player has not "died" etc. & return whether distance to player < range
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position);
		if distance_to_player <= sight_range:
			result = true;
	
	return result;

# what bat enemy will do if player is within range
func chase_state():
	var player = get_player();
	if player is Player:
		velocity = global_position.direction_to(player.global_position) * SPEED;
		sprite_2d.scale.x = sign(velocity.x)
	else:
		velocity = Vector2.ZERO;
	move_and_slide();

func can_see_player() -> bool:
	if not is_player_in_range():
		return false;
	
	var player: Player = get_player();
	ray_cast_2d.target_position = player.global_position - global_position;
	var has_los_to_player = not ray_cast_2d.is_colliding(); # los = line of sight
	return has_los_to_player;
