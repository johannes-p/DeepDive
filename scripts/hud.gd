extends CanvasLayer

signal player_died(reason, depth, collected_trash)

var oxygen_level = 100
var oxygen_timer = Timer.new()

var blackout_amount = 0.0
var blackout_timer = Timer.new()
var blackout_sequence_complete = false

var health : int = 3
var collected_trash : int = 0

var player_depth : String 

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
	player_depth = str(depth)
	$DepthIndicator/DepthLabel.text = player_depth + 'm'
	
func decrease_oxygen():
	oxygen_level = oxygen_level - 5 if oxygen_level > 0 else 0
	$OxygenIndicator/OxygenMeter.value = oxygen_level
	
	if oxygen_level == 0:
		blackout_timer.start()

func blackout():
	blackout_amount+=0.05
	$BlackoutRect.color = Color(0,0,0,blackout_amount)
	
	if blackout_amount >= 1.0:
		emit_signal("player_died", "oxygen", player_depth, collected_trash)
	
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
		emit_signal("player_died", "health", player_depth, collected_trash)

	$healthIndicator/heart2.visible = health >= 2
	$healthIndicator/heart3.visible = health >= 3

func pickup_trash():
	collected_trash+=1

func reset():
	reset_blackout()
	
	# reset health
	health = 3
	for heart in $healthIndicator.get_children():
		heart.visible = true
	
	# reset oxygen
	oxygen_level = 100
	$OxygenIndicator/OxygenMeter.value = 100
	
	collected_trash = 0
