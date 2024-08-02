extends Node

var sanity: int = 100
var lostsanity: int = 0
var uncoveredIngred: Dictionary = {
	"Nothing" = 0, 
	"Herb1" = 0,
	"Herb2" = 0,
	"Herb3" = 0,
	"Shroom1" = 0,
	"Shroom2" = 0,
	"Shroom3" = 0,
	"Salt1" = 0,
	"Salt2" = 0,
	"Salt3" = 0,
	"Flamel" = 0,}
var uncovered: int = 0
var size: int
var n: int 
var level: Dictionary = {
	"Herb" = 0, 
	"Shroom" = 0, 
	"Salt" = 0, 
	"Shadow" = 0}
var lvlUP: Dictionary = {
	"Nothing" = 21, 
	"1" = 5,
	"2" = 15,
	"3" = 30,
	"4" = 9999,
	"5" = 9999,}
var lvl1: String = "Herb"

var ingredientMult: float = 1
var ingredientStack: Dictionary = {
	"Herb1" = 3,
	"Herb2" = 0,
	"Herb3" = 0,
	"Shroom1" = 3,
	"Shroom2" = 0,
	"Shroom3" = 0,
	"Salt1" = 3,
	"Salt2" = 0,
	"Salt3" = 0,
	"Flamel" = 1,}
