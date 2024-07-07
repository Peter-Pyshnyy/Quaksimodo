extends Node2D

@onready var item_list = $ItemList
@onready var lbl_dmg = $lbl_dmg
@onready var lbl_hp = $lbl_hp
@onready var lbl_sold_0 = $lbl_sold_0
@onready var lbl_sold_1 = $lbl_sold_1
@onready var lbl_sold_2 = $lbl_sold_2
@onready var lbl_thanks = $lbl_thanks
@onready var lbl_description = $lbl_description
@onready var btn_buy = $btn_buy
@onready var btn_reset = $btn_reset

const DESCRIPTIONS = {
	PlayerDataAl.POWER_UPS.MAP:
		"Map Description",
	PlayerDataAl.POWER_UPS.FORK:
		"Fork Description",
	PlayerDataAl.POWER_UPS.BUCKET:
		"Bucket Description",
	PlayerDataAl.POWER_UPS.TRIANGLE:
		"Triangle Description",
	PlayerDataAl.POWER_UPS.FLIES:
		"Flies Description",
} 

var cart:Cart
var is_item_selected:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	cart = Cart.new()
	lbl_hp.text = str(cart.hp_inc)
	lbl_dmg.text = str(cart.dmg_inc)
	is_item_selected = false
	
	for i in 5:
		item_list.set_item_icon(i,load(str("res://assets/shop_scene/item_hidden_",i,".png")))
	btn_buy.disabled = true
	btn_reset.visible = false
	lbl_description.text = ""
	
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
	for i in 5:
		item_list.set_item_icon(i,load(str("res://assets/shop_scene/item_hidden_",i,".png")))
	
	cart.item = index
	item_list.set_item_icon(index,load(str("res://assets/powerups/item_", index, ".png")))
	
	lbl_description.text = DESCRIPTIONS[index]


func _on_btn_hp_pressed():
	item_selected()
	cart.hp_inc += 1
	lbl_hp.text = str(cart.hp_inc)


func _on_btn_dmg_pressed():
	item_selected()
	cart.dmg_inc += 1
	lbl_dmg.text = str(cart.dmg_inc)
	item_selected()

#enables the buy and reset buttons
func item_selected():
	if !is_item_selected:
		btn_buy.disabled = false
		btn_reset.visible = true
		is_item_selected = true


func _on_btn_buy_pressed():
	PlayerDataAl.max_health = cart.hp_inc
	PlayerDataAl.player_damage = cart.dmg_inc
	PlayerDataAl.activate_power_up(cart.item)
	MapAutoload.active_sqr.completed = true
	MapAutoload.active_sqr.variation = cart.item
	print(MapAutoload.active_sqr.variation)
	
	btn_buy.disabled = true
	lbl_thanks.visible = true
	
	await get_tree().create_timer(1).timeout
	
	get_tree().change_scene_to_file("res://scenes/map/Map.tscn")
	DialogueManager.show_dialogue_balloon(load("res://dialogue/tutorial.dialogue"),"storch_battle_victory")


func _on_btn_reset_pressed():
	self._ready()
