extends KinematicBody2D

export var score=5
signal points(score,is_ball) #deklaracji sygnalu do przekazywania punktów
var power_up=null


#funkcja zwracająca wynik i niszcząca bloczek
func death():
    queue_free()

func start(pos):
    position=pos
    
func hit():
    $AudioStreamPlayer2D.play()
    emit_signal("points",_get_score(),true)
    if Global.check_power():
        var c=Global.return_power().instance()
        c.start(position)
        get_parent().add_child(c)
    queue_free()
    
func set_power(powerup):
    power_up=powerup


    
func _get_score(): # wstępna deklaracja funkcji obliczającej ilość punktów

    return score
