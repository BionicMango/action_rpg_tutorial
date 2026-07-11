class_name Stats extends Resource;

@export var health: int = 1 :
	set(value):
		var previous_health = health;
		health = value;
		if previous_health != health: health_changed.emit(health) # not dead
		if health <= 0: no_health.emit(); # dead

@export var max_health: int = 1;

signal health_changed(new_health);
signal no_health();
