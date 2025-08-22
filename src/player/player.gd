extends CharacterBody2D

@export var gravity_acceleration: float
@export_group("Jump")
@export var jump_velocity: float
@export var jump_cooldown: float

@onready var jump_cooldown_timer: Timer = get_node("JumpCooldown")

func _physics_process(delta: float) -> void:
	var acceleration = gravity_acceleration
	self.velocity.y += delta * acceleration
	if Input.is_action_just_pressed("Jump") and jump_cooldown_timer.is_stopped():
		self.velocity.y -= jump_velocity
		jump_cooldown_timer.start(jump_cooldown)
	self.move_and_slide()
