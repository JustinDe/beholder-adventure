extends Resource
class_name ActionCard

enum EffectType {
	POWER_SHOT,
	MULTI_BALL,
	PIERCING,
	TIME_WARP,
	EXPLOSIVE
}

@export var id: String = ""
@export var display_name: String = ""
@export var bp_cost: int = 1
@export var effect_type: EffectType = EffectType.POWER_SHOT
@export var damage_multiplier: float = 1.0
@export var bounce_modifier: int = 0
@export var ball_count: int = 1
@export var spread_degrees: float = 0.0
@export var pierce_count: int = 0
@export var slow_motion_seconds: float = 0.0
@export var explosion_radius: float = 0.0


static func create_defaults() -> Array:
	return [
		_create("power_shot", "Power Shot", 1, EffectType.POWER_SHOT, 1.5, -1, 1, 0.0, 0, 0.0, 0.0),
		_create("multi_ball", "Multi-Ball", 3, EffectType.MULTI_BALL, 1.0, 0, 3, 12.0, 0, 0.0, 0.0),
		_create("piercing", "Piercing", 2, EffectType.PIERCING, 1.0, 0, 1, 0.0, 1, 0.0, 0.0),
		_create("time_warp", "Time Warp", 2, EffectType.TIME_WARP, 1.0, 0, 1, 0.0, 0, 3.0, 0.0),
		_create("explosive", "Explosive", 3, EffectType.EXPLOSIVE, 1.0, 0, 1, 0.0, 0, 0.0, 100.0),
	]


static func _create(
	card_id: String,
	card_name: String,
	cost: int,
	type: EffectType,
	damage: float,
	bounces: int,
	count: int,
	spread: float,
	pierces: int,
	slow_seconds: float,
	radius: float
):
	var card := new()
	card.id = card_id
	card.display_name = card_name
	card.bp_cost = cost
	card.effect_type = type
	card.damage_multiplier = damage
	card.bounce_modifier = bounces
	card.ball_count = count
	card.spread_degrees = spread
	card.pierce_count = pierces
	card.slow_motion_seconds = slow_seconds
	card.explosion_radius = radius
	return card
