extends Node

signal lvlNothing
signal lvlFlamel
signal uncoverIngr(ingredient: String, last: bool)
signal upsane
signal deactivate(reactivate: bool) #used to deactivate certain elements
signal populated
signal modulate
signal toolTrans(tool: globalVariables.tool)
signal getRandomUnrevealed
signal returnUnrevealed(ingredient: String, position: Vector2)
signal flagging(flag: String)

signal getAim(target: int)
signal returnAim(target: Node)

signal expresso(pressed: Signal)
signal late()

signal lvlUp(lvl: int) # used for the tutorial to give the player messages
