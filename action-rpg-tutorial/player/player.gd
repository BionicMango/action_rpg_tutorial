extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree;

const speed: float = 100.0;
var input_vector: Vector2 = Vector2.ZERO;

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO;

	input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	velocity = input_vector * speed;
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/StateMachine/MoveState/RunState/blend_position", input_vector);
		animation_tree.set("parameters/StateMachine/MoveState/StandState/blend_position", input_vector);
		
	move_and_slide();
