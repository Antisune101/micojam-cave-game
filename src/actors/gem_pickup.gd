class_name Gem extends Node2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	Globals.gem_picked_up.emit()
	queue_free()
