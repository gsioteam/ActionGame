extends MeshInstance

tool

export var frames: SpriteFrames
export var animation: String = "default"
export var frame: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var max_frame = 0
	
