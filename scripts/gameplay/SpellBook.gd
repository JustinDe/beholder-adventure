extends RefCounted
class_name SpellBook

const EYE_FIRE := "eye_fire"
const EYE_STARSTORM := "eye_starstorm"
const EYE_METEOR := "eye_meteor"
const EYE_CURE := "eye_cure"
const EYE_ESUNA := "eye_esuna"
const EYE_LEVITATION := "eye_levitation"
const EYE_WARD := "eye_ward"
const EYE_RERAISE := "eye_reraise"

const SPELLS := {
	EYE_FIRE: {
		"name": "Eye Fire",
		"mp_cost": 30,
		"recast_turns": 3,
		"description": "Deals 20 damage to a target in front of you.",
		"min_stage": 1,
		"max_stage": 99
	},
	EYE_STARSTORM: {
		"name": "Eye Starstorm",
		"mp_cost": 40,
		"recast_turns": 4,
		"description": "Deals 10 damage to all enemies in an area centered 8 squares in front of you.",
		"min_stage": 1,
		"max_stage": 99
	},
	EYE_METEOR: {
		"name": "Eye Meteor",
		"mp_cost": 80,
		"recast_turns": 10,
		"description": "Deals 15 damage to all enemies.",
		"min_stage": 3,
		"max_stage": 3
	},
	EYE_CURE: {
		"name": "Eye Cure",
		"mp_cost": 10,
		"recast_turns": 1,
		"description": "Restores 50 HP.",
		"min_stage": 1,
		"max_stage": 99
	},
	EYE_ESUNA: {
		"name": "Eye Esuna",
		"mp_cost": 20,
		"recast_turns": 3,
		"description": "Removes all detrimental effects except for Doom.",
		"min_stage": 2,
		"max_stage": 3
	},
	EYE_LEVITATION: {
		"name": "Eye Levitation",
		"mp_cost": 20,
		"recast_turns": 3,
		"effect_turns": 1,
		"description": "Grants invulnerability to floor effects.",
		"min_stage": 2,
		"max_stage": 3
	},
	EYE_WARD: {
		"name": "Eye Ward",
		"mp_cost": 30,
		"recast_turns": 3,
		"effect_turns": 1,
		"description": "Erects a protective barrier around you.",
		"min_stage": 1,
		"max_stage": 99
	},
	EYE_RERAISE: {
		"name": "Eye Reraise",
		"mp_cost": 50,
		"recast_turns": 99,
		"description": "Grants automatic revival upon KO for the duration of the effect.",
		"min_stage": 1,
		"max_stage": 99
	}
}


static func all_spell_ids() -> Array:
	return [
		EYE_FIRE,
		EYE_STARSTORM,
		EYE_METEOR,
		EYE_CURE,
		EYE_ESUNA,
		EYE_LEVITATION,
		EYE_WARD,
		EYE_RERAISE
	]


static func get_spell(spell_id: String) -> Dictionary:
	return SPELLS.get(spell_id, {}).duplicate(true)
