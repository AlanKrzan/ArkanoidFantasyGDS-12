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
    emit_signal("points",_get_score(),true)
    if check_power():
        var c=return_power().instance()
        c.start(position)
        get_parent().add_child(c)
    queue_free()
    
func set_power(powerup):
    power_up=powerup

func return_power():
    randomize()
    var x=randf()
    if x>=0.8:
        return Global.upgrades["Lasers"]
    elif x>=0.65:
        return Global.upgrades["Catch"]
    elif x>=0.5:
        return Global.upgrades["Slow"]
    elif x>=0.45:
        return Global.upgrades["Bye"]
    elif x>=0.3:
        return Global.upgrades["Duplicate"]
    elif x>=0.2:
        return Global.upgrades["Extra-Life"]
    else:
        return Global.upgrades["Expand"]

func check_power():
    if randf()<=0.1:
        return true
    else:
        return false
    
func _get_score(): # wstępna deklaracja funkcji obliczającej ilość punktów
    return score
