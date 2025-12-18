extends CharacterBody2D
var speed: int
var screen_size: Vector2
var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var state : String = "idle"
var target_tile : Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var terrain: TileMapLayer = $"../Terrain"
@onready var decor: TileMapLayer = $"../Decor"

func _ready():
	speed = 100
	screen_size = get_viewport_rect().size
	position = screen_size/2
	animation_player.play("idle_down")

	
func _physics_process(delta: float):
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	velocity = direction.normalized() * speed
	if setState() == true or setDirection() == true:
		updateAnimation()
	move_and_slide()
	
	
func setDirection() -> bool:
	var new_direction : Vector2 = cardinal_direction
	if direction == Vector2.ZERO || direction.normalized() == cardinal_direction:
		return false
	if direction.y < 0 and direction.x == 0:
		cardinal_direction = Vector2.UP
	if direction.y > 0 and direction.x == 0:
		cardinal_direction = Vector2.DOWN
	if direction.y == 0 and direction.x > 0:
		cardinal_direction = Vector2.RIGHT
	if direction.y == 0 and direction.x < 0:
		cardinal_direction = Vector2.LEFT
		
	if direction.y < 0 and direction.x > 0: # Upright
		cardinal_direction = Vector2(1,-1).normalized()
	if direction.y > 0 and direction.x > 0: #Downright
		cardinal_direction = Vector2(1,1).normalized()
	if direction.y < 0 and direction.x < 0: # Upleft
		cardinal_direction = Vector2(-1,-1).normalized()
	if direction.y > 0 and direction.x < 0: # Downleft
		cardinal_direction = Vector2(-1,1).normalized()
	
	return true
	
# If we have to change from walking to idle this returns true so the
# physics thing knows to change the animation. To prevent method from
# Constantly being called
func setState() -> bool:
	var new_state: String = "idle" if direction == Vector2.ZERO else "walking"
	if new_state == state:
		return false
	state = new_state
	return true

# Uses the variables at the top to change animation based on state and direction
func updateAnimation():
	animation_player.play(state + "_" + getAnimDirection())
	
	
func getAnimDirection():
	if cardinal_direction == Vector2.DOWN:
		return "down"
	if cardinal_direction == Vector2.UP:
		return "up"
	if cardinal_direction == Vector2.LEFT:
		return "left"
	if cardinal_direction == Vector2.RIGHT:
		return "right"
	if cardinal_direction == Vector2(1,-1).normalized():
		return "upright"
	if cardinal_direction == Vector2(1,1).normalized():
		return "downright"
	if cardinal_direction == Vector2(-1,-1).normalized():
		return "upleft"
	if cardinal_direction == Vector2(-1, 1).normalized():
		return "downleft"

func _input(event):
	if event.is_action_pressed("interact"):
		# The pixel location of where we are looking
		var target_pixel: Vector2 = global_position + (cardinal_direction * 8)
		# Convert that into the terrain coordinates
		var grid_target: Vector2 = terrain.local_to_map(target_pixel)
		print("location: ", grid_target)
		# Get the atlas location of the texture on sprite sheet
		var atlasCoords: Vector2 = terrain.get_cell_atlas_coords(grid_target)
		print(atlasCoords)
		# Check it's from atlas id one
		if terrain.get_cell_source_id(atlasCoords) == 1: 
			# If it's a dirt texture
			print("adgsg")
			if atlasCoords == Vector2(0,3) or atlasCoords ==Vector2(1,3) or atlasCoords ==Vector2(2,3):
				# If it's empty, then set it. If not, ignore it. We check the 
				# decor atlas for this since it holds flowers
				print(decor.get_cell_source_id(grid_target))
				if decor.get_cell_source_id(grid_target) == -1:
					decor.set_cell(grid_target, 1, Vector2(0,1))
					print("Planted!")	 	
