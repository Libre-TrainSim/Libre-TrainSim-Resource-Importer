tool
extends PopupPanel

signal resources_imported()

var editor_directory_path


func update_ui():
	$MainView/EditorPath/LineEdit.text = editor_directory_path



func get_all_resources_from_folder(resources_path : String) -> Array:
	if not resources_path.ends_with("/"):
		resources_path += "/"
	var found_resources = []
	var resource_subfolders = jEssentials.get_subfolders_of(editor_directory_path + "Resources")
	for resource_subfolder in resource_subfolders:


		found_resources.append_array(jEssentials.crawl_directory_for(resources_path + resource_subfolder + "/Materials", "tres"))
		found_resources.append_array(jEssentials.crawl_directory_for(resources_path + resource_subfolder + "/Objects", "obj"))
		print(jEssentials.crawl_directory_for(resources_path + resource_subfolder + "/Objects", "obj"))
		print(found_resources)
		found_resources.append_array(jEssentials.crawl_directory_for(resources_path + resource_subfolder + "/RailTypes", "tscn"))

		found_resources.append_array(jEssentials.crawl_directory_for(resources_path + resource_subfolder + "/SignalTypes", "tscn"))

		found_resources.append_array(jEssentials.crawl_directory_for(resources_path + resource_subfolder + "/Sounds", "ogg"))

		found_resources.append_array(jEssentials.crawl_directory_for(resources_path + resource_subfolder + "/Textures", "png"))

	print("returning")
	return found_resources


func import_resources():

	$MainView/Label.text = ""

	jEssentials.remove_folder_recursively("res://Resources")
	jEssentials.remove_folder_recursively("res://.import")

	jEssentials.copy_folder_recursively(editor_directory_path + "Resources", "res://Resources")

	emit_signal("resources_imported")

	print("Finished copying files.")

#	jEssentials.call_delayed(0.5, self, "export_pck")

func export_pck():
#	var found_resources = get_all_resources_from_folder("res://Resources")
	var files_to_export = []

	files_to_export.append_array(jEssentials.crawl_directory_for("res://.import/", "stex"))
	files_to_export.append_array(jEssentials.crawl_directory_for("res://.import/", "mesh"))
	files_to_export.append_array(jEssentials.crawl_directory_for("res://.import/", "oggstr"))
	files_to_export.append_array(jEssentials.crawl_directory_for("res://Resources/", "import"))
	files_to_export.append_array(jEssentials.crawl_directory_for("res://Resources/", "tres"))
	files_to_export.append_array(jEssentials.crawl_directory_for("res://Resources/", "tscn"))

	print(files_to_export)

	var pck_path = editor_directory_path + "/.cache/additional_resources.pck"
	var packer = PCKPacker.new()
	packer.pck_start(pck_path)
	for file in files_to_export:
		packer.add_file(file, file)
	packer.flush()

	$MainView/Label.text = "Sucessfully exported Pck. You may restart Libre TrainSIm now."


#	packer.pck_start(pck_path)
#
#	if resource_path.get_extension() == "obj":
#		var mesh = Mesh
#	packer.add_file("res://Resources/" + resource_path, full_path)
#
#	var loaded_resources = get_all_loaded_additional_resources()
#
#	for resource in loaded_resources:
#		if resource == resource_path: continue
#		packer.add_file("res://Resources/" + resource, "res://Resources/" + resource)
#	packer.flush()




#
#func get_all_loaded_additional_resources() -> Array:
#	var found_resources = []
#	var resource_subfolders = Root.get_subfolders_of(editor_directory_path + "Resources")
#	for resource_subfolder in resource_subfolders:
#		var found_files = {"Array" : []}
#
#		Root.crawlDirectory("res://" + "Resources/" + resource_subfolder + "/Materials", found_files, "tres")
#
#		Root.crawlDirectory("res://" + "Resources/" + resource_subfolder + "/Objects", found_files, "obj")
#
#		Root.crawlDirectory("res://" + "Resources/" + resource_subfolder + "/RailTypes", found_files, "tscn")
#
#		Root.crawlDirectory("res://" + "Resources/" + resource_subfolder + "/SignalTypes", found_files, "tscn")
#
#		Root.crawlDirectory("res://" + "Resources/" + resource_subfolder + "/Sounds", found_files, "ogg")
#
#		Root.crawlDirectory("res://" + "Resources/" + resource_subfolder + "/Textures", found_files, "png")
#
#		for file in found_files["Array"]:
#			found_resources.append(file.replace("res://" + "Resources/", ""))
#
#	return found_resources
#
#func get_found_additional_resources() -> Array:
#	return []
#
#func remove_additional_resource() -> void:
#	pass
#
#func update_all_additional_resources() -> void:
#	pass
#
## Input example: Test-Track/Objects/object.obj
#func import_resource(resource_path : String) -> void:
#	var full_path = editor_directory_path + "/Resources/" + resource_path
#
#	var dir = Directory.new()
#	dir.make_dir_recursive(editor_directory_path + "/.cache/")
#	var pck_path = editor_directory_path + "/.cache/additional_resources.pck"
#	var packer = PCKPacker.new()
#	packer.pck_start(pck_path)
#
#	if resource_path.get_extension() == "obj":
#		var mesh = Mesh
#	packer.add_file("res://Resources/" + resource_path, full_path)
#
#	var loaded_resources = get_all_loaded_additional_resources()
#
#	for resource in loaded_resources:
#		if resource == resource_path: continue
#		packer.add_file("res://Resources/" + resource, "res://Resources/" + resource)
#	packer.flush()
#
#	ProjectSettings.load_resource_pack(pck_path)
#	update_lists_ui()
#
#
#
#func _on_ImportAdditionalResource_pressed():
#	if $HBoxContainer/FoundAdditionalResources/ItemList.get_selected_items().size() == 0:
#		return
#	var resource = $HBoxContainer/FoundAdditionalResources/ItemList.get_item_text( $HBoxContainer/FoundAdditionalResources/ItemList.get_selected_items()[0])
#	print(resource)
#	import_resource(resource)

func _ready():
	editor_directory_path = jSaveManager.get_setting("editor_directory_path", OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)+"Libre-TrainSim-Editor/")
	update_ui()


func _process(delta):
	if not visible:
		popup_centered()
		pass



func _on_UpdateEditorPath_pressed():
	var new_path = $MainView/EditorPath/LineEdit.text
	if jEssentials.does_path_exist(new_path):
		editor_directory_path = new_path
		jSaveManager.save_setting("editor_directory_path", new_path)
	else:
		$MainView/EditorPath/LineEdit.text = editor_directory_path
		$MainView/Label.text = "Couldn't find path!"


func _on_ImportResources_pressed():
	import_resources()


func _on_WriteToEditorDirectory_pressed():
	export_pck()


func _on_Quit_pressed():
	get_tree().quit()
