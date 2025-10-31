class_name Player extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var anim = $AnimatedSprite2D
@onready var jump: AudioStreamPlayer2D = $Jump

# Gravity multiplier
var gravity_multiplier: float = 1.0

# Roll variables
var is_rolling: bool = false
var roll_speed: float = 180.0
var roll_duration: float = 0.3
var roll_timer: float = 0.0
var roll_direction: float = 1.0

# Hit variables
var is_hit: bool = false
var hit_duration: float = 0.5
var hit_timer: float = 0.0

func _physics_process(delta: float) -> void:
	# --- Handle Hit ---
	if is_hit:
		hit_timer -= delta

		# ✅ Only start animation once (not every frame)
		if not anim.is_playing() or anim.animation != "hit":
			anim.play("hit")
		
		if hit_timer <= 0:
			is_hit = false
		return

	# --- Handle Roll ---
	if is_rolling:
		roll_timer -= delta
		if not anim.is_playing() or anim.animation != "roll":
			anim.play("roll")
		
		if roll_timer <= 0:
			is_rolling = false
			velocity.x = 0
		else:
			velocity.x = roll_direction * roll_speed
		
		move_and_slide()
		return
	
	# --- Gravity ---
	if not is_on_floor():
		var gravity = get_gravity() * gravity_multiplier
		velocity += gravity * delta
	
	# --- Jump ---
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump.play()
		velocity.y = JUMP_VELOCITY
	
	# --- Roll trigger ---
	if Input.is_action_just_pressed("ui_shift") and is_on_floor():
		start_roll()
		return
	
	# --- Movement ---
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	update_animation()

func update_animation() -> void:
	if is_rolling or is_hit:
		return
	
	if not is_on_floor():
		anim.play("jump")
	elif abs(velocity.x) > 0:
		anim.play("run")
	else:
		anim.play("idle")

func start_roll() -> void:
	is_rolling = true
	roll_timer = roll_duration
	roll_direction = -1.0 if anim.flip_h else 1.0
	velocity.x = roll_direction * roll_speed
	velocity.y = 0
	anim.play("roll")

func start_hit() -> void:
	is_hit = true
	hit_timer = hit_duration
	velocity = Vector2.ZERO
	anim.play("hit")
	if $HitSound:
		$HitSound.play()

func set_hit(value: bool) -> void:
	if value:
		start_hit()

func set_gravity_multiplier(value: float) -> void:
	gravity_multiplier = value
