extends Node

signal lvlNothing
signal lvlFlamel
signal uncoverIngr(ingredient: String, last: bool)
signal upsane
signal deactivate(reactivate: bool) #used to deactivate certain elements
signal populated
signal modulate
signal toolTrans(tool: globalVariables.tool, held: bool)
signal drop(re: bool) #used to drop certain tools specifically
signal getRandomUnrevealed
signal returnUnrevealed(ingredient: String, position: Vector2)
signal flagging(flag: String)
signal freeze
signal doorstoppers(f: Node2D, l: Node2D, r: Node2D, e: Node2D)

signal getAim(target: int)
signal returnAim(target: Node)

signal expresso(pressed: Signal)
signal late()
signal potionD(type: int)

signal lvlUp(lvl: String) # used for the tutorial to give the player messages

