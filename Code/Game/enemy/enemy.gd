class_name Enemy extends CharacterBody2D
@onready var princess: AudioStreamPlayer2D = $"../princess/flute"
enum State { WALKING, DEAD }
const WALK_SPEED = 22.0

var _state := State.WALKING
var health = 5

@onready var tilemap: TileMap = $"../TileMap"
@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@onready var platform_detector := $PlatformDetector as RayCast2D
@onready var ray_cast_left: RayCast2D = $rayCastLeft
@onready var ray_cast_right: RayCast2D = $rayCastRight
@onready var ray_cast_down: RayCast2D = $rayCastDown
@onready var ray_cast_down_right: RayCast2D = $rayCastDownRight
@onready var ray_cast_down_left: RayCast2D = $rayCastDownLeft
@onready var sprite := $Sprite2D as Sprite2D
@onready var animation_player := $AnimationPlayer as AnimationPlayer

# NEW:
@onready var gun: Gun = $Sprite2D/Gun        # same Gun script as the player
@onready var shoot_timer: Timer = $ShootTimer # constant-rate timer

@onready var win_screen: WinScreen

func _ready() -> void:
	add_to_group("enemies")
	win_screen = get_tree().get_first_node_in_group("win_screen")
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta: float) -> void:
	if _state == State.WALKING and velocity.is_zero_approx():
		velocity.x = WALK_SPEED
	velocity.y += gravity * delta
	if ray_cast_right.is_colliding():
		velocity.x = -WALK_SPEED
	if ray_cast_left.is_colliding():
		velocity.x = WALK_SPEED
	if (not ray_cast_down_right.is_colliding()) and velocity.x == WALK_SPEED:
		velocity.x = -WALK_SPEED
	elif (not ray_cast_down_left.is_colliding()) and velocity.x == -WALK_SPEED:
		velocity.x = WALK_SPEED

	if is_on_wall():
		velocity.x = -velocity.x

	move_and_slide()

	if velocity.x > 0.0:
		sprite.scale.x = 0.8
	elif velocity.x < 0.0:
		sprite.scale.x = -0.8

	var animation := get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)

func _on_shoot_timer_timeout() -> void:
	if _state == State.DEAD:
		return
	# Direction: prefer facing; fall back to velocity
	var dir := sprite.scale.x
	if dir == 0.0:
		dir = (velocity.x >= 0.0) if 1.0 else -1.0
	gun.shoot(signf(dir))  # same bullet, same velocity as player gun

func destroy() -> void:
	health -= 1
	if health <= 0:
		_state = State.DEAD
		velocity = Vector2.ZERO
		
	var enemy_count = get_tree().get_nodes_in_group("enemies").size()

	if enemy_count == 3 and health <= 0:
		var y = -31
		for x in range(9, 29):
			tilemap.erase_cell(1, Vector2i(x, y))
		var y2 = -32
		for x in range(9, 29):
			tilemap.erase_cell(1, Vector2i(x, y2))
		princess.play()
	
		

func get_new_animation() -> StringName:
	var animation_new: StringName
	if _state == State.WALKING:
		if velocity.x == 0: 
			animation_new = &"idle"
		else: 
			animation_new = &"walk"
	else: 
		animation_new = &"destroy" 
	return animation_new 

func get_type() -> String: 
	return "boss"
	
func start_shooting() -> void:
	if shoot_timer and not shoot_timer.is_stopped():
		return  # already shooting
	shoot_timer.start()
