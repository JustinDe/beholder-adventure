extends RefCounted
class_name EnemyTypes

const BASIC_SLIME := "basic_slime"
const ARMORED_BEETLE := "armored_beetle"
const FLYING_WISP := "flying_wisp"
const SPIKY_URCHIN := "spiky_urchin"

const DATA := {
	BASIC_SLIME: {
		"display_name": "Basic Slime",
		"max_hp": 1,
		"score": 100,
		"moves": false,
		"radius": 26.0,
		"body_color": Color(0.20, 0.78, 0.46, 1.0)
	},
	ARMORED_BEETLE: {
		"display_name": "Armored Beetle",
		"max_hp": 3,
		"score": 175,
		"moves": false,
		"radius": 30.0,
		"body_color": Color(0.48, 0.52, 0.58, 1.0)
	},
	FLYING_WISP: {
		"display_name": "Flying Wisp",
		"max_hp": 1,
		"score": 150,
		"moves": true,
		"radius": 23.0,
		"body_color": Color(0.36, 0.82, 1.00, 1.0)
	},
	SPIKY_URCHIN: {
		"display_name": "Spiky Urchin",
		"max_hp": 2,
		"score": 225,
		"moves": false,
		"radius": 28.0,
		"body_color": Color(0.90, 0.36, 0.28, 1.0)
	}
}


static func get_data(enemy_type: String) -> Dictionary:
	return DATA.get(enemy_type, DATA[BASIC_SLIME]).duplicate(true)
