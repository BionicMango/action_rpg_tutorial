extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree;

const speed: float = 100.0;
var input_vector: Vector2 = Vector2.ZERO;

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO;

	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	velocity = input_vector * speed;
	
	if input_vector != Vector2.ZERO:
		update_blend_positions(input_vector);
		
	move_and_slide();

func update_blend_positions(direction_vector: Vector2) -> void:
	animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position", direction_vector);
	animation_tree.set("parameters/StateMachine/MoveState/StandState/blend_position", direction_vector);
