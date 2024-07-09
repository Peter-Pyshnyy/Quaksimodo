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

func _init(lvl:int):
	pass
