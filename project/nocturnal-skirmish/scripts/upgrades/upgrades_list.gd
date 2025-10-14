extends Node
class_name UpgradesList

const ICON_PATH = "res://assets/sprites/"

var upgrades = {
	"speed_boost": {
		"icon": "%s/speed_boost_icon.png" % [ICON_PATH],
		"display_name": "Speed Boost",
		"upgrade_info": {
			"is_stackable": true,
			"max_level": 3
		},
		"levels": {
			1: {"description": "Raises movement speed by 5% (stackable)"},
			2: {"description": "Raises movement speed by 10% (stackable)"},
			3: {"description": "Raises movement speed by 15% (stackable)"}
		},
		"class": TemplateSpeedBoost
	},
	
	"damage_multiplier": {
		"icon": "%s/damage_multiplier_icon.png" % [ICON_PATH],
		"display_name": "Damage Multiplier",
		"upgrade_info": {
			"is_stackable": false,
			"max_level": 4
		},
		"levels": {
			1: {"description": "Gain 1.15x Damage Multiplier"},
			2: {"description": "Gain 1.25x Damage Multiplier"},
			3: {"description": "Gain 1.5x Damage Multiplier"},
			4: {"description": "Gain 2x Damage Multiplier"}
		},
		"class": TemplateDamageMultiplier
	},
	
	"shield_generator": {
		"icon": "%s/shield_generator_icon.png" % [ICON_PATH],
		"display_name": "Shield Generator",
		"upgrade_info": {
			"is_stackable": false,
			"max_level": 2
		},
		"levels": {
			1: {"description": "Gain a 50 HP shield every 30 seconds"},
			2: {"description": "Gain a 75 HP shield every 20 seconds"}
		},
		"class": TemplateDamageMultiplier
	},
	
	"life_leech": {
		"icon": "%s/life_leech_icon.png" % [ICON_PATH],
		"display_name": "Life Leech",
		"upgrade_info": {
			"is_stackable": true,
			"max_level": 3
		},
		"levels": {
			1: {"description": "Recover 2% of damage dealt as health"},
			2: {"description": "Recover 4% of damage dealt as health"},
			3: {"description": "Recover 6% of damage dealt as health"}
		},
		"class": TemplateDamageMultiplier
	},
	
	"aoe_blast": {
		"icon": "%s/aoe_blast_icon.png" % [ICON_PATH],
		"display_name": "AOE Blast",
		"upgrade_info": {
			"is_stackable": false,
			"max_level": 3
		},
		"levels": {
			1: {"description": "On kill, deal small AOE damage around enemy"},
			2: {"description": "AOE radius increased"},
			3: {"description": "AOE damage doubled"}
		},
		"class": TemplateDamageMultiplier
	}
}
