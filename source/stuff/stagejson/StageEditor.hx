package stuff.stagejson;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
#if android
import mobile.FlxButton;
#else
import flixel.ui.FlxButton;
#end
import flixel.ui.FlxSpriteButton;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import haxe.Json;
import stuff.stagejson.Stage.StageJSON;

class StageEditor extends FlxStateCustom
{
	var stage:stuff.stagejson.Stage;
	var boyFriend:FlxSprite;
	var gf:FlxSprite;
	var dad:FlxSprite;

	var arrayText:Array<String> = ['Theres nothing lol'];
	var camGame:FlxCamera;
	var camUI:FlxCamera;
	var stageObjects:Array<FlxSprite> = [];
	var camFollow:FlxObject;
	var objectTexts:FlxTypedGroup<FlxText>;
	var textStatus:FlxText;
	var canMoveCam:Bool = false;
	var directionX:Int = 0;
	var directionY:Int = 0;
	var curObjectSelected:Int = 0;

	var UI_box:FlxUITabMenu;

	override function create()
	{
		camGame = new FlxCamera();
		camUI = new FlxCamera();
		camUI.bgColor.alpha = 0;
		camGame.bgColor = 0xFF7C7C7C; //will be gray

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camUI);

		FlxCamera.defaultCameras = [camUI];

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		objectTexts = new FlxTypedGroup<FlxText>();
		add(objectTexts);

		for (i in 0...arrayText.length)
		{
			var text:FlxText = new FlxText(10, 5, 0, "", 32);
			text.y += ((height + 20)  * i);
			text.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			text.cameras = [camUI];
			objectTexts.add(text);
		}
		textStatus = new FlxText(0, 0, FlxG.width, "", 32);
		textStatus.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		textStatus.y = (FlxG.height - textStatus.height) - 50;
		textStatus.cameras = [camUI];
		add(textStatus);

		var tabs = [
			//{name: 'Offsets', label: 'Offsets'},
			{name: 'Object', label: 'Object'},
		];
		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.cameras = [camUI];
		UI_box.resize(250, 310);
		UI_box.x = FlxG.width - 268;
		UI_box.y = (FlxG.height - UI_box.height)-296;
		UI_box.scrollFactor.set();

		setUI();
		super.create();
	}

	override function update(elapsed:Float)
	{
		// camera stuff
		if (!canMoveCam)
			textStatus.text = "[ NO CAMERA MODE ]";
		else
			textStatus.text = "[ CAMERA MODE ]";
		if(controls.ACCEPT)
			canMoveCam = !canMoveCam;

		camFollow.x += elapsed * directionX;
		camFollow.y += elapsed * directionY;
		if (canMoveCam){
			if (controls.LEFT)
				directionX = -1;
			if (controls.RIGHT)
				directionX = 1;
			if (FlxG.keys.justReleased.M){
				while (camGame.zoom < 3)
					camGame.zoom += elapsed;
			}else if (FlxG.keys.justReleased.N){
				while (camGame.zoom > 3)
					camGame.zoom -= elapsed;
			}
		}
		if (controls.LEFT)
			curObjectSelected -= 1;
		if (controls.RIGHT)
			curObjectSelected += 1;
		super.update(elapsed);
	}

	var imageInputText:FlxUIInputText;
	var positionXStepper:FlxUINumericStepper; //x
	var positionYStepper:FlxUINumericStepper; //y
	public function setUI()
	{
		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Object";
		
		imageInputText = new FlxUIInputText(15, 30, 200, 'stage/stageback', 8);
		imageInputText.focusGained = () -> FlxG.stage.window.textInputEnabled = true;
		positionXStepper = new FlxUINumericStepper(flipXCheckBox.x + 110, flipXCheckBox.y, 10, char.positionArray[0], -9000, 9000, 0);

		tab_group.add(imageInputText);
		UI_box.addGroup(tab_group);
	}
	var templateStage = '{
		"objects": [
			[
				"image":"stage/stageback", /*object asset*/
				"x": -600, /*X*/
				"y": -200, /*Y*/
				"scale": 1, /*scale x and y*/
				"scrollX": 0.9, /*scrollfactor x*/
				"scrollY": 0.9, /*scrollfactor Y*/
				"frontChars": false, /*its front of the chars*/
				"animated": false, /*its animated*/
				"animations": [],
				"blend":"none"
			],
			[
				"image":"stage/stagefront", /*object asset*/
				"x": -650, /*X*/
				"y": 600, /*Y*/
				"scale": 1.1, /*scale x and y*/
				"scrollX": 0.9, /*scrollfactor x*/
				"scrollY": 0.9, /*scrollfactor Y*/
				"frontChars": false, /*its front of the chars*/
				"animated": false, /*its animated*/
				"animations": [],
				"blend":"none"
			],
			[
				"image":"stage/stagecurtains", /*object asset*/
				"x": -500, /*X*/
				"y": -300, /*Y*/
				"scale": 0.9, /*scale x and y*/
				"scrollX": 1.3, /*scrollfactor x*/
				"scrollY": 1.3, /*scrollfactor Y*/
				"frontChars": true, /*its front of the chars*/
				"animated": false, /*its animated*/
				"animations": [],
				"blend":"none"
			]
		],
		"bfPos": [770, 450],
		"gfPos": [400, 130],
		"dadPos": [100, 100],
		"cameraZoom": 0.9,
		"curStage": "stageTemp"
	}';
	var stageMap:Map<String, FlxSprite> = [];
	function loadTemplate()
	{
		var file:StageJSON = cast haxe.Json.parse(templateStage);
		for (i in 0...file.objects.length)
		{
			for (object in stageObjects)
			{
				var obj = file.objects[0][i];
				setObject(obj.image, obj.x, obj.y, obj.scale, obj.scrollX, obj.scrollY, obj.frontChars,)
				stageObjects.remove(object);
				stageObjects.push(stageMap.);
			}
		}
	}

	// a maior funçao que eu programei ate agora
	public static function setObject(image:String, x:Float, y:Float, scale:Float, scrollX:Float, scrollY:Float, frontChars:Bool, animated:Bool, animations:Array<Array<StageJSON.Animation>>, blend:String)
	{
		var obj = new FlxSprite(x, y);
		if (animated) {
			for (i in 0...animations.length)
			{
				obj.frames = Paths.getSparrowAtlas(image);
				var name = animations[0][i].name;
				var prefix = animations[0][i].prefix;
				var fps = animations[0][i].fps;
				var indices = animations[0][i].indices;
				var offsets = animations[0][i].offsets;
				var loop = animations[0][i].loop;

				if (indices.length > 0)
					obj.animation.addByIndices(name, prefix, indices, "", fps);
				else
					obj.animation.addByPrefix(prefix, name, fps, loop);

				obj.offset.set(offsets[0], offsets[1]);
			}
		} else {
			obj.loadGraphic(Paths.image(image, 'stagejson'));
		}
		obj.setGraphicSize(Std.int(obj.width * scale));
		obj.scrollFactor.set(scrollX, scrollY);
		if(!frontChars)
			add(obj);
		else
			stage.foreground.add(obj);

		//uhhhhhhh
		switch (blend)
		{
			case "add":
				obj.blend = ADD;
			case "alpha":
				obj.blend = ALPHA;
			case "darken":
				obj.blend = DARKEN;
			case "difference":
				obj.blend = DIFFERENCE;
			case "erase":
				obj.blend = ERASE;
			case "hardlight":
				obj.blend = HARDLIGHT;
			case "invert":
				obj.blend = INVERT;
			case "layer":
				obj.blend = LAYER;
			case "lighten":
				obj.blend = LIGHTEN;
			case "multiply":
				obj.blend = MULTIPLY;
			case "overlay":
				obj.blend = OVERLAY;
			case "screen":
				obj.blend = SCREEN;
			case "shader":
				obj.blend = SHADER;
			case "substract":
				obj.blend = SUBSTRACT;
		}

		var objname:String = substring(image.indexOf('/') + 1, image.length);
		stageMap.set(objname, obj);
		return stageMap.get(objname);
	}

	var _file:FileReference;
	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved file.");
	}

	/**
		* Called when the save file dialog is cancelled.
		*/
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
		* Called if there is an error while saving the gameplay recording.
		*/
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving file");
	}

	private function saveStage()
	{
		var stageData = {
			"objects": stageJson.objects,
			"bfPos": stageJson.bfPos,
			"gfPos": stageJson.gfPos,
			"dadPos": stageJson.dadPos,
			"cameraZoom": stageJson.cameraZoom,
			"curStage": stageJson.curStage
		};
		_file = new FileReference();
		_file.addEventListener(Event.COMPLETE, onSaveComplete);
		_file.addEventListener(Event.CANCEL, onSaveCancel);
		_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file.save(data, daAnim + ".json");
	}
}