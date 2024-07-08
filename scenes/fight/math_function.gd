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

var coefficients = {}
var degrees_sorted = []
var max_coeffs = 5
var highest_exp = 0

#degree = highest degree, coeffs = number of coefficients
func _init(type:String):
	match type:
		"linear":
			create_lin_fn()
		_:
			return
	
	#if f(x) = 0 repeat
	if coefficients.keys().is_empty(): _init(type)

func add_coeff(degree:int, coeff:float = 1.):
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
				result += str(" + ", coefficients[degree], "x", num_to_exp(degree))
			else:
				result += str(" + ", coefficients[degree])
	
	regex.compile(r" \+ -")
	#var temp = result.substr(3, result.length() - 3) #removes first " + 
	result = regex.sub(result.substr(3, result.length() - 3), " - ", true)
	

	return "f(x) = " + result

func create_lin_fn():
	var a:int = 0
	
	#so that a != 0
	while(a == 0 || high_primes.has(abs(a))):
		a = randi_range(-25,25)
	
	var devider:int = 1
	
	#picks random out of 3 deviders, if nothing picked = devider 1
	for n in 3:
		var temp = pleasant_dividers.keys().pick_random()
		if (pleasant_dividers[temp].has(a)):
			devider = temp
	
	var b:float = float(a) / devider * randi_range(1,10) 
	add_coeff(1,a)
	add_coeff(0,b)

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
		return float(round(temp/coefficients[degrees_sorted[0]]*100))/100
