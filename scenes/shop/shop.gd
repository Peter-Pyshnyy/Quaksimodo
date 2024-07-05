extends Node2D

@onready var item_list = $ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_item_list_item_clicked(index, at_position, mouse_button_index):
	for i in 5:
		item_list.set_item_icon(i,load(str("res://assets/shop_scene/item_hidden_",i,".png")))
	
	item_list.set_item_icon(index,load(str("res://assets/powerups/item_", index, ".png")))
