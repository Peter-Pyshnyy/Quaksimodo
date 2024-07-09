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
	F.DIV: [Q.ABL_1, Q.ANST, Q.AER],
	F.TRG: [Q.ABL_1],
	F.NST: [Q.X, Q.ABL_1, Q.ANST, Q.AER],
}

const enum2str = {
	F.LIN: "linear",
	F.QDR: "quadratic",
	F.CUB: "cubic",
	F.QDR_S: "quadratic",
	F.CUB_X: "quadratic",
}

const enum2str_comp = {
	F.MLT: "multiplied",
	F.DIV: "divided",
	F.TRG: "trigonometric",
	F.NST: "nested",
}

var f_pool = {}
var fn_type:F
var chosen = [] #picked questions
var fn:MFunc

func _init(lvl:int):
	match lvl:
		1: f_pool = lvl1
		2: f_pool = lvl2
		3: f_pool = lvl3
		_: 
			print("WRONG LVL")
			return
	
	fn_type = f_pool.keys().pick_random()
	
	#if less than 3 possible question -> pick all
	if f_pool[fn_type].size() < 3:
		chosen = f_pool[fn_type]
		return
	
	#ammount of questions per function
	var q_ammount = randi_range(1,3)
	
	while chosen.size() < q_ammount:
		var temp = f_pool[fn_type].pick_random()
		if !chosen.has(temp):
			chosen.append(temp)
	
	if enum2str.keys().has(fn_type):
		fn = MFunc.new(enum2str[fn_type])
	else:
		fn = MFunc_comp.new(enum2str_comp[fn_type])
	
	
	
	
	
