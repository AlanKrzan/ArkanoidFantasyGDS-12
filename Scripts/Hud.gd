extends CanvasLayer


signal stop
signal move
signal purge
#funkcja wypisująca ilość pozostałych żyć
func update_life(lives):
    if lives>0:
        $LifeSprite.position.x=37+23*lives
        $LifeSprite.set_region_rect(Rect2(0,0,46*lives,32))
    $LifeLabel.text = str(lives)
    
#funkcja aktualizująca wypisywany wynik
func update_score(score):
    $ScoreLabel.text = str(score)
    
func update_highscore(score):
    if score==0:
        $HighScoreLabel.text="Highest score!!"
    else:
        $HighScoreLabel.text="Highest: "+str(Global.highscore)
    
#funkcja ukrycia wiadomości
func hide_message():
    $MessageLabel.hide()

#funkcja pokazująca wiadomość, bez kontroli czasu
func show_message(message):
    $MessageLabel.text = message
    $MessageLabel.show()
    
func open_pause_menu():
    $Hue.show()
    $PauseMenu.show()
    $PauseMenu/HBoxContainer/VBoxContainer/ResumeButton.grab_focus()
    emit_signal("stop")
    
func close_pause_menu():
    $Hue.hide()
    $PauseMenu.hide()
    emit_signal("move")

func _ready():
    $Hue.hide()
    $PauseMenu.hide()
    $PauseMenu/HBoxContainer/VBoxContainer/ResumeButton.start("Resume","")
    $PauseMenu/HBoxContainer/VBoxContainer/ExitButton.start("Exit to Menu","")
    

func _on_ResumeButton_pressed():
    close_pause_menu()


func _on_ExitButton_pressed():
    emit_signal("purge")
# warning-ignore:return_value_discarded
    get_tree().change_scene("res://MainMenu.tscn")
