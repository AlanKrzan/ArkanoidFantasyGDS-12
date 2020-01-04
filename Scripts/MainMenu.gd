extends Node2D
#warning-ignore-all:unused_variable
#warning-ignore-all:return_value_discarded
func _ready():
    Global.score=0
    Global.life=3
    $Menu/CenterRow/Buttons/PlayButton.grab_focus()
    $Menu/CenterRow/Buttons/PlayButton.start("Play","res://Level1.tscn")
    $Menu/CenterRow/Buttons/Exit.start("Exit","Exit")
    $Menu/CenterRow/Buttons/HighscoreButton.start("Highscores","res://HighScores.tscn")


func _on_Exit_pressed():
    get_tree().quit()


func _on_PlayButton_pressed():
    get_tree().change_scene("res://Level1.tscn")




func _on_HighscoreButton_pressed():
    get_tree().change_scene("res://HighScores.tscn")
