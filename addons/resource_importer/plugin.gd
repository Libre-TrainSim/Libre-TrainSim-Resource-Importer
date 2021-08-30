tool
extends EditorPlugin


var main_window

func _enter_tree():
	var base_control = get_editor_interface().get_base_control()
	main_window = preload("res://addons/resource_importer/Main-Window.tscn").instance()
	base_control.add_child(main_window)
	main_window.connect("resources_imported", self, "scan_editor_filesystem")
	main_window.popup_centered()


func _exit_tree():
	main_window.free()

func scan_editor_filesystem():
	print("scanning_filesystem..")
	get_editor_interface().get_resource_filesystem().scan()
