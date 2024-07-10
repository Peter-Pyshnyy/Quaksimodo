#composed
class_name MFunc_comp

extends MFunc

var a:MFunc
var b:MFunc
#var type:String
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
		"empty":
			return
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
	
	if (randi_range(0,1) == 0):
		fn = "cos"
		
	trig[fn] = temp
	

func create_nested_fn():
	if a == null:
		a = MFunc.new("linear")
	else:
		if(a.coefficients.has(0)):
			a.coefficients[0] = round(a.coefficients[0])
	
	if exp == 1:
		exp = 2


func _to_string(trunc:bool = false):
	match type:
		"multiplied":
			return str("f(x) = (" ,a._to_string(true),") ⋅ (", b._to_string(true), ")")
		"divided":
			return str("f(x) = (", a._to_string(true), ") / (", b._to_string(true), ")")
		"trigonometric":
			if abs(trig.values()[0]) != 1:
				return str("f(x) = ", trig.values()[0], " ⋅ ", trig.keys()[0], "(", a._to_string(true), ")") 
			elif trig.values()[0] == -1:
				return str("f(x) = -", trig.keys()[0], "(", a._to_string(true), ")") 
			else:
				return str("f(x) = ", trig.keys()[0], "(", a._to_string(true), ")") 
		"nested":
			return str("f(x) = (", a._to_string(true), ")", MFunc.exponents[str(exp)])
		_:
			return "WRONG FUNCTION TYPE"

func equals(fn:MFunc) -> bool:
	match type:
		"multiplied":
			if (a.equals(fn.a) && b.equals(fn.b) || a.equals(fn.b) && b.equals(fn.a)):
				return true
			else:
				return false
		"divided":
			if (a.equals(fn.a) && b.equals(fn.b)):
				return true
			else:
				return false
		"trigonometric":
			var i:float = a.value_at(1)
			var j:float = fn.a.value_at(1)
			
			
			if trig.has("sin"):
				if (sin(j) != sin(i)):
					return false
			elif trig.has("cos"):
				if (cos(j) != cos(i)):
					return false
				
			if !(fn.trig.has(trig.keys()[0])):
				return false
				
			if !(fn.trig[trig.keys()[0]] == trig.values()[0]):
				return false
			else:
				return true
		"nested":
			if (a.equals(fn.a) && exp == fn.exp):
				return true
			else:
				return false
	return false
	

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
			
			return temp.value_at(x)
		_:
			print("WRONG FUNCTION TYPE")
			return 0

func calc_deriv(i:int = 1):
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
			var temp4 = b.multiply_fn(b)
			return MFunc_comp.new("divided", temp3, temp4)
		"trigonometric":
			#Kettenregel
			var temp:MFunc_comp = self.clone_trig()
			var v1 = self.a.calc_deriv().coefficients[0]
			
			if "sin" in self.trig:
				temp.trig["cos"] = v1*temp.trig["sin"]
				temp.trig.erase("sin")
			else:
				temp.trig["sin"] = v1*temp.trig["cos"]*-1
				temp.trig.erase("cos")
			
			return temp
		"nested":
			#Kettenregel
			var v1:MFunc = self.a.calc_deriv()
			v1.coefficients[0] = v1.coefficients[0]*2
			return a.multiply_fn(v1)

func slope_at(x:float) -> float:
	if type == "trigonometric" || type == "divided":
		print("no slope for trig and div")
		return 0
		
	var deriv:MFunc = calc_deriv()
	return  deriv.value_at(x)

func calc_rate_of_change(x:int) -> float:
	if type == "trigonometric" || type == "divided":
		print("no change for trig and div")
		return 0
		
	var temp:MFunc = calc_deriv()
	return temp.calc_deriv().value_at(x)

func clone_trig() -> MFunc_comp:
	var temp:MFunc_comp = MFunc_comp.new("trigonometric")
	temp.a = a.clone()
	temp.trig.erase(temp.trig.keys()[0])
	temp.trig[trig.keys()[0]] = trig.values()[0]
	return temp


func parse_polynomial_comp(expected_type:String, expression: String) -> MFunc:
	expression = expression.strip_edges(true, true)
	match expected_type:
		"multiplied":
			expression = expression.replace(") * (", ")*(")
			var parser:MFunc = MFunc.new("empty")
			if expression.contains(")*("):
				var terms = expression.split(")*(")
				terms[0] = terms[0].replace("(","")
				terms[0] = terms[0].replace(")","")
				terms[1] = terms[1].replace("(","")
				terms[1] = terms[1].replace(")","")
				var a = parser.parse_polynomial(terms[0])
				var b = parser.parse_polynomial(terms[1])
				
				return MFunc_comp.new("multiplied", a, b)
			else:
				var term = expression.replace("(", "")
				term = term.replace(")","")
				return MFunc.new("empty").parse_polynomial(term)
		"divided": #x/(x+1) ; (x+1)/x ; (x+1)/(x-1)
			var parser:MFunc = MFunc.new("empty")
			expression = expression.replace(") / (", ")/(")
			if expression.contains(")/("):
				var terms = expression.split(")/(")
				terms[0] = terms[0].replace("(","")
				terms[0] = terms[0].replace(")","")
				terms[1] = terms[1].replace("(","")
				terms[1] = terms[1].replace(")","")
				var a = parser.parse_polynomial(terms[0])
				var b = parser.parse_polynomial(terms[1])
				return MFunc_comp.new("divided", a, b)
				
			elif expression.contains(")/"):
				var terms = expression.split(")/")
				terms[0] = terms[0].replace("(","")
				terms[0] = terms[0].replace(")","")
				terms[1] = terms[1].replace("(","")
				terms[1] = terms[1].replace(")","")
				var a = parser.parse_polynomial(terms[0])
				var b = parser.parse_polynomial(terms[1])
				return MFunc_comp.new("divided", a, b)
				
			elif expression.contains("/("):
				var terms = expression.split("/(")
				terms[0] = terms[0].replace("(","")
				terms[0] = terms[0].replace(")","")
				terms[1] = terms[1].replace("(","")
				terms[1] = terms[1].replace(")","")
				var a = parser.parse_polynomial(terms[0])
				var b = parser.parse_polynomial(terms[1])
				return MFunc_comp.new("divided", a, b)
		"trigonometric":
			var parser:MFunc = MFunc.new("empty")
			var terms = expression.split("(")
			var a = parser.parse_polynomial(terms[1].replace(")",""))
			var coeff = 1
			var fn:String = "sin"
			if terms[0].contains("cos"):
				fn = "cos"
			
			var i = terms[0].find(fn)
			if i != 0:
				var temp:String = terms[0].replace("*","").erase(i,3)
				temp = temp.strip_edges(true, true)
				if temp == "-":
					coeff = -1
				else:
					if temp.contains(("/")):
						var n = float(temp.get_slice("/", 0))/float(temp.get_slice("/", 1))
						coeff = round_place(n)
					else:
						coeff = float(temp)
			
			var result:MFunc_comp = MFunc_comp.new("trigonometric", a)
			result.trig.erase(result.trig.keys()[0])
			result.trig[fn] = coeff
			
			return result
		
		"nested":
			var terms = expression.split(")^")
			var exp = float(terms[1])
			terms[0] = terms[0].replace("(","")
			var a = MFunc.new("empty").parse_polynomial(terms[0])
			
			var result = MFunc_comp.new('nested', a);
			result.exp = exp
			
			return result
			
	return MFunc_comp.new("empty")

