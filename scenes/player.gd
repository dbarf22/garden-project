extends CharacterBody2D
var speed: int
var screen_size: Vector2 
var cardinal_direction: Vector2 = Vector2.DOWN #Holds vector that shows what direction we are facing

var direction : Vector2 = Vector2.ZERO
var state : String = "idle"

#todo: loading and menu states 
var loading: bool = true
var menu: bool = false

var target_pixel: Vector2 = Vector2.ZERO # The pixel coordinates of the tile we are looking at
var last_grid_target: Vector2i = Vector2i(-1,-1) # Previously held grid_target value (initialized to not be equal to grid_target)
var grid_target: Vector2i = Vector2i.ZERO # The grid we are looking at
var atlasCoords: Vector2i = Vector2i.ZERO # Atlas coordinates of tilemap to check textures

# Text box stuff
@onready var text_entry: CanvasLayer = $"../TextEntry"
@onready var text_edit: TextEdit = $"../TextEntry/CenterContainer/VBoxContainer/TextEdit"
@onready var text_submit: Button = $"../TextEntry/CenterContainer/VBoxContainer/Button"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var terrain: TileMapLayer = $"../Terrain"
@onready var decor: TileMapLayer = $"../Decor"

func _ready():
	populate()
	speed = 100
	screen_size = get_viewport_rect().size
	position = screen_size/2
	animation_player.play("idle_down")
	target_pixel= global_position + (cardinal_direction * 20)

func _physics_process(delta: float):
	
	if loading:
		return true

	# How this works: 
	# Target position takes player's position and adds 20 pixels to it (<32 to compensate for overshoot)
	# So that gives the pixel location of where the player is faced. So we then want to make a variable
	# To hold the current grid location, stored as a 2d integer vector. This uses the terrain's
	# local_to_map method to convert the pixel location to the grid coordinates on the terrain tilemap
	# Thus current_grid holds the grid we are currently "looking" at
	# Now that we have that tilemap coordinates, we want to first check if the current grid coordinates
	# are equal to the old ones (we initialized this with an arbitrary alue so this loop starts correctly)
	# If the current grid is different than the old location (i.e, we moved), then we start updating things
	# We make the target grid (to be interacted with) equal to the current grid we are looking at
	# We then set atlasCoords by feeding the grid coordinates into get_cell_atlas_coords on Terrain.
	# Thus we can use this atlasCoords value later on to see if the sprite is a dirt block or not.
	# Finally we update the last_grid_target value to grid_target.

	# Basically we are checking our pixel location all the time, but we don't update anything else unless
	# we have moved to a new grid
	target_pixel= global_position + (cardinal_direction * 20)
	var current_grid: Vector2i = terrain.local_to_map(target_pixel)
	if current_grid != last_grid_target:
		grid_target = current_grid
		atlasCoords = terrain.get_cell_atlas_coords(grid_target)
		setPlaceholder()
		removePlaceholder()
		last_grid_target = grid_target


	# Sets x and y values for the direction vector. 
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	# Normalize direction (to keep diagonal speed consistent) and multiply by speed
	velocity = direction.normalized() * speed
	# If the direction or state are changed, update our animation
	if setState() == true or setDirection() == true:
		updateAnimation()
	move_and_slide()

# Check if the spot is plantable and e
func setPlaceholder():
	if isPlantable():
		decor.set_cell(grid_target, 3, Vector2(0,0))

func removePlaceholder():
	if decor.get_cell_source_id(last_grid_target) == 3:
		decor.set_cell(last_grid_target, 3, Vector2(-1,-1))

func setDirection() -> bool:
	# At spawn or if the direction is still the same, we don't use this method
	if direction == Vector2.ZERO || direction == cardinal_direction:
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
		cardinal_direction = Vector2(1,-1)
	if direction.y > 0 and direction.x > 0: #Downright
		cardinal_direction = Vector2(1,1)
	if direction.y < 0 and direction.x < 0: # Upleft
		cardinal_direction = Vector2(-1,-1)
	if direction.y > 0 and direction.x < 0: # Downleft
		cardinal_direction = Vector2(-1,1)

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

# We set the animation direction based on whatever vector is read from cardinal_direction
func getAnimDirection():
	if cardinal_direction == Vector2.DOWN:
		return "down"
	if cardinal_direction == Vector2.UP:
		return "up"
	if cardinal_direction == Vector2.LEFT:
		return "left"
	if cardinal_direction == Vector2.RIGHT:
		return "right"
	if cardinal_direction == Vector2(1,-1):
		return "upright"
	if cardinal_direction == Vector2(1,1):
		return "downright"
	if cardinal_direction == Vector2(-1,-1):
		return "upleft"
	if cardinal_direction == Vector2(-1, 1):
		return "downleft"

# Handle the input of planting something
func _input(event):
	if event.is_action_pressed("interact") and isPlantable():		
		var submitted = false
		text_submit.handle_interact(grid_target.x,grid_target.y)
		decor.set_cell(grid_target, 1, Vector2(0,1))

func isPlantable() -> bool:
	# First: Check the atlasCoordinates to see if they match to a dirt block
	if atlasCoords == Vector2i(0,3) or atlasCoords ==Vector2i(1,3) or atlasCoords ==Vector2i(2,3):
		# Second: Check if that spot on the decor grid is empty. 
		if decor.get_cell_source_id(grid_target) == 3 or decor.get_cell_source_id(grid_target) == -1:
			# Third: If it has the placeholder, return true. Else, return false.
			return true
		else: return false
	else: return false



# Networking stuff
# First a method to plant flowers 
func plant_flower(x:int, y:int, flowerType: int):
	decor.set_cell(Vector2(x,y),1,Vector2(0,1))
	
# Next a method to grab flowers from db and call that previous method to populate
func populate():
	var flowers = await HttpRequestManager.get_flowers()
	for flower in flowers:
		plant_flower(flower.x,flower.y,1)
	print("Loading done")
	loading = false
