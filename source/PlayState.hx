package;

import engine.data.Branches;
import engine.data.Choice;
import engine.data.DialogueBlock;
import engine.data.DialogueEvent;
import engine.parsers.DialogueParser;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;

class PlayState extends FlxState
{

	var bg:FlxSprite;
	var sprites:Map<String, FlxSprite>;
	var spriteGroup:FlxTypedGroup<FlxSprite>;
	var branches:Branches;
	var dialogue:Array<DialogueBlock>;
	var curDialogue:DialogueBlock;
	var curIndex:Int = 0;
	var typingDone:Bool = true;
	var nameText:FlxText;
	var dialogueText:FlxTypeText;
	var dialogueUI:FlxTypedGroup<FlxSprite>;

	var curChoices:Array<Choice>;
	
	public function new() {
		sprites = [];
		super();
	}

	override public function create()
	{
		spriteGroup = new FlxTypedGroup<FlxSprite>();
		add(spriteGroup);
		bg = new FlxSprite();
		sprites['bg'] = bg;
		spriteGroup.add(bg);
		branches = DialogueParser.read(Assets.getText("assets/data/example/example.txt"));
		dialogue = branches['main'];
		curDialogue = dialogue[0];
		super.create();
		dialogueUI = new FlxTypedGroup<FlxSprite>();
		add(dialogueUI);
		nameText = new FlxText(20, 20, 0, curDialogue.name, 16);
		dialogueText = new FlxTypeText(nameText.x, nameText.y + 32, FlxG.width, curDialogue.text, 16);
		
		dialogueText.completeCallback = () -> {
			typingDone = true;
		}

		nameText.color = dialogueText.color = FlxColor.BLUE;

		dialogueUI.add(nameText);
		dialogueUI.add(dialogueText);

		runDialogue();
	}

	override public function update(elapsed:Float)
	{

		if (FlxG.keys.justPressed.ENTER) {
			if (!typingDone) {
				skipDialogue();
			} else if (typingDone && curIndex < dialogue.length - 1) {
				curIndex++;
				curChoices = [];
				curDialogue = dialogue[curIndex];
				runDialogue();
			}
		}
		super.update(elapsed);
	}

	inline function runDialogue() {
		nameText.text = curDialogue.name;
		dialogueText.resetText(curDialogue.text);
		dialogueText.start(curDialogue.typingSpeed);
		typingDone = false;
		manageEvents(curDialogue);
	}

	inline function skipDialogue() {
		dialogueText.skip();
		typingDone = true;
		curChoices = [];
	} 

	inline function manageEvents(dialogue:DialogueBlock) {
		for (ev in dialogue.events) {
			handleEvent(ev);
		}
	}

	function handleEvent(ev:DialogueEvent) {
		var name = ev.name;
		var args = ev.args;
		switch (name) {
			case CreateSprite:
				var id = args[0];
				var path = args[1];
				var x = Std.parseFloat(args[2]);
				var y = Std.parseFloat(args[3]);
				createSprite(id, path, x, y);
			case DeleteSprite:
				var id = args[0];
				delSprite(id);
			case ChangeSprite:
				var id = args[0];
				var path = args[1];
				changeSprite(id, path);
			case MoveSprite:
				var id = args[0];
				var x = Std.parseFloat(args[1]);
				var y = Std.parseFloat(args[2]);
				moveSprite(id, x, y);
			case PlaySound:
				FlxG.sound.play(args[0]);
			case SetBG:
				bg.loadGraphic(args[0]);
			case SetBGM:
				FlxG.sound.playMusic(args[0]);
			case SetDialogue:
				curIndex = -1;
				branches = DialogueParser.read(Assets.getText(args[0]));
				dialogue = branches[args[1]];
			case SetBranch:
				curIndex = -1;
				dialogue = branches[args[0]];
			case Choice:
				curChoices.push({
					text: args[0],
					branch: args[1]
				});
			default:
				trace('Invalid event ${name}(${args})');
		}
	}

	function createSprite(id:String, path:String, x:Float, y:Float) {
		var spr = new FlxSprite(x, y, path);
		sprites[id] = spr;
		spriteGroup.add(spr);
		trace("Created sprite " + id);
	}

	function delSprite(id:String) {
		sprites[id].kill();
		spriteGroup.remove(sprites[id]);
		sprites.remove(id);
	}

	function changeSprite(id:String, path:String) {
		sprites[id].loadGraphic(path);
	}

	function moveSprite(id:String, x:Float, y:Float) {
		sprites[id].setPosition(x, y);
	}
}
