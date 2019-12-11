extends CanvasLayer

#funkcja wypisująca ilość pozostałych żyć
func update_life(lives):
    $LifeLabel.text = str(lives)
    
#funkcja aktualizująca wypisywany wynik
func update_score(score):
    $ScoreLabel.text = str(score)
    
#funkcja ukrycia wiadomości
func hide_message():
    $MessageLabel.hide()

#funkcja pokazująca wiadomość, bez kontroli czasu
func show_message(message):
    $MessageLabel.text = message
    $MessageLabel.show()
    
    