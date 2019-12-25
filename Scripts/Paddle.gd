extends KinematicBody2D

var Bullet = preload("res://Bullet.tscn")
export var margin=60
export var edge_size=45
var l_margin
var r_margin
export var paddle_speed = 500  # How fast the player will move (pixels/sec).
export var paddle_width = 60
export var reload_time = 0.1
var reloading=0
var screen_size # Size of the game window.
onready var initial_pos = self.position
var speed = paddle_speed
var upgrade = 0
export var power_up_width_scale=1.5
export var exit_speed=100
var on=false
const north=Vector2(0,-1)
var victory=false
var stay=true
var angles_array=[-40,-25,-10,10,25,40]
var parent=get_parent()
signal extraLife
signal follow(x)
signal disconnect
signal win
signal extraBalls
signal half_speed
signal leaving

#ustawienie kijka na pozycji początkowej, i wyświetlenie go
func start(pos):
    position = pos
    victory=false
    stay=true
    show()
#powrót na pozycję początkową i reset ulepszeń do zera
func reset():
    position = initial_pos
    _reset_power()
    
#funckaj przyznająca ulepszenia, TODO: dodać więcej
func power_up(value):
    if upgrade != 0:
        _reset_power()
    print("power up:"+str(value))
    if value==1:    #extend
        upgrade=1
        $Normal.hide()
        var shape = $CollisionShape2D.get_shape()
        var oldScale = shape.get_extents()
        shape.set_extents(Vector2(paddle_width*power_up_width_scale,oldScale.y))
        $Long.show()
        l_margin=margin*power_up_width_scale+edge_size
        if stay:
            r_margin=screen_size.x-l_margin
        else:
            r_margin=screen_size.x-margin
    elif value==2: #shooting
        $Shooting.show()
        $Normal.hide()
        upgrade=2
    elif value==3: #sticky
        upgrade=3
    elif value==4: #Multiplication
        upgrade=4
        emit_signal("extraBalls")
    elif value==5:
        emit_signal("extraLife")
    elif value==6:
        stay=false
        r_margin=screen_size.x-margin
    elif value==7:
        emit_signal("half_speed")
        

#funkcja obsługi ruchu?, powstała bo coś kombinowałem i nie chciałem powtarzać ten sam kod
func __motion(velocity,collision,angle):
    var motion = collision.remainder.bounce(north)
    var angle_from_north = velocity.angle_to(north) + angle
    velocity = velocity.rotated(angle_from_north)
    motion = motion.rotated(motion.angle_to(north)+angle)
    return [motion,velocity]

#funckja obliczająca alternatywny vector normalny odbicia, w zależności od pozycji, daje dziwne efekty dla kąta >45 od północy
func angles(ball_position_x,velocity,collision):
    var width
    if upgrade==1:
        width=paddle_width * power_up_width_scale
    else:
        width=paddle_width
    var distance
    if position.x > ball_position_x:
        distance = position.x - ball_position_x
        if distance > width/3:
             if distance > width*2/3:
                collision=__motion(velocity,collision,angles_array[0])
             else:
                collision=__motion(velocity,collision,angles_array[1])
        else:
            collision=__motion(velocity,collision,angles_array[2])
    elif position.x < ball_position_x:
        distance = ball_position_x - position.x
        if distance > width/3:
             if distance > width*2/3:
                collision=__motion(velocity,collision,angles_array[5])
             else:
                collision=__motion(velocity,collision,angles_array[4])
        else:
            collision=__motion(velocity,collision,angles_array[3])
    else:
        collision=__motion(velocity,collision,collision.normal)
    return collision

#funkcja resetująca ulepszenia TODO: cofnąć inne ulepszenia jeśli coś zmieniają, jak powstaną
func _reset_power():
    upgrade=0
    emit_signal("disconnect")
    var shape = $CollisionShape2D.get_shape()
    var oldScale = shape.get_extents()
    shape.set_extents(Vector2(paddle_width,oldScale.y))
    $Shooting.hide()
    $Long.hide()
    $Normal.show()
    l_margin=margin+edge_size
    screen_size = get_viewport_rect().size
    if stay:
        r_margin=screen_size.x-l_margin
    else:
        r_margin=screen_size.x-margin
    
#warning-ignore:unused_argument    
#funkcja przygotująca kijek do rozgrywki
func _ready():
    parent=get_parent()
    # warning-ignore:unused_variable
    var suppress_warning = self.connect("extraLife",parent,"_add_life")
    suppress_warning = self.connect("leaving",parent,"_leaving")
    suppress_warning = self.connect("win",parent,"_win")
    suppress_warning = self.connect("extraBalls",parent,"_extra_balls")
    _reset_power()
    for i in range(angles_array.size()):
        angles_array[i]=deg2rad(angles_array[i])
    screen_size = get_viewport_rect().size
    l_margin = margin +edge_size
    r_margin =  screen_size.x - l_margin
    hide()
    
# funkcja dla sygnału rozpoczynającego grę
func _start_movement():
    on=true
    
# funkcja dla sygnału zatrzymującego grę
func _stop_movement():
    on=false

# obsluga poruszania się
func _process(delta):
    if on:
        reloading-=delta
        var velocity = 0  # The paddle movement value.
        if Input.is_action_pressed("ui_right"):
            velocity = 1
        if Input.is_action_pressed("ui_left"):
            velocity = -1
        if velocity != 0:
            velocity = velocity * speed * delta
            var newpos = position.x + velocity
            position.x = clamp(newpos, l_margin, r_margin)
            if position.x >= screen_size.x-margin:
                on=false
                emit_signal("leaving")
                stay=false
            if newpos!=position.x:
                emit_signal("follow",velocity)
        if Input.is_action_just_pressed("ui_select"):
            if upgrade==3:
                emit_signal("disconnect")
            elif upgrade==2:
                if reloading <=0.0:
                    var b = Bullet.instance()
                    b.start(position+Vector2(0,-30))
                    parent.connect("stop",b,"_stop_movement")
                    parent.connect("purge",b,"_die")
                    parent.connect("die",b,"_die")
                    parent.add_child(b)
                    reloading = reload_time
    elif stay==false:
        position.x+=exit_speed*delta
        if position.x>=screen_size.x-5 and not victory:
            emit_signal("win")
            victory=true
