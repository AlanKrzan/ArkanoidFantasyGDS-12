extends Node2D
#warning-ignore-all:unused_variable
#warning-ignore-all:return_value_discarded
func _ready():
    pass # Replace with function body.


func _on_Exit_pressed():
    get_tree().quit()


func _on_PlayButton_pressed():
    get_tree().change_scene("res://Level1.tscn")
