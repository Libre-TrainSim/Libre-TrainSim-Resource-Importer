tool
extends EditorPlugin

var jConfig = preload("res://addons/jean28518.jTools/jConfig.gd")

func _enter_tree():
	add_autoload_singleton("jConfig", "res://addons/jean28518.jTools/jConfig.gd")
	if jConfig.enable_jEssentials:
		add_autoload_singleton("jEssentials", "res://addons/jean28518.jTools/jEssentials/jEssentials.gd")
	if jConfig.enable_jSaveManager:
		add_autoload_singleton("jSaveManager", "res://addons/jean28518.jTools/jSaveManager/jSaveManager.gd")
	
	
func _exit_tree():
	remove_autoload_singleton("jConfig")
	if jConfig.enable_jEssentials:
		remove_autoload_singleton("jEssentials")
	if jConfig.enable_jSaveManager:
		remove_autoload_singleton("jSaveManager")
	
func _ready():
	pass
