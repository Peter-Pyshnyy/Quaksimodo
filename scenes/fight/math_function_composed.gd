#composed
class_name MFunc_comp

extends Node

var a:MFunc
var b:MFunc
var type:String		


func _init(type:String = "multiplied"):
	pass # Replace with function body.


func create_multiplied_fn():
	type = "multiplied"
	a = MFunc.new()
	b = MFunc.new()


func create_divided_fn():
	type = "divided"
	a = MFunc.new()
	b = MFunc.new()

func calc_deriv():
	if type == "multiplied":
		pass #kettenregel
	else:
		pass #quotientenregel
