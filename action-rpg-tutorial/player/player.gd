extends CharacterBody2D

const speed: float = 100.0;

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO;

	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	velocity = input_vector * speed;
	
	move_and_slide();
