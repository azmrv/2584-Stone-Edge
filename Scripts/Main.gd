extends Node


# Signals
signal new_game
signal game_over
signal moving_numbers
signal exit_game
signal save_player_data


#Scenes
var number_scene = preload("res://Scenes/Number.tscn")
#var ads_scene = preload("res://Scenes/ADs.tscn")
var gamefield_scene = preload("res://Scenes/GameField.tscn")
var background_scene = preload("res://Scenes/Background.tscn")
var game_field_scene = preload("res://Scenes/GameField.tscn")
var telosgames_logo_scene = preload("res://Scenes/Logo.tscn")
# GUI Scenes
var gui_scene = preload("res://Scenes/GUI.tscn")
var gui_gameover_scene = preload("res://Scenes/GUI_GameOver.tscn")

#Nodes
var inputLagTimer = null
#var number = null 
var gui_node = null
var ads_node = null
var gui_gameover_node = null
var background_node = null
var mainWindow_node = null
var gamefield_node = null
var telosgames_logo_node = null
#Scripts
#var mainWindow_script = preload("res://Scripts/MainWindow.gd").new()
#var number_script = preload("res://Scripts/Number.gd").new()
#var ads_script = preload("res://Scripts/ADs.gd").new()
#var gamefield_script = preload("res://Scripts/GameField.gd").new()
#var background_script = preload("res://Scripts/Background.gd").new()
#var gui_script = preload("res://Scripts/GUI.gd").new()
#var gui_gameover_script = preload("res://Scripts/GUI_GameOver.gd").new()


var screenSize = Vector2(0,0)
var game_window_width_x = 500
var game_window_heigth_y = 800
var game_window_margin = 0

var game_field_width_x = 500
var game_field_margin = 0

var number_size = 80

var clickInput = false

const game_field_size = 5 

var hard_level = 3
var iq_level = 0
var new_game_numbers = 3

var is_dark = false
var curr_color_them = "light"
var main_background_color ="73947A"
var plate_background_color ="5E7478"
var menu_machground = "A5B48C"
var text_color = "363636"

var summ = 0

var sumb = 0
var kodurv = 3
var eend = 4
var koldop = 2
#var kodn

var undo_game_field = null
var is_undo_copied = false

var game_field = [[],[]]

var probability_of_num_one = 0.72
var probability_of_stone = 0.618
var probability_of_big_stone = 0.618


var randgen = RandomNumberGenerator.new()
var is_2584 = false
var is_newgame = false

var undo_best_score = 0
var undo_score = 0

var current_score = 0
var best_score = 0
var scores_dict = {"1st    ": 1134903170, "2st    ": 832040, "3st    ": 317811, "4st    ": 46368, "5st    ": 10946, "6st    ": 2584, "7st    ": 987, "8st    ": 377, "9st    ": 233, "10st  ": 144}																																																   
var fibarr = [2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811, 514229, 832040, 1346269, 2178309, 3524578, 5702887, 9227465, 14930352, 24157817, 39088169, 63245986, 102334155, 165580141, 267914296, 433494437, 701408733, 1134903170, 1836311903, 2971215073, 4807526976, 7778742049]

var show_ads = false

var new_game = 0
var is_plaing = false
var number_rect_size = null
var number_scene_pos = 0
# for testing old value = 1, 2
var number_one = 1
var number_two = 2
var number_three = 3
var number_four = 4
var number_five = 5


func _ready():
#	print("_ready()")
	setup()


func setup_scenes():
	print("Main setup_scenes()")
#	SceneManager.set_scene(mainWindow_scene)
#	mainWindow = preload("res://Scripts/MainWindow.gd").new()
#	mainWindow.queue_resource(mainWindow_scene)
#	mainWindow.get_resource(mainWindow_scene).instance()
#	get_tree().get_root().add_scene(background_scene)
#	get_tree().get_root().get_node("/root").add_scene(gui_scene)


func setup_nodes():
	print("Main setup_nodes()")
	# сцены добавленные рукаи в облочке, добавляются как-то не так, не полностью, правильно работают только если добавлять в коде
	inputLagTimer = Timer.new()
	inputLagTimer.wait_time = 1.2
	inputLagTimer.one_shot = true
	inputLagTimer.name = "InputLagTimer"
	background_node = background_scene.instance()
	get_node("/root/MainWindow").add_child(background_node)
	background_node.set_visible(true)
	get_node("/root/MainWindow").add_child(inputLagTimer)
#   Had to change the get_node to get_tree().get_root().get_node()	
	gui_node = gui_scene.instance()
	get_node("/root/MainWindow").add_child(gui_node)
	gui_node.set_visible(false)
	gamefield_node = game_field_scene.instance()
	get_node("/root/MainWindow/GUI/VBoxC/GFContainer").add_child(gamefield_node)
#	ads_node = ads_scene.instance()
#	get_node("/root/MainWindow").add_child(ads_node)
#	ads_node.set_visible(false)
	gui_gameover_node = gui_gameover_scene.instance()
	get_node("/root/MainWindow").add_child(gui_gameover_node)
	gui_gameover_node.set_visible(false)	
	telosgames_logo_node = telosgames_logo_scene.instance()
	get_node("/root/MainWindow").add_child(telosgames_logo_node)
	telosgames_logo_node.set_visible(false)	
	show_logo()	


#func setup_signals():
##	print("setup_signals()")
##	SignalManager.connect("gui_mm_start_new_game", self, "_on_GUI_start_new_game")
##	SignalManager.connect("gui_mm_options", self, "_on_GUI_options")
##	SignalManager.connect("gui_mm_help", self, "_on_GUI_help")
#	pass


#func _process(_delta):
#	#if	new_game != 0:
#		#print("_process(_delta)")
#		#touch_input()
#		#draw_field()
#	pass


func new_game():
	print("Main new_game()")
	randgen.randomize()
	# if saved game exists load it
	# else do newgame stuff
	if Utility.check_saves() && is_newgame == false:
		Utility.load_game()		
	is_newgame = true
	background_node.set_visible(true)
	undo_game_field = null
	new_game = 1	
	is_plaing = true
	game_field = make_matrix()
	summ = 0	
	current_score = summ
	check_game_condition()
	reasign_numbers_on_gamefield()
	gui_node.set_visible(true)
	gui_node.update_score()
#	gui_gameover_node.queue_free()
#	ads_node.queue_free()
	#inputLagTimer.start()
#	get_tree().change_scene()



func game_over():
	print("Main game_over()")
	if is_plaing == true:
		print("Main DO STUFF game_over()")
		is_plaing = false
		undo_game_field = null
		new_game = 0
		gui_node.show_gameover()
	else:
		return


func show_result():
	gui_node.set_visible(false)
	gui_gameover_node.update_score()
	gui_gameover_node.set_visible(true)


func setup():
	print("Main setup()")
	randgen.randomize()
#	setup_scenes()
	setup_nodes()
	setup_window()
#	setup_signals()
#	setup_thems()	
	game_field = make_matrix()	
	call_deferred("create_gamefield_with_plates")
#	create_gamefield_with_plates()


#func setup_thems():
#	print("Main setup_thems()")


func update_score():
	current_score = summ
	if current_score != null and best_score != null:
		if current_score >= best_score:
			best_score = current_score


func setup_window():
#	print("setup_window()")
	#set_size(get_tree().get_root().get_rect().size) 
	#screenSize.x = get_viewport().get_visible_rect().size.x # Get Width
	#screenSize.y = get_viewport().get_visible_rect().size.y # Get Height
	screenSize = get_viewport().get_visible_rect().size
	print(screenSize)
	game_window_width_x = screenSize.x
	game_window_heigth_y = screenSize.y
	game_field_width_x = game_window_width_x
	number_size = game_field_width_x / game_field_size
	number_rect_size = Vector2(number_size, number_size)


func set_records_table():
	var value = 0
	var dkey = 0	
	for key in scores_dict:
		if scores_dict[key] as int >= current_score:	
			dkey = key	
		elif scores_dict[key] as int <= current_score:
			dkey = key
			value = scores_dict[key]
			scores_dict[dkey] = current_score
			return dkey


func show_logo():
	gui_node.set_visible(false)
	telosgames_logo_node.set_visible(true)



func show_ads():
	print("Main show_ads()")
	show_ads = true
#	get_node("/root/MainWindow").rewardedvideo_show()
#	get_node("/root/MainWindow").interstitial_show()
	AdsManager.showInterstitial()
#	ads_node.set_visible(true)
#	show_background_node(false)
#	background_node.set_visible(false)
#	show_ads_node(true)
#	ads_node.start_ads_timer()
	new_game()


func show_message(text):
	gui_node.show_message(text)


func colors_thems(curr_color_them : String):
	if curr_color_them == "light":
		main_background_color ="73947A"
		plate_background_color ="5E7478"
		menu_machground = "A5B48C"
		text_color = "363636"
	elif curr_color_them == "dark":
		main_background_color ="011606"
		plate_background_color ="0C1618"
		menu_machground = "1D2411"
		text_color = "9E9E9E"
	else:
		return


func undo():
	if undo_game_field != null:
		game_field = undo_game_field.duplicate(true)
		current_score = undo_score
		summ = current_score
		best_score = undo_best_score
	is_undo_copied = false	
	reasign_numbers_on_gamefield()
	update_score()


func copy_gamefield():
	#if is_undo_copied == false:
	undo_game_field = game_field.duplicate(true)
	undo_score = current_score
	undo_best_score = best_score
	is_undo_copied = true


func ai_turns(turns:int):
	for i in range(turns):
		if new_game == 1 && is_plaing == true:
			yield(get_tree().create_timer(0.01), "timeout")
			call_deferred("move_right",game_field)
			yield(get_tree().create_timer(0.01), "timeout")
			call_deferred("move_down",game_field)
			yield(get_tree().create_timer(0.01), "timeout")
			call_deferred("move_left",game_field)
			yield(get_tree().create_timer(0.01), "timeout")
			call_deferred("move_up",game_field)
		else:
			return



func make_matrix():
	#print("make_2d_array()")
	var array = []
	for colx in game_field_size:
		array.append([])
		for rowy in game_field_size:
			array[colx].append(0)
	return array



func generate_new_numbers_in_array():
	var kodn
	randgen.randomize()
	kodn = koldop
	while kodn > 0:
		var colx = randgen.randi_range(0,game_field_size - 1)
		var rowy = randgen.randi_range(0,game_field_size - 1)	
		#print(rowy, colx)
		if game_field[rowy][colx] == 0:
			kodn = kodn - 1
			var num = randgen.randf()
			if num <= probability_of_num_one:
				game_field[rowy][colx] = number_one
				summ += number_one
			else:
				game_field[rowy][colx] = number_two
				summ += number_two
	update_score()			
#			if num <= 0.5:
#				game_field[rowy][colx] = 1
#				summ += 1
#			elif num <= 0.8:
#				game_field[rowy][colx] = 2
#				summ += 2
#			else:
#				game_field[rowy][colx] = 3
#				summ += 3	


func generate_stones_in_array():
	#print("Main generate_new_numbers_in_array()")
	var kodw=1
	while kodw == 1 :
		randgen.randomize()
		#var y = int(ny * game_field_size % 1)	
		var colx = randgen.randi_range(0,game_field_size - 1)
		var rowy = randgen.randi_range(0,game_field_size - 1)	
		#print(rowy, colx)
		if game_field[rowy][colx] == 0:
			kodw=0
			var num = randgen.randf()
			if summ > 256 and summ < 260 :
				summ +=4
				if num <= probability_of_stone:
					game_field[rowy][colx] = -377
					sumb+=377
				else:
					game_field[rowy][colx] = -610
					sumb+=610
			elif summ > 990 and summ < 994 :
				summ +=4
				if num <= probability_of_big_stone:
					game_field[rowy][colx] = -987
					sumb+=987
				else:
					game_field[rowy][colx] = -1597
					sumb+=1597
			

func create_gamefield_with_plates():
	#print("create_gamefield_with_plates()")
	for colx in range(game_field_size):
		for rowy in range(game_field_size):
			var curr_number = number_scene.instance()
			#$GUI/VBoxC/GFContainer/GameField/VBoxContainer/ColorRect			
			if game_field[rowy][colx] == 0:
				curr_number.set_xy(rowy, colx)
				curr_number.setup_number_rect(number_rect_size)
				curr_number.set_empty_number()
				curr_number.position.x = number_size * colx + game_field_margin * (colx + 1)
				curr_number.position.y = number_size * rowy + game_field_margin * (rowy + 1)
			else:
	#print("draw_field() %s " % game_field[rowy][colx] as String)
				curr_number.set_xy(rowy, colx)
				curr_number.setup_number_rect(number_rect_size)
				curr_number.set_number_to_label(game_field[rowy][colx])
				curr_number.position.x = number_size * colx + game_field_margin * (colx + 1)
				curr_number.position.y = number_size * rowy + game_field_margin * (rowy + 1)
			gamefield_node.add_child(curr_number)


func reasign_numbers_on_gamefield():
	#print("reasign_numbers_on_gamefield()")
	var children_mas_number_scene = gamefield_node.get_children()
	for colx in range(game_field_size):
		for rowy in range(game_field_size):
			#curr_number.window_size = $GameField.get_viewport().get_visible_rect().size
			
			for i in range(len(children_mas_number_scene)):
				if children_mas_number_scene[i].curry_row == rowy and children_mas_number_scene[i].currx_col == colx:
					if game_field[rowy][colx] == 0: 
						children_mas_number_scene[i].set_empty_number()
					else:
						children_mas_number_scene[i].set_number_to_label(game_field[rowy][colx])	
					if children_mas_number_scene[i].number == 2584:
						call_deferred("do_graz_2584")
					if children_mas_number_scene[i].number == 7778742049:
						call_deferred("do_graz_adsoff")
	gui_node.update_score()


func check_space_for_numbers():
	#print("Main check_space_for_numbers()")
	var spaces = 0
	for colx in game_field_size:
		for rowy in game_field_size:
			if game_field[rowy][colx] == 0:
				spaces += 1
	return spaces

func check_game_condition():
	#print("fill_field_with_numbers()")
	if check_space_for_numbers() != 0:
		generate_new_numbers_in_array()
		if kodurv > 2 and check_space_for_numbers() != 0:
			#if summ > 256 and summ <260 or summ > 990 and summ < 994 :
			#generate_stones_in_array()
			generate_stones_in_array()
	elif check_space_for_numbers() == 0:
		game_over()
		return


func show_gui_node(bl:bool):
	print("Main show_gui_node")
	if gui_node != null:
		gui_node.set_visible(bl)


func show_ads_node(bl:bool):
	print("Main show_ads_node")
	if ads_node != null:
		ads_node.set_visible(bl)


func show_gameover_node(bl:bool):
	print("Main show_gameover_node")
	if gui_gameover_node != null:
		gui_gameover_node.set_visible(bl)


func show_background_node(bl:bool):
	print("Main show_background_node")
	if background_node != null:
		background_node.set_visible(bl)

func move_down(mas):
#	print("func move_down(mas)")
	randgen.randomize()
	copy_gamefield()
	var kodx1 = 1
	while kodx1 == 1:
		var sempty = 0
		for colx in range(game_field_size):			
			for rowy in range(game_field_size-1):				
				if mas[rowy][colx] != 0:
					if mas[rowy+1][colx] == 0:
						kodx1 += 1
						mas[rowy+1][colx] = mas[rowy][colx]
						mas[rowy][colx] = 0
					elif mas[rowy+1][colx] == 1:
						if mas[rowy][colx] == 1 or mas[rowy][colx] == 2:
							kodx1 += 1
							mas[rowy+1][colx] = mas[rowy+1][colx]+mas[rowy][colx]
							mas[rowy][colx] = 0
					elif abs(mas[rowy+1][colx]) > abs(mas[rowy][colx]) and abs(mas[rowy+1][colx]) <= 2 * abs(mas[rowy][colx]):
						kodx1 += 1
						mas[rowy+1][colx] = mas[rowy+1][colx]+mas[rowy][colx]
						mas[rowy][colx] = 0
					elif abs(mas[rowy+1][colx]) < abs(mas[rowy][colx]) and abs(mas[rowy][colx]) <= 2 * abs(mas[rowy+1][colx]):
						kodx1 += 1
						mas[rowy+1][colx] = mas[rowy+1][colx]+mas[rowy][colx]
						mas[rowy][colx] = 0
				else:
					sempty += 1					
		if kodx1 > 1:
			kodx1 = 1
		else:
			kodx1 = 0
			if sempty <= 4:
				koldop = 1				
			elif sempty != 0:
				koldop = 2
			check_game_condition()
			if sempty == 0:
				game_over()			
	reasign_numbers_on_gamefield()	
		   

func move_up(mas):
#	print("func move_up(mas)")
	randgen.randomize()
	copy_gamefield()
	var kodx2 = 1
	while kodx2 == 1:
		var sempty = 0
		for colx in range(game_field_size):			
			for rowy in range(1, game_field_size):				
				if mas[game_field_size-rowy][colx] != 0:
					if  mas[game_field_size-rowy-1][colx] == 0:
						kodx2+=1
						mas[game_field_size-rowy-1][colx] =  mas[game_field_size-rowy][colx]
						mas[game_field_size-rowy][colx] = 0
					elif  mas[game_field_size-rowy-1][colx] == 1:
						if  mas[game_field_size-rowy][colx] == 1 or  mas[game_field_size-rowy][colx] == 2:
							kodx2+=1
							mas[game_field_size-rowy-1][colx] = mas[game_field_size-rowy-1][colx]+ mas[game_field_size-rowy][colx]
							mas[game_field_size-rowy][colx] = 0
					elif  abs(mas[game_field_size-rowy-1][colx]) > abs(mas[game_field_size-rowy][colx])  and  abs(mas[game_field_size-rowy-1][colx]) <= 2 * abs(mas[game_field_size-rowy][colx]) :
						kodx2+=1
						mas[game_field_size-rowy-1][colx] =  mas[game_field_size-rowy-1][colx]+ mas[game_field_size-rowy][colx]
						mas[game_field_size-rowy][colx] = 0
					elif abs(mas[game_field_size-rowy-1][colx]) <  abs(mas[game_field_size-rowy][colx]) and  abs(mas[game_field_size-rowy][colx]) <= 2 * abs(mas[game_field_size-rowy-1][colx]):
						kodx2+=1
						mas[game_field_size-rowy-1][colx] =  mas[game_field_size-rowy-1][colx] +  mas[game_field_size-rowy][colx]
						mas[game_field_size-rowy][colx] = 0
				else:
					sempty += 1
		if kodx2 > 1:
			kodx2 = 1
		else:
			kodx2 = 0
			if sempty <= 4:
				koldop = 1				
			elif sempty != 0:
				koldop = 2
			check_game_condition()
			if sempty == 0:
				game_over()			
	reasign_numbers_on_gamefield()	
		   
	
func move_right(mas):
#	print("func move_right(mas)")
	randgen.randomize()
	copy_gamefield()
	var kody1 = 1
	while kody1 == 1:
		var sempty = 0
		for rowy in range(game_field_size):			
			for colx in range(game_field_size-1):				
				if mas[rowy][colx] != 0:
					if mas[rowy][colx+1] == 0:
						kody1+=1
						mas[rowy][colx+1] = mas[rowy][colx]
						mas[rowy][colx] = 0
					elif mas[rowy][colx+1] == 1:
						if mas[rowy][colx] == 1 or mas[rowy][colx] == 2:
							kody1+=1
							mas[rowy][colx+1] = mas[rowy][colx+1]+mas[rowy][colx]
							mas[rowy][colx] = 0
					elif abs(mas[rowy][colx+1]) > abs(mas[rowy][colx]) and abs(mas[rowy][colx+1]) <= 2 * abs(mas[rowy][colx]):
						kody1+=1
						mas[rowy][colx+1] = mas[rowy][colx+1]+mas[rowy][colx]
						mas[rowy][colx] = 0
					elif abs(mas[rowy][colx+1]) < abs(mas[rowy][colx]) and abs(mas[rowy][colx]) <= 2 * abs(mas[rowy][colx+1]):
						kody1+=1
						mas[rowy][colx+1] = mas[rowy][colx+1]+mas[rowy][colx]
						mas[rowy][colx] = 0	
				else:
					sempty += 1					
		if kody1 > 1:
			kody1 = 1
		else:
			kody1 = 0
			if sempty <= 4:
				koldop = 1				
			elif sempty != 0:
				koldop = 2
			check_game_condition()
			if sempty == 0:
				game_over()			
	reasign_numbers_on_gamefield()	


func move_left(mas):
#	print("func move_left(mas)")
	randgen.randomize()
	copy_gamefield()
	var kody2 = 1
	while kody2 == 1:
		var sempty = 0
		for rowy in range(game_field_size):			
			for colx in range(1, game_field_size):				
				if mas[rowy][game_field_size-colx] != 0:
					if mas[rowy][game_field_size-colx-1]== 0:
						kody2+=1
						mas[rowy][game_field_size-colx-1] =  mas[rowy][game_field_size-colx]
						mas[rowy][game_field_size-colx] = 0
					elif mas[rowy][game_field_size-colx-1]  == 1:
						if  mas[rowy][game_field_size-colx] == 1 or  mas[rowy][game_field_size-colx] == 2:
							kody2+=1
							mas[rowy][game_field_size-colx-1] = mas[rowy][game_field_size-colx-1] + mas[rowy][game_field_size-colx]
							mas[rowy][game_field_size-colx] = 0
					elif  abs(mas[rowy][game_field_size-colx-1]) >  abs(mas[rowy][game_field_size-colx]) and  abs(mas[rowy][game_field_size-colx-1]) <= 2 * abs(mas[rowy][game_field_size-colx]) :
						kody2+=1
						mas[rowy][game_field_size-colx-1] = mas[rowy][game_field_size-colx-1] + mas[rowy][game_field_size-colx]
						mas[rowy][game_field_size-colx] =  0
						
					elif  abs(mas[rowy][game_field_size-colx-1]) < abs(mas[rowy][game_field_size-colx]) and  abs(mas[rowy][game_field_size-colx]) <= 2 * abs(mas[rowy][game_field_size-colx-1]) :
						kody2+=1
						mas[rowy][game_field_size-colx-1] = mas[rowy][game_field_size-colx-1] + mas[rowy][game_field_size-colx]
						mas[rowy][game_field_size-colx] =  0
				else:
					sempty += 1
		if kody2 > 1:
			kody2 = 1
		else:
			kody2 = 0
			if sempty <= 4:
				koldop = 1				
			elif sempty != 0:
				koldop = 2
			check_game_condition()
			if sempty == 0:
				game_over()			
	reasign_numbers_on_gamefield()	
	   
