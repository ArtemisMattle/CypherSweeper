extends Node

signal lvlNothing
signal lvlFlamel
signal uncoverIngr(ingredient: String, last: bool)
signal upsane
signal deactivate(reactivate: bool) #used to deactivate certain elements
signal populated
signal toolTrans(tool)
signal getRandomUnrevealed
signal returnUnrevealed(ingredient: String, position: Vector2)
signal flagging(flag: String)

signal getAim(target: int)
signal returnAim(target: Node)
