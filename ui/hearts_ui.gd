extends Control;

@export var player_stats: Stats;

@onready var empty_hearts: TextureRect = $EmptyHearts
@onready var full_hearts: TextureRect = $FullHearts

const heart_size: Vector2 = Vector2(15, 20);

func _ready() -> void:
	player_stats.health_changed.connect(set_full_hearts);
	set_empty_hearts(player_stats.max_health);
	set_full_hearts(player_stats.health);
	
func hearts_changed() -> void:
	pass;

func set_empty_hearts(value: int) -> void:
	empty_hearts.size.x = value * heart_size.x;

func set_full_hearts(value: int) -> void:
	full_hearts.size.x = value * heart_size.x;
