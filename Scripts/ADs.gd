extends Node2D

signal ads_done

var screenSize = Vector2(0,0)
var background_scenes = preload("res://Scenes/Background.tscn")


func _ready() -> void:
	setup()



func setup():
	print("ADs setup()")
	screenSize = get_viewport().get_visible_rect().size
	$CenterContainer/ADImage.rect_min_size = screenSize	
	$CloseADs.visible = true
#	var background_node = background_scenes.instance()
#	self.add_child(background_node)
#	background_node.set_visible(true)
#	Main.show_background_node(false)
	print("set screen size = %s" %  screenSize)
	$TimerTime.visible = false
	ads_set_timer()

func ads_set_timer():
	print("ADs ads_set_timer()")
#	$ADsTimer.wait_time = 3
#	$ADsTimer.one_shot = true

func start_ads_timer():
	print("ADs start_ads_timer()")
	$TimerTime.visible = true
#	$CloseADs.visible = false
#	$ADsTimer.start()

#func _process(delta: float) -> void:
#	if $ADsTimer.get_time_left() != 0:
#		$TimerTime.text = str($ADsTimer.time_left)

func _on_ADsTimer_timeout() -> void:
	print("ADs _on_ADsTimer_timeout()")
	$TimerTime.visible = false
	$CloseADs.visible = true

func _on_Button_pressed() -> void:
	print("ADs _on_Button_pressed()")
	emit_signal("ads_done")
	Main.ads_node.hide()
	Main.new_game()





