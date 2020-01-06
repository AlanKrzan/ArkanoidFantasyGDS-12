extends KinematicBody2D

export var score=50
var level=0
var lives=1
signal points(score,is_ball) #deklaracji sygnalu do przekazywania punktów
var power_up=null

#funkcja zwracająca wynik i niszcząca bloczek
func death():
    queue_free()
    
func start(pos):
    position=pos

func hit():
    if lives>0:
        lives-=1
        $Sprite2.hide()
    else:
        emit_signal("points",_get_score(),true)
        if Global.check_power():
            var c=Global.return_power().instance()
            c.start(position)
            get_parent().add_child(c)
        queue_free()
    
func set_power(powerup):
    power_up=powerup
    
func set_level(current_level):
    level=current_level
    
func _get_score(): # wstępna deklaracja funkcji obliczającej ilość punktów
    return score*level