class_name Question

extends Node

enum F {LIN, QDR, QDR_S, CUB, CUB_X, MLT, DIV, TRG, NST}
		#Linear, Quadratisch, Quadratisch mit Schnitt, Kubisch mit Extrema,
		#Multipliziert, Geteilt, Trigonometrisch, Verschachtelt

enum Q {TYP, X, NS, ABL_1, ABL_2, ANST, SCHNITT, SCHEITEL, COMP, EXTR, WP, AER}
		#Funktionstyp, Wert an Stelle x, Nullstelle, Ableitung, Anstieg, 
		#Schnitt, Scheitel, Gestaucht?, Extremstellen, Wendepunkt, Änderungsrate

const lvl1 = {
	F.LIN: [Q.TYP, Q.X, Q.NS],
	F.QDR: [Q.TYP, Q.X, Q.ABL_1, Q.ABL_2, Q.COMP, Q.ANST],
	F.CUB: [Q.TYP, Q.X, Q.ABL_1, Q.ABL_2,Q.ANST],
}

const lvl2 = {
	F.LIN: [Q.NS, Q.SCHNITT],
	F.QDR: [Q.X, Q.ABL_1, Q.ANST, Q.NS, Q.SCHEITEL],
	F.QDR_S: [Q.X, Q.ABL_1, Q.ANST, Q.SCHEITEL, Q.SCHNITT],
	F.CUB: [Q.X, Q.ABL_1, Q.ABL_2,Q.ANST],
	F.CUB_X: [Q.ABL_1, Q.ABL_2, Q.ANST, Q.EXTR, Q.WP],
}

const lvl3 = {
	F.QDR: [Q.ANST, Q.NS, Q.SCHEITEL],
	F.QDR_S: [Q.ANST, Q.SCHEITEL, Q.SCHNITT],
	F.CUB_X: [Q.ABL_1, Q.ABL_2, Q.ANST, Q.EXTR, Q.WP],
	F.MLT: [Q.X, Q.ABL_1, Q.ANST, Q.AER],
	F.DIV: [Q.ABL_1],
	F.TRG: [Q.ABL_1],
	F.NST: [Q.X, Q.ABL_1, Q.ANST, Q.AER],
}

const enum2str = {
	F.LIN: "linear",
	F.QDR: "quadratic",
	F.CUB: "cubic",
	F.QDR_S: "quadratic",
	F.CUB_X: "cubic_x",
}

const enum2str_comp = {
	F.MLT: "multiplied",
	F.DIV: "divided",
	F.TRG: "trigonometric",
	F.NST: "nested",
}

const extra_int = [Q.X, Q.ANST, Q.WP]


var handlers = {
	Q.TYP: handle_typ,
	Q.X: handle_x, #
	Q.NS: handle_ns,
	Q.ABL_1: handle_abl_1,
	Q.ABL_2: handle_abl_2,
	Q.ANST: handle_anst, #
	Q.SCHNITT: handle_schnitt, #
	Q.SCHEITEL: handle_extr,
	Q.COMP: handle_comp,
	Q.EXTR: handle_extr,
	Q.WP: handle_wp,
	Q.AER: handle_aer #
}

var f_pool = {}
var fn_type:F
var question_pool = {}
var extras = {}
var fn:MFunc
var answers = {}

func _init(lvl:int):
	match lvl:
		1: f_pool = lvl1
		2: f_pool = lvl2
		3: f_pool = lvl3
		_: 
			print("WRONG LVL")
			return
	
	fn_type = f_pool.keys().pick_random()
	
	if enum2str.keys().has(fn_type):
		fn = MFunc.new(enum2str[fn_type])
	else:
		fn = MFunc_comp.new(enum2str_comp[fn_type])
	
	#in case of a Schnitt question, the pair fn will be stored in extras
	if fn_type == F.QDR_S:
		var temp:MFunc = MFunc.new("linear")
		extras[Q.SCHNITT] = temp
		fn = fn.add_fn(temp)
		
	if f_pool == lvl2 && fn_type == F.LIN:

		var temp:MFunc = fn.add_fn(MFunc.new("quadratic"))
		extras[Q.SCHNITT] = temp
	
	#if less than 3 possible question -> pick all
	if f_pool[fn_type].size() < 3:
		for n in f_pool[fn_type].size():
			var question = f_pool[fn_type][n]
			
			question_pool[question] = handlers[question].call()
		return
	
	#ammount of questions per function
	var q_ammount = randi_range(1,3)
	
	while question_pool.keys().size() < q_ammount:
		var question = f_pool[fn_type].pick_random()
		if !question_pool.has(question):
				
			question_pool[question] = handlers[question].call()


func handle_typ():
	return fn.type

func handle_x():
	extras[Q.X] = randi_range(-2,2)
	return fn.value_at(extras[Q.X])

func handle_ns():
	return fn.calc_zero()

func handle_abl_1():
	return fn.calc_deriv()

func handle_abl_2():
	return fn.calc_deriv(2)

func handle_anst():
	extras[Q.ANST] = randi_range(-2,2)
	return fn.slope_at(extras[Q.ANST])

func handle_schnitt():
	var temp:MFunc;
	if fn.highest_exp == 2:
		temp = fn.add_fn(extras[Q.SCHNITT].inverse_fn())
	else:
		temp = extras[Q.SCHNITT].add_fn(fn.inverse_fn())
	
	return temp.calc_zero()

func handle_comp():
	return fn.is_compressed()

func handle_extr():
	return fn.calc_extremes()

func handle_wp():
	return fn.calc_turning_p()

func handle_aer():
	extras[Q.AER] = randi_range(-2,2)
	return fn.calc_rate_of_change(extras[Q.AER])
