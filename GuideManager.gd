extends Node

const start_game = [
	"In \"It's An \"Honest Work\", you'll be playing as a master thief and forger who will try to replicate and steal 16 art pieces from an art gallery.",
	"The game is divided into days. You can spend a day either by making an artwork (painting or statue), scouting the gallery to see the art pieces, or execute your heist.",
	"After you've executed a heist, you will be given a score based on how you perform on the heist.",
	"Your clientele will have their own demand that you can track in the in-demand box. If you manage to steal the artwork that is in-demand, you will get more points.",
	"You have to be quick though since the demand will refresh itself every 5 days.",
	"Once you've replaced 16 of the art pieces, you will win the game!",
	"Try your best to achieve a high score and execute the heist in different ways."
]

const heist_prep = [
	"You will need to prepare before each heist. First, you will need to choose up to two artworks you've made to replace in the gallery.",
	"The type of artwork you carry will determine the type of artwork you can steal during the heist."
]

const tool_prep = [
	"To make your heist easier, a \"friend\" has also prepared you seven gadgets you can use during the heist",
	"Some of the gadgets are passively applied while other gadgets needs to be activated.",
	"You can only choose 3 gadgets to bring with you so think twice on which gadget you're bringing with you on your heist!"
]

const make_painting = [
	"Create a painting that you will swap with other paintings in the gallery.",
	"You can create a painting by choosing a color and clicking on the canvas.",
	"There are two modes you can choose, single mode will alow you to paint slowly and carefully. Continuous mode will allow you to paint quickly.",
	"To change between the two modes, click on the button below the color choices.",
	"Once you're done, click on the confirm button on top and give your new art piece a name to identify it.",
	"Try your best to replicate the artwork that is in the gallery or else your next heist will probably be more difficult than before!"
]

const make_statue = [
	"Create a statue that you will swap with the other statues in the gallery.",
	"Choose a shape that you want to add into space and move them around to create a sculpture.",
	"You can rotate the camera around by clicking on the rotate button.",
	"You can only have 8 shapes in a statue. Once you have 8 shapes, you can't add more shapes.",
	"You can also delete shapes that you have selected to create more room for other shapes.",
	"Once you're done, you can click on the confirm button and give your new sculpture a name to identify it.",
	"Try your best to replicate the statues that is being shown in the gallery! If you replace the artwork with a statue that is not similar, your next heist will probably be more difficult!"
]

const visit = [
	"Scout the gallery and take a look at different art pieces to pick the target of your heist.",
	"Move up by pressing {0}. Move down by pressing {1}. Move left by pressing {2}. And move right by pressing {3}.",
	"You can view the art pieces in a more detailed view by clicking on the {0} button to enter first person mode.",
	"You can also check the public sentiments on the art pieces that is being shown.",
	"If the public knew that the artwork has been replaced, the gallery will increase its security level and will make your heist more difficult.",
	"So make sure you create the perfect forgery and plan your heist carefully!"
]

const heist = [
	"Your objective during a heist is very simple, to steal an artwork (or two) and escape before the time runs out.",
	"Move up by pressing {0}. Move down by pressing {1}. Move left by pressing {2}. And move right by pressing {3}.",
	"You have at least one minute to steal an art piece and escape. Failure to do so will result in a game over.",
	"You will also need to avoid guards that are patrolling the area. If the security guards saw you, they will chase you and if they caught you it's a game over.",
	"Steal an art piece by holding the {0} button until the gauge above you filled up.",
	"You can also sprint by holding the {0} button. Sprinting is a great way to lose a guard when you are being chased. Just make sure you don't run to a dead end.",
	"Press or hold {0}, {1}, or {2} button to use your gadgets.",
	"Try to avoid alerting the security guards while moving around the gallery. If you're being seen too much the gallery's threat level will increase making subsequent heist more difficult.",
	"You can escape by locating the exit door in the gallery.",
	"Once you've escaped, you will be given a score based on how you perform during the heist.",
	"Try to achieve the highest score possible by being stealthy and quick."
]

const inventory = [
	"You can take a look at artworks you've made as forgery here in the inventory.",
	"You can also delete unwanted artworks by pressing on the delete button."
]

var home_idx = 0
var heist_prep_idx = 0
var tool_prep_idx = 0
var make_painting_idx = 0
var make_statue_idx = 0
var visit_idx = 0
var heist_idx = 0
var inventory_idx = 0

func _ready():
	pass # Replace with function body.

func next_guide (type = "home") :
	match type :
		"home" :
			home_idx += 1
		"heist_prep" :
			heist_prep_idx += 1
		"tool_prep" :
			tool_prep_idx += 1
		"make_painting" :
			make_painting_idx += 1
		"make_statue" :
			make_statue_idx += 1
		"visit" :
			visit_idx += 1
		"heist" :
			heist_idx += 1
		"inventory" :
			inventory_idx += 1

func get_text(type = "home") :
	var s = "fin"
	match type :
		"home" :
			if start_game.size() > home_idx :
				s = start_game[home_idx]
		"heist_prep" :
			if heist_prep.size() > heist_prep_idx :
				s = heist_prep[heist_prep_idx]
		"tool_prep" :
			if tool_prep.size() > tool_prep_idx :
				s = tool_prep[tool_prep_idx]
		"make_painting" :
			if make_painting.size() > make_painting_idx :
				s = make_painting[make_painting_idx]
		"make_statue" :
			if make_statue.size() > make_statue_idx :
				s = make_statue[make_statue_idx]
		"visit" :
			if visit.size() > visit_idx :
				s = visit[visit_idx]
				if visit_idx == 1 :
					s = s.format([
						OS.get_scancode_string(InputMap.get_action_list("ui_up")[0].scancode),
						OS.get_scancode_string(InputMap.get_action_list("ui_down")[0].scancode),
						OS.get_scancode_string(InputMap.get_action_list("ui_left")[0].scancode),
						OS.get_scancode_string(InputMap.get_action_list("ui_right")[0].scancode)
					])
				elif visit_idx == 2 :
					s = s.format([OS.get_scancode_string(InputMap.get_action_list("ui_first_person")[0].scancode)])
		"heist" :
			if heist.size() > heist_idx :
				s = heist[heist_idx]
				if heist_idx == 1 :
					s = s.format([
						OS.get_scancode_string(InputMap.get_action_list("ui_up")[0].scancode),
						OS.get_scancode_string(InputMap.get_action_list("ui_down")[0].scancode),
						OS.get_scancode_string(InputMap.get_action_list("ui_left")[0].scancode),
						OS.get_scancode_string(InputMap.get_action_list("ui_right")[0].scancode)
					])
				elif heist_idx == 4 :
					s = s.format([OS.get_scancode_string(InputMap.get_action_list("ui_interact")[0].scancode)])
				elif heist_idx == 5 :
					s = s.format([OS.get_scancode_string(InputMap.get_action_list("ui_sprinting")[0].scancode)])
				elif heist_idx == 6 :
					s = s.format([
						OS.get_scancode_string(InputMap.get_action_list("ui_tool_1")[0].scancode),
						OS.get_scancode_string(InputMap.get_action_list("ui_tool_2")[0].scancode),
						OS.get_scancode_string(InputMap.get_action_list("ui_tool_3")[0].scancode)
					])
		"inventory":
			if inventory.size() > inventory_idx :
				s = inventory[inventory_idx]
	return s


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
