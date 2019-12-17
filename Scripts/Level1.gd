extends Node2D
#warning-ignore-all:unused_variable
#warning-ignore-all:return_value_discarded


var started=false                       #czy rozgrywka się zaczeła?, używana w logice gry
var life=3                              #inicjalizacja ilości żyć
var blocks_left=0                       #licznik bloczków
var spawn_trigger_value                 #wartość od której zaczynają się pojawiać przeciwnicy, w kodzie jest to 3/4 bloczków
var spawn_permission=true               #zmienna do ograniczenia ilości przeciwników
var upgrade_count=0                     #suma ulepszen
export var extend_powerup_count=3       #ilosc ulepszen poszerzających kijek)
export var fire_powerup_count=4
export var extra_life_count=2           #ilosc ulepszen dających dodatkowe życie
export var sticky_count=3               #ilosc ulepszen "przyklejacych" piłke do kijka
export var win_powerup_count=3          #ilosc ulepszen dających zwyciestwo
export var extra_balls_powerup_count=4  #ilosc ulepszen dające dostep do 2 dodatkowych piłek
export var slow_powerup_count=2         #ilosc ulepszen spowalniających piłke
export var level=1                      #obecny poziom gry
var extra_balls_spawn=0                 #ilosc dostępnych extra piłek
var extra_balls=0                       #ilosc dodatkowych piłek
signal stop                             #sygnały wysyłane do reszty kodu
signal move
signal purge
signal die


#funkcja rozpoczęcia rozgrywki
func new_game():
    started=true
    _spawn_ball()
    emit_signal("move")
    $Hud.hide_message()
    $SpeedUpTimer.start()

func _spawn_ball():
    var c = Global.Ball.instance()
    c.start(($Paddle.position+Vector2(0,-30)))
    if extra_balls==0:
        $Paddle/BallDummy.hide()
    self.connect("stop",c,"stop_movement")
    self.connect("die",c,"die")
    self.connect("purge",c,"die")
    $Paddle.connect("half_speed",c,"_half")
    get_parent().add_child(c)

#ustawienie elementów gry do rozgrywki
func _ready():
    randomize()
    Global.score=0
    Global.life=3
    $Hud.update_score(Global.score)
    upgrade_count = extend_powerup_count + sticky_count + extra_life_count + win_powerup_count \
    + fire_powerup_count + extra_balls_powerup_count + slow_powerup_count
    $Paddle.start($StartPosition.position)
    var blocks = get_tree().get_nodes_in_group("Block")
    blocks_left = blocks.size()
    spawn_trigger_value = blocks_left*0.75
    self.connect("stop",$Paddle,"_stop_movement")
    self.connect("move",$Paddle,"_start_movement")
    for block in blocks:
        if block.has_method("set_level"):
            block.set_level(level)
        block.connect("points",self,"_get_points")
        self.connect("purge",block,"death")
    var sample
    if upgrade_count < blocks.size():
        #print(upgrade_count," ",blocks.size())
        sample=__rand_sample(upgrade_count,blocks)
    else:
        sample=__rand_sample(blocks.size(),blocks)
    var powerup_list=_powerup_list()
    for i in range(sample.size()):
        sample[i].set_power(powerup_list[i])
    $Hud.show_message("Press SPACE to start")

func _add_life():
    life+=1
    $Hud.update_life(life)

#funkcja zwracająca liste ulepszen, TODO: rozszerzyć o więcej ulepszeń
func _powerup_list():
    var list=[]
    for i in range(extend_powerup_count):
        list.append(Global.Extend)
    for i in range(sticky_count):
        list.append(Global.Sticky)
    for i in range(extra_life_count):
        list.append(Global.Extra)
    for i in range(win_powerup_count):
        list.append(Global.Win)
    for i in range(extra_balls_powerup_count):
        list.append(Global.Balls)
    for i in range(slow_powerup_count):
        list.append(Global.Slow)
    for i in range(fire_powerup_count):
        list.append(Global.Fire)
    return list

#sprawdzanie czy można wywołąć przeciwnika dla animacji
func _spawn_check():
    return spawn_permission and spawn_trigger_value > blocks_left and blocks_left>2

# wywołanie przeciwnika, jeśli
func _spawn_enemy():
    if _spawn_check():
        spawn_permission=false
        var e = Global.Enemy.instance()
        e.start(($Top/SpawnPosition.get_global_transform_with_canvas().get_origin()))
        self.connect("stop",e,"stop_movement")
        self.connect("purge",e,"die")
        self.connect("die",e,"die")
        self.connect("move",e,"restart_movement")
        e.connect("release",self,"_enable_enemy")
        e.connect("points",self,"_get_points")
        get_parent().add_child(e)

#funkcja przyznanie punktów, sprawdzenie warunku zwycięstwa
func _get_points(points,is_block):
    Global.score+=points
    $Hud.update_score(Global.score)
    if is_block:
        blocks_left -= 1
        if blocks_left==1:
            var blocks = get_tree().get_nodes_in_group("Block")
            for block in blocks:
                block.set_power(null)
        if blocks_left <= 0:
            _win()
            started=false
            return
    if _spawn_check():
        $Top/AnimatedSprite.play("")

#funckja zwycięstwa TODO zmienić scenę na następny poziom, jak już będzie
func _win():
    emit_signal("stop")
    $Hud.show_message("Victory")
    $WinTimer.start()

#funkcja przegrania gry, powrót do menu po czasie
func _game_over():
    emit_signal("stop")
    Global.score=0
    $Hud.show_message("GAME OVER")
    $EscapeTimer.start()

#warning-ignore:unused_argument
#wbudowan funkcja, nadpisana aby sprawdzić czy spacja jest wciśnieta do rozpoczęcia rozgrywki
func _process(delta):
    if Input.is_action_pressed("ui_select") and !started:
        new_game()
    if Input.is_action_just_pressed("ui_cancel"):
        emit_signal("purge")
        get_tree().change_scene("res://MainMenu.tscn")
    if Input.is_action_just_pressed("ui_select") and started and extra_balls_spawn>0 and $Paddle.upgrade==4:
        extra_balls_spawn-=1
        extra_balls+=1
        _spawn_ball()
        if extra_balls_spawn == 0:
            $Paddle/BallDummy.hide()

#funkcja ucieczki piłki, sprawdzanie warunku porażki
func _on_Bottom_redo():
    if extra_balls>0:
        extra_balls-=1
    else:
        life-=1
        $Hud.update_life(life)
        if life>0:
            emit_signal("stop")
            emit_signal("die")
            $Paddle.reset()
            $Paddle/BallDummy.show()
            $Hud.show_message("Press SPACE to start")
            $Paddle.start($StartPosition.position)
            started=false
        else:
            _game_over()

#funkcja ustawiająca więcej piłek
func _extra_balls():
    extra_balls_spawn=2
    $Paddle/BallDummy.show()

#funkcja umożliwiająca wywołanie przeciwnika, potrzebna dla jednego sygnału
func _enable_enemy():
    spawn_permission=true

#funkcja zwracająca próbkę n elementów z listy
func __rand_sample(n,list):
    if list==[]:
        return []
    var sample = []
    for i in range(n):
        var x = randi()%list.size()
        sample.append(list[x])
        list.remove(x)
    return sample

#funkcja podnosząca prędkość piłki, co SpeedUpTimer
func _on_SpeedUpTimer_timeout():
    var balls = get_tree().get_nodes_in_group("Ball")
    for ball in balls:
        ball.accelerate(0.02)

#funkcja powracająca do Menu po upływie czasu
func _on_EscapeTimer_timeout():
    emit_signal("purge")
    get_tree().change_scene("res://MainMenu.tscn")

#funkcja wywołująca przeciwnika po animacji otwierania
func _on_AnimatedSprite_animation_finished():
    _spawn_enemy()
    $Top/AnimatedSprite.stop()


func _on_WinTimer_timeout():
    emit_signal("purge")
    get_tree().change_scene("res://Level2.tscn")
