extends Node2D

@onready var item_list = $ItemList
@onready var lbl_sold_0 = $lbl_sold_0
@onready var lbl_sold_1 = $lbl_sold_1
@onready var lbl_sold_2 = $lbl_sold_2
@onready var lbl_thanks = $lbl_thanks
@onready var lbl_sum = $lbl_sum
@onready var lbl_balace = $lbl_balance
@onready var lbl_item_name = $lbl_item_name
@onready var lbl_item_price = $lbl_item_price
@onready var rt_description = $rt_description
@onready var btn_buy = $btn_buy
@onready var btn_reset = $btn_reset
@onready var btn_dmg = $btn_dmg
@onready var btn_hp = $btn_hp
@onready var btn_back = $btn_back


const DESCRIPTIONS = {
	PlayerDataAl.POWER_UPS.MAP:
		"Effekt: Karte wird aufgedeckt",
	PlayerDataAl.POWER_UPS.FORK:
		"Effekt: Frosch macht mehr Schaden",
	PlayerDataAl.POWER_UPS.BUCKET:
		"Effekt: Frosch nimmt reduzierten Schaden",
	PlayerDataAl.POWER_UPS.TRIANGLE:
		"Effekt: nächste falsche Antwort macht keinen Schaden",
	PlayerDataAl.POWER_UPS.FLIES:
		"Effekt: Frosch heilt sicht",
	PlayerDataAl.POWER_UPS.TOOTH:
		"Effekt: beantwortet alle aktuelle Fragen (außer bei Kisten)",
	PlayerDataAl.POWER_UPS.NONE:
		""
} 

const NAMES = {
	PlayerDataAl.POWER_UPS.MAP:
		"Stadtplan (passiv)",
	PlayerDataAl.POWER_UPS.FORK:
		"Rostige Gabel (passiv)",
	PlayerDataAl.POWER_UPS.BUCKET:
		"Plastikeimer (passiv)",
	PlayerDataAl.POWER_UPS.TRIANGLE:
		"2x Geodreieck (verwendbar)",
	PlayerDataAl.POWER_UPS.FLIES:
		"2x Mittagspause (verwendbar)",
	PlayerDataAl.POWER_UPS.TOOTH:
		"Wolfram-Zahn (verwendbar)",
	PlayerDataAl.POWER_UPS.NONE:
		""
} 

const PRICES = {
	PlayerDataAl.POWER_UPS.MAP: 5,
	PlayerDataAl.POWER_UPS.FORK: 5,
	PlayerDataAl.POWER_UPS.BUCKET:4,
	PlayerDataAl.POWER_UPS.TRIANGLE: 3,
	PlayerDataAl.POWER_UPS.FLIES: 2,
	PlayerDataAl.POWER_UPS.TOOTH: 2,
	PlayerDataAl.POWER_UPS.NONE: 0
}

var cart:Cart
var is_item_selected:bool
var sum:int
var balance:int

# Called when the node enters the scene tree for the first time.
func _ready():
	cart = Cart.new()
	sum = 0
	balance = PlayerDataAl.money
	lbl_balace.text = str(balance)
	btn_hp.get_child(1).text = str(cart.hp_inc)
	btn_dmg.get_child(1).text = str(cart.dmg_inc)
	is_item_selected = false
	
	
	#redundant, change
	for i in 6:
		item_list.set_item_icon(i,load(str("res://assets/shop_scene/item_hidden_",i,".png")))
	btn_buy.visible = false
	btn_reset.visible = false
	rt_description.text = ""
	lbl_item_name.text = ""
	lbl_item_price.text = ""
	update_sum()
	
	#can't buy already obtained passives
	for passive in PlayerDataAl.passives_dict.keys():
		if PlayerDataAl.passives_dict[passive]:
			match passive:
				0:
					lbl_sold_0.visible = true
				1: 
					lbl_sold_1.visible = true
				2:
					lbl_sold_2.visible = true
			
			item_list.set_item_disabled(passive, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	item_selected()
	for i in DESCRIPTIONS.keys().size():
		item_list.set_item_icon(i,load(str("res://assets/shop_scene/item_hidden_",i,".png")))
	
	if cart.item == index:
		sum -= PRICES[cart.item]
		cart.item = PlayerDataAl.POWER_UPS.NONE
		rt_description.text = ""
		lbl_item_name.text = ""
		lbl_item_price.text = ""
		update_sum()
		
		if sum == 0:
			_ready()
		return
	
	#change price
	sum -= PRICES[cart.item]
	cart.item = index
	sum += PRICES[cart.item]
	
	item_list.set_item_icon(index,load(str("res://assets/powerups/item_", index, ".png")))
	rt_description.text = DESCRIPTIONS[index]
	lbl_item_name.text = NAMES[index]
	lbl_item_price.text = str("Preis: ", PRICES[index], "G")
	update_sum()
	
	

#enables the buy and reset buttons
func item_selected():
	if !is_item_selected:
		btn_buy.visible = true
		btn_reset.visible = true
		is_item_selected = true


func update_sum():
	lbl_sum.text = str(sum)
	
	if sum > balance:
		btn_buy.visible = false
		lbl_sum.add_theme_color_override("font_color", Color(0.894, 0.114, 0.236))
	else:
		if is_item_selected:
			btn_buy.visible = true
			
		lbl_sum.add_theme_color_override("font_color", Color(0.934, 0.948, 0.933))


func _on_btn_dmg_mouse_entered():
	btn_dmg.get_child(0).texture = load(str("res://assets/shop_scene/QM_shop_arrow_focus.png"))
	btn_dmg.get_child(1).add_theme_color_override("font_color", Color.hex(0x336878))

func _on_btn_dmg_mouse_exited():
	btn_dmg.get_child(0).texture = load(str("res://assets/shop_scene/QM_shop_arrow.png"))
	btn_dmg.get_child(1).add_theme_color_override("font_color", Color(0.934, 0.948, 0.933))
	


func _on_btn_dmg_button_down():
	btn_dmg.position.y += 2
	
	item_selected()
	cart.dmg_inc += 1
	sum += 2
	btn_dmg.get_child(1).text = str(cart.dmg_inc)
	update_sum()


func _on_btn_dmg_button_up():
	btn_dmg.position.y -= 2


func _on_btn_hp_mouse_entered():
	btn_hp.get_child(0).texture = load(str("res://assets/shop_scene/QM_shop_arrow_focus.png"))
	btn_hp.get_child(1).add_theme_color_override("font_color", Color.hex(0x336878))


func _on_btn_hp_mouse_exited():
	btn_hp.get_child(0).texture = load(str("res://assets/shop_scene/QM_shop_arrow.png"))
	btn_hp.get_child(1).add_theme_color_override("font_color", Color(0.934, 0.948, 0.933))


func _on_btn_hp_button_down():
	btn_hp.position.y += 2
	
	item_selected()
	cart.hp_inc += 1
	sum += 2
	btn_hp.get_child(1).text = str(cart.hp_inc)
	update_sum()


func _on_btn_hp_button_up():
	btn_hp.position.y -= 2


func _on_btn_buy_mouse_entered():
	btn_buy.get_child(0).texture = load(str("res://assets/shop_scene/QM_shop_buy_focus.png"))


func _on_btn_buy_mouse_exited():
	btn_buy.get_child(0).texture = load(str("res://assets/shop_scene/QM_shop_buy.png"))


func _on_btn_buy_button_down():
	btn_buy.position.y += 2


func _on_btn_buy_button_up():
	btn_buy.position.y -= 2
	
	PlayerDataAl.max_health = cart.hp_inc
	PlayerDataAl.player_damage = cart.dmg_inc
	PlayerDataAl.money -= sum
	PlayerDataAl.activate_power_up(cart.item)
	MapAutoload.active_sqr.completed = true
	MapAutoload.active_sqr.variation = cart.item
	
	lbl_thanks.visible = true
	
	await get_tree().create_timer(1).timeout
	
	get_tree().change_scene_to_file("res://scenes/map/Map.tscn")



func _on_btn_reset_mouse_entered():
	btn_reset.get_child(0).texture = load(str("res://assets/shop_scene/QM_shop_reset_focus.png"))


func _on_btn_reset_mouse_exited():
	btn_reset.get_child(0).texture = load(str("res://assets/shop_scene/QM_shop_reset.png"))


func _on_btn_reset_button_down():
	btn_reset.position.y += 2


func _on_btn_reset_button_up():
	btn_reset.position.y -= 2
	self._ready()


func _on_button_button_down():
	btn_back.position.y += 2


func _on_button_button_up():
	btn_back.position.y -= 2
	get_tree().change_scene_to_file("res://scenes/map/Map.tscn")


func _on_button_mouse_entered():
	btn_back.get_child(0).texture = load(str("res://assets/shop_scene/QM_shop_back_focus.png"))


func _on_button_mouse_exited():
	btn_back.get_child(0).texture = load(str("res://assets/shop_scene/QM_shop_back.png"))
