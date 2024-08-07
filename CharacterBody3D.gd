extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var frame : int
@export var facing = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Reference to the AnimatedSprite3D node
@onready var animated_sprite = $AnimatedSprite3D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		# Play the appropriate animation based on the input direction
		if input_dir.y > 0:
			animated_sprite.play("walkdown")
		elif input_dir.y < 0:
			animated_sprite.play("walkup")
		elif input_dir.x < 0:
			animated_sprite.play("walkleft")
		elif input_dir.x > 0:
			animated_sprite.play("walkright")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		# Play the idle animation if not moving
		animated_sprite.play("idle")

	move_and_slide()
