class_name MFunc

extends Node

const exponents = {
		"0": '⁰',
		"1": '¹',
		"2": '²',
		"3": '³',
		"4": '⁴',
		"5": '⁵',
		"6": '⁶',
		"7": '⁷',
		"8": '⁸',
		"9": '⁹'
	}

const pleasant_dividers = {
	2: [1,2,3,4,5,6,8,10,12,14,16,18,20,22,24,25],
	3: [6,9,18],
	4: [8,16,24],
	5: [10,20]
}

#are not used in functions
const high_primes = [11, 13, 17, 19, 23]

#var coefficients = [0,0,0,0]

var type
var coefficients = {}
var degrees_sorted = []
var max_coeffs = 5
var highest_exp = 0

#degree = highest degree, coeffs = number of coefficients
func _init(type:String = "random"):
	self.type = type
	
	match type:
		"linear":
			create_lin_fn()
			if coefficients.keys().is_empty(): _init(type)
		"quadratic":
			create_quadr_fn()
			if coefficients.keys().is_empty(): _init(type)
		"random":
			match randi_range(0,2):
				0:
					create_lin_fn()
				1:
					create_quadr_fn()
			if coefficients.keys().is_empty(): _init(type)
		"empty":
			return
		_:
			print("WRONG FUNCTION NAME")
			return
	
	#if f(x) = 0 repeat
	

func add_coeff(degree:int, coeff:float = 1.):
	if coeff == 0: return
	if degree < 0: return
	if coefficients.has(degree): return
	if degree > highest_exp:
		highest_exp = degree
	
	coefficients[degree] = coeff
	degrees_sorted.push_back(degree)
	degrees_sorted.sort()
	degrees_sorted.reverse()

func num_to_exp(n:int):
	if n == 1: return ""
	
	var result:String = ""
	var n_str:String = str(n)
	for char in n_str:
		result += exponents[char]
	
	return result 

func _to_string():
	var regex = RegEx.new()
	var result:String = ""
	
	for degree in degrees_sorted:
		if (coefficients[degree] != 0):
			if (degree != 0):
				if (coefficients[degree] == 1):
					result += str(" + x", num_to_exp(degree))
				else:
					result += str(" + ", coefficients[degree], "x", num_to_exp(degree))
			else:
				result += str(" + ", coefficients[degree])
	
	regex.compile(r" \+ -")
	#var temp = result.substr(3, result.length() - 3) #removes first " + 
	result = regex.sub(result.substr(3, result.length() - 3), " - ", true)
	

	return "f(x) = " + result

func create_lin_fn():
	var a:float = 0
	var b:float = 0
	#1/4 chance to get a 1 > abs(a)
	if range(4).pick_random() == 1:
		a = [-0.25, -0.5, -0.75, 0.25, 0.5, 0.75].pick_random()
	
	if a != 0:
		while(b == 0):
			b = a * randi_range(-10,10) 
		add_coeff(1,a)
		add_coeff(0,b)
		return
		
	#so that a != 0
	while(a == 0 || high_primes.has(abs(a))):
		a = randi_range(-25,25)
	
	var divider:int = 1
	
	#picks random out of 4 dividers, if nothing picked = divider 1
	for n in 4:
		var temp = pleasant_dividers.keys().pick_random()
		if (pleasant_dividers[temp].has(abs(int(a)))):
			divider = temp
	
	while(b == 0):
		b = float(a) / divider * randi_range(-10,10) 
		
	add_coeff(1,a)
	add_coeff(0,b)


func create_quadr_fn():
	var jm = JM.new()
	var json = JSON.new()
	var functions_arr = jm.load_json_file("res://data/functions.json")["quadratic"].keys()
	
	var error = json.parse(functions_arr.pick_random())
	if error == OK:
		var function = json.data
		add_coeff(2,1)
		add_coeff(1,function[1])
		add_coeff(0,function[2])
		
	else:
		print("Unexpected data")

	
#rounds after the decimal point
func round_place(num:int, places:int = 2):
	return (round(num*pow(10,places))/pow(10,places))

#only for linear and quadratic functions
func calc_zero():
	if highest_exp > 2:
		print("nur lineare und quadratische Fkt")
		return
	
	#linear
	if highest_exp < 2:
		var temp:float = coefficients[degrees_sorted[1]] * -1
		return [float(round(temp/coefficients[degrees_sorted[0]]*100))/100]
		
	#quadratic
	if highest_exp == 2:
		var x1:float
		var x2:float
		var p:float = coefficients[degrees_sorted[1]] 
		var q:float = coefficients[degrees_sorted[2]]
		
		#pq
		x1 = -(p/2)+sqrt(pow((p/2) , 2) - q)
		x2 = -(p/2)-sqrt(pow((p/2) , 2) - q)
		
		if x1 == x2:
			return [x1]
			
		return [x1, x2]

func calc_deriv(n:int = 1) -> MFunc:
	var fn = self
	var temp:MFunc
	
	for i in n:
		temp = MFunc.new("empty")
		for j in fn.degrees_sorted:
			temp.add_coeff(j-1,fn.coefficients[j]*j)
		
		fn = temp
	
	return temp
