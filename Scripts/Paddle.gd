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
export var power_up_width_scale=2
var sprite_scale=2
var on=false
const north=Vector2(0,-1)
var angles=[-40,-25,-10,10,25,40]
var parent=get_parent()
signal extraLife
signal follow(x)
signal disconnect
signal win
signal extraBalls
signal half_speed

#ustawienie kijka na pozycji początkowej, i wyświetlenie go
func start(pos):
    position = pos
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
    if value==1:
        upgrade=1
        var shape = $CollisionShape2D.get_shape()
        var oldScale = shape.get_extents()
        shape.set_extents(Vector2(paddle_width*power_up_width_scale,oldScale.y))
        $Sprite.scale=Vector2(power_up_width_scale*sprite_scale,1)
        l_margin=margin*power_up_width_scale+edge_size
        r_margin=screen_size.x-l_margin
    elif value==2:
        upgrade=2
    elif value==3:
        upgrade=3
    elif value==4:
        upgrade=4
        emit_signal("extraBalls")
    elif value==5:
        emit_signal("extraLife")
    elif value==6:
        emit_signal("win")
    elif value==7:
        emit_signal("half_speed")
        

#funkcja obsługi ruchu?, powstała bo coś kombinowałem i nie chciałem powtarzać ten sam kod
func __motion(velocity,collision,angle):
    var motion = collision.remainder.bounce(north)
    var angle_from_north = velocity.angle_to(north) + angle
    print(angle," part of ",angle_from_north, "deegress ",rad2deg(angle_from_north)," north:",north)
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
                collision=__motion(velocity,collision,angles[0])
             else:
                collision=__motion(velocity,collision,angles[1])
        else:
            collision=__motion(velocity,collision,angles[2])
    elif position.x < ball_position_x:
        distance = ball_position_x - position.x
        if distance > width/3:
             if distance > width*2/3:
                collision=__motion(velocity,collision,angles[5])
             else:
                collision=__motion(velocity,collision,angles[4])
        else:
            collision=__motion(velocity,collision,angles[3])
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
    $Sprite.scale=Vector2(sprite_scale,1)
    l_margin=margin+edge_size
    screen_size = get_viewport_rect().size
    r_margin=screen_size.x-l_margin
    
#warning-ignore:unused_argument    
#funkcja przygotująca kijek do rozgrywki
func _ready():
    parent=get_parent()
    var suppress_warning = self.connect("extraLife",parent,"_add_life")
    suppress_warning = self.connect("win",parent,"_win")
    suppress_warning = self.connect("extraBalls",parent,"_extra_balls")
    _reset_power()
    var north = Vector2(0,-1)
    for i in range(angles.size()):
        angles[i]=deg2rad(angles[i])
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
        
        
