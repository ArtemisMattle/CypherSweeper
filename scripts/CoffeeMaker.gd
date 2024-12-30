extends CanvasLayer

var coffeegauge:ProgressBar;
var coffee:TextureButton;
var caffMax=3;
var caff=0;
var coffeerdy=0;


# Called when the node enters the scene tree for the first time.
func _ready():
	coffeegauge=get_child(0).get_child(0);
	coffee=get_child(0).get_child(1);
	coffeegauge.max_value=caffMax;
	signalBus.expresso.connect(brew)

func bean():
	caff+=1;
	if caff==caffMax:
		caff=0;
		if coffeerdy==0:
			coffeerdy=1;
			rdycoff()
		else:
			coffeerdy+=1;
		
	coffeegauge.value=caff;

func rdycoff():
	if coffeerdy>0:
		coffee.set_position(Vector2(57,coffee.position.y));
		
func drinkCoff():
	coffeerdy-=1;
	if globalVariables.sanity<=70:
		globalVariables.sanity+=30;
	elif globalVariables.sanity<100:
		globalVariables.sanity=100;
	else:
		coffeerdy+=1;
	if coffeerdy>0:
		rdycoff();
	else:
		coffee.set_position(Vector2(-60,coffee.position.y));
	signalBus.late.emit()

func brew(sig: Signal) -> void:
	sig.connect(bean)
