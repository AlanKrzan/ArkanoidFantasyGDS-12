extends Node2D
#warning-ignore-all:unused_variable
#warning-ignore-all:return_value_discarded
func _ready():
    Global.score=0
    Global.life=3
    $Menu/CenterRow/Buttons/Level1.grab_focus()
    $Menu/CenterRow/Buttons/Level1.start("Level 1","res://Level1.tscn")
    $Menu/CenterRow/Buttons/Level2.start("Level 2","")
    $Menu/CenterRow/Buttons/Level3.start("Level 3","")
    $Menu/CenterRow/Buttons/Level4.start("Level 4","")
    $Menu/CenterRow/Buttons/Exit.start("Exit","Exit")


func _on_Exit_pressed():
    get_tree().change_scene("res://MainMenu.tscn")



func _on_Level1_pressed():
    get_tree().change_scene("res://Level1.tscn")


func _on_Level2_pressed():
    get_tree().change_scene("res://Level2.tscn")


func _on_Level3_pressed():
    get_tree().change_scene("res://Level3.tscn")


func _on_Level4_pressed():
    get_tree().change_scene("res://Level4.tscn")
