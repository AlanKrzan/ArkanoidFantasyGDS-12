extends KinematicBody2D

var score=10

signal points(score) #deklaracji sygnalu do przekazywania punktów


#funkcja zwracająca wynik i niszcząca bloczek
func hit():
    emit_signal("points",get_score())
    #remove_from_group("Block")
    queue_free()

func get_score(): # wstępna deklaracja funkcji obliczającej ilość punktów
    return score
