extends CanvasLayer

#funkcja wypisująca ilość pozostałych żyć
func update_life(lives):
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
    
    