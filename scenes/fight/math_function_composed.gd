#composed
class_name MFunc_comp

extends Node

var a:MFunc
var b:MFunc
var type:String
var is_trig = false
var trig = {}
var exp = 1


func _init(type:String = "multiplied", a:MFunc = null, b:MFunc = null):
	self.type = type
	self.a = a
	self.b = b
	match type:
		"multiplied":
			create_multiplied_fn()
		"divided":
			create_divided_fn()
		"trigonometric":
			create_trig_fn()
		"nested":
			create_nested_fn()
		"nested_nice":
			create_nested_fn_with_nice_value()
		_:
			print("INVALID FUNCTION TYPE")
			return

func create_multiplied_fn():
	type = "multiplied"
	if a == null:
		a = MFunc.new()
	if b == null:
		b = MFunc.new()


func create_divided_fn():
	print(a)
	type = "divided"
	if a == null:
		a = MFunc.new("empty")
		a.add_coeff(randi_range(2,3))
		a.add_coeff(0, randi_range(-10,10))
	if b == null:
		b = MFunc.new("empty")
		b.add_coeff(randi_range(4,7))
		b.add_coeff(0,randi_range(-2,2))

func create_trig_fn():
	is_trig = true
	if a == null:
		a = MFunc.new("linear")
	var temp:float
	var fn:String = "sin"

	if range(3).pick_random() == 1:
		temp = [-0.25, -0.5, -0.75, 0.25, 0.5, 0.75].pick_random()
	
	while(temp == 0):
		temp = randi_range(-10,10)
	
	if (randf_range(0,1) == 0):
		fn = "cos"
		
	trig[fn] = temp


func create_nested_fn():
	if a == null:
		a = MFunc.new()
	exp = randi_range(2,5)

func create_nested_fn_with_nice_value():
	type = "nested"
	if a == null:
		a = MFunc.new()
	for n in a.degrees_sorted:
		if n == a.highest_exp: continue
		a.coefficients[n] = round(a.coefficients[n])


func _to_string():
	match type:
		"multiplied":
			return str("f(x) = (" ,a._to_string(true),") ⋅ (", b._to_string(true), ")")
		"divided":
			return str("f(x) = (", a._to_string(true), ") / (", b._to_string(true), ")")
		"trigonometric":
			return str("f(x) = ", trig.values()[0], " ⋅ ", trig.keys()[0], "(", a._to_string(true), ")") 
		"nested":
			return str("f(x) = (", a._to_string(true), ")", MFunc.exponents[str(exp)])
		_:
			return "WRONG FUNCTION TYPE"

func value_at(x:int) -> float:
	match type:
		"multiplied":
			return a.value_at(x) * b.value_at(x)
		"divided":
			print("divided not suited for value_at")
			return 0
		"trigonometric":
			print("trigonometric not suited for value_at")
			return 0
		"nested":
			var temp:MFunc = a
			for n in exp-1:
				temp = temp.multiply_fn(a)
			
			print(temp)
			return temp.value_at(x)
		_:
			print("WRONG FUNCTION TYPE")
			return 0

func calc_deriv():
	match type:
		"multiplied":
			#Produktregel
			var a1 = a.calc_deriv()
			var b1 = b.calc_deriv()
		
			var temp1 = a1.multiply_fn(b)
			var temp2 = b1.multiply_fn(a)
		
			return temp1.add_fn(temp2)
		"divided":
			#Quotientenregel
			var a1 = a.calc_deriv()
			var b1 = b.calc_deriv()
			
			var temp1 = a1.multiply_fn(b)
			var temp2 = b1.multiply_fn(a)
			var temp3 = temp1.add_fn(temp2.inverse_fn())
			print("temp3:", temp3)
			var temp4 = b.multiply_fn(b)
			return MFunc_comp.new("divided", temp3, temp4)
			