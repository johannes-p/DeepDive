extends CanvasLayer

var oxygen_level = 100
var oxygen_timer = Timer.new()

var blackout_amount = 0.0
var blackout_timer = Timer.new()
var blackout_sequence_complete = false

var health : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	oxygen_timer.connect("timeout", decrease_oxygen)
	oxygen_timer.wait_time = 1.5
	oxygen_timer.one_shot = false
	add_child(oxygen_timer)
	oxygen_timer.start()
	
	blackout_timer.connect("timeout", blackout)
	blackout_timer.wait_time = 0.25
	blackout_timer.one_shot = false
	add_child(blackout_timer)

func _on_player_update_depth(depth):
	$DepthIndicator/DepthLabel.text = str(depth) + 'm'
	
func decrease_oxygen():
	oxygen_level = oxygen_level - 5 if oxygen_level > 0 else 0
	$OxygenIndicator/OxygenMeter.value = oxygen_level
	
	if oxygen_level == 0:
		blackout_timer.start()

func blackout():
	blackout_amount+=0.05
	$BlackoutRect.color = Color(0,0,0,blackout_amount)
	
	if blackout_amount == 1.0:
		# TODO: end game
		pass
	
func collected_oxygen():
	reset_blackout()
	
	# update oxygen_level
	oxygen_level = oxygen_level + 25 if oxygen_level <= 75 else 100
	$OxygenIndicator/OxygenMeter.value = oxygen_level

func reset_blackout():
	blackout_amount = 0.0
	$BlackoutRect.color = Color(0,0,0,blackout_amount)
	blackout_timer.stop()

func remove_heart():
	#TODO: timeout
	
	health-=1
	
	if health < 1:
		#TODO: end game
		pass

	$healthIndicator/heart2.visible = health >= 2
	$healthIndicator/heart3.visible = health >= 3
	
	
	pass

func reset():
	reset_blackout()
	
	# reset health
	health = 3
	for heart in $healthIndicator.get_children():
		heart.visibile = true
	
	# reset oxygen
	oxygen_level = 100
	$OxygenIndicator/OxygenMeter.value = 100
