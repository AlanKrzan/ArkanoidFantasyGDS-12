extends Node2D
#warning-ignore-all:unused_variable
#warning-ignore-all:return_value_discarded


var started=false                       #czy rozgrywka się zaczeła?, używana w logice gry
var blocks_left=0                       #licznik bloczków
var spawn_trigger_value                 #wartość od której zaczynają się pojawiać przeciwnicy, w kodzie jest to 3/4 bloczków
var spawn_permission=true               #zmienna do ograniczenia ilości przeciwników
#var upgrade_count=0                     #suma ulepszen
#export var extend_powerup_count=3       #ilosc ulepszen poszerzających kijek)
#export var fire_powerup_count=4
#export var extra_life_count=2           #ilosc ulepszen dających dodatkowe życie
#export var sticky_count=3               #ilosc ulepszen "przyklejacych" piłke do kijka
#export var win_powerup_count=3          #ilosc ulepszen dających zwyciestwo
#export var extra_balls_powerup_count=4  #ilosc ulepszen dające dostep do 2 dodatkowych piłek
#export var slow_powerup_count=2         #ilosc ulepszen spowalniających piłke
# warning-ignore:unused_class_variable
export var level=1                      #obecny poziom gry
var extra_balls=0                       #ilosc dodatkowych piłek
var closed=true
var menu=true
var permission=true
signal stop                             #sygnały wysyłane do reszty kodu
signal leaving_stop
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

func populate_map(filename):
    var file = File.new()
    file.open(filename, file.READ)
    var json = file.get_as_text()
    var json_result = JSON.parse(json).result
    file.close()
    for i in range(json_result.size()):
        for j in range(json_result[i].size()):
            if json_result[i][j] in Global.Blocks:
                var block = Global.Blocks[json_result[i][j]].instance()
                block.start(Vector2(85+80*j,65+40*i))
                add_child(block)
                
func _spawn_ball():
    var c = Global.Ball.instance()
    c.start(($Paddle.position+Vector2(0,-30)))
    if extra_balls==0:
        $Paddle/BallDummy.hide()
    self.connect("stop",c,"stop_movement")
    self.connect("leaving_stop",c,"stop_movement")
    self.connect("move",c,"restart_movement")
    self.connect("die",c,"die")
    self.connect("purge",c,"die")
    $Paddle.connect("half_speed",c,"_half")
    add_child(c)



func _add_life():
    Global.life+=1
    $Hud.update_life(Global.life)



#sprawdzanie czy można wywołąć przeciwnika dla animacji
func _spawn_check():
    return spawn_permission and spawn_trigger_value > blocks_left and blocks_left>2

# wywołanie przeciwnika, jeśli
func _spawn_enemy():
    if _spawn_check():
        spawn_permission=false
        var e = Global.Enemy.instance()
        e.start(($Top/AnimatedSprite/SpawnPosition.get_global_transform_with_canvas().get_origin()))
        self.connect("stop",e,"stop_movement")
        self.connect("leaving_stop",e,"stop_movement")
        self.connect("purge",e,"die")
        self.connect("die",e,"die")
        self.connect("move",e,"restart_movement")
        e.connect("release",self,"_enable_enemy")
        e.connect("points",self,"_get_points")
        get_parent().add_child(e)

        
func _leaving():
    emit_signal("leaving_stop")
    $Hud.show_message("Leaving")


#warning-ignore:unused_argument
#wbudowan funkcja, nadpisana aby sprawdzić czy spacja jest wciśnieta do rozpoczęcia rozgrywki
func _process(delta):
    if Input.is_action_pressed("ui_select") and !started and menu and permission:
        new_game()
    if Input.is_action_just_pressed("ui_cancel") and menu:
        $Hud. open_pause_menu()




#funkcja tworząca więcej piłek
func _extra_balls():
    var balls = get_tree().get_nodes_in_group("Ball")
    for ball in balls:
        for i in range(2):
            var c = Global.Ball.instance()
            c.start(ball.position,ball.velocity.rotated(-deg2rad(90+120*i)))
            self.connect("stop",c,"stop_movement")
            self.connect("leaving_stop",c,"stop_movement")
            self.connect("move",c,"restart_movement")
            self.connect("die",c,"die")
            self.connect("purge",c,"die")
            $Paddle.connect("half_speed",c,"_half")
            get_parent().call_deferred("add_child",c)
        extra_balls+=2

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
    
func _exit_open_play():
    if closed:
        $Right/ExitAnimatedSprite.play()
        closed=false

#funkcja ucieczki piłki, sprawdzanie warunku porażki
func _on_Bottom_redo():
    if extra_balls>0:
        extra_balls-=1
    else:
        Global.life-=1
        $Hud.update_life(Global.life)
        if Global.life>0:
            emit_signal("stop")
            emit_signal("die")
            $Paddle.reset()
            $Paddle/BallDummy.show()
            $Hud.show_message("Press SPACE to start")
            $Paddle.start($StartPosition.position)
            started=false
        else:
            _game_over()

#funkcja przegrania gry, powrót do menu po czasie
func _game_over():
    emit_signal("stop")
    $Hud.show_message("GAME OVER")
    permission=false
    menu=false
    $EscapeTimer.start()
    
func stop_movement():
    permission=false
    $SpeedUpTimer.stop()
    emit_signal("stop")
    
func start_movement():
    permission=true
    $SpeedUpTimer.start()
    emit_signal("move")
    
func purge_stuff():
    emit_signal("purge")

func Hud_signals():
    $Hud.connect("stop",self,"stop_movement")
    $Hud.connect("move",self,"start_movement")
    $Hud.connect("purge",self,"purge_stuff")

#funkcja podnosząca prędkość piłki, co SpeedUpTimer
func _on_SpeedUpTimer_timeout():
    var balls = get_tree().get_nodes_in_group("Ball")
    for ball in balls:
        ball.accelerate()

#funkcja powracająca do Menu po upływie czasu
func _on_EscapeTimer_timeout():
    if Global.checkScore():
        $HighscorePopup.popup_centered()
    else:
        emit_signal("purge")
        get_tree().change_scene("res://MainMenu.tscn")       

#funkcja wywołująca przeciwnika po animacji otwierania
func _on_AnimatedSprite_animation_finished():
    _spawn_enemy()
    $Top/AnimatedSprite.stop()
    
func _on_HighscorePopup_confirmed():
    var name = $HighscorePopup/LineEdit.get_text()
    if name.length()>0:
        Global.insertScore(name)
        get_tree().change_scene("res://HighScores.tscn")
    else:
        $HighscorePopup.set_text("Please, enter your name here:")


func _on_HighscorePopup_popup_hide():
    get_tree().change_scene("res://MainMenu.tscn")
