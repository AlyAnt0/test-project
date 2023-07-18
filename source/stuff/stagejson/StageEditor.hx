package stuff.stagejson;

//flixel libs
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
import flixel.math.FlxPoint;
#if android
import mobile.FlxButton;
#else
import flixel.ui.FlxButton;
#end
import flixel.ui.FlxSpriteButton;
//openfl libs
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.utils.Assets as OpenFLAssets;
//other libs
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
	var canMoveObject:Bool = false;
	var canMoveChars:Bool = false;
	var canMoveOffset:Bool = false;
	var directionX:Int = 0;
	var directionY:Int = 0;
	var curObjectSelected:Int = 0;

	var templateStage = '{
		"objects": [
			{
				"image":"stage/back",
				"x": -600,
				"y": -200,
				"scale": 1,
				"scrollX": 0.9,
				"scrollY": 0.9,
				"frontChars": false,
				"flipX": false,
				"animated": false,
				"animations": [],
				"blend":"none"
			},
			{
				"image":"stage/front",
				"x": -650,
				"y": 600,
				"scale": 1.1,
				"scrollX": 0.9,
				"scrollY": 0.9,
				"frontChars": false,
				"flipX": false,
				"animated": false,
				"animations": [],
				"blend":"none"
			},
			{
				"image":"stage/curtains",
				"x": -500,
				"y": -300,
				"scale": 0.9,
				"scrollX": 1.3,
				"scrollY": 1.3,
				"frontChars": true,
				"flipX": false,
				"animated": false,
				"animations": [],
				"blend":"none"
			}
		],
		"bfPos": [770, 450],
		"gfPos": [400, 130],
		"dadPos": [100, 100],
		"cameraZoom": 0.9,
		"curStage": "stageTemp"
	}';

	var UI_box:FlxUITabMenu;
	var stageJson:StageJSON = cast Json.parse(templateStage);
	var stageEditorMap:Map<String, FlxSprite> = [];

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
			text.y += ((text.height + 20)  * i);
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
			{name: 'Stage', label: 'Stage'},
		];
		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.cameras = [camUI];
		UI_box.resize(250, 310);
		UI_box.x = FlxG.width - 268;
		UI_box.y = (FlxG.height - UI_box.height)-264;
		UI_box.scrollFactor.set();

		setUI();
		loadTemplate();
		super.create();

		#if mobile
		addVirtualPad(FULL, A_B_X_Y_C);
		#end
	}

	override function update(elapsed:Float)
	{
		//TODO: a key for enableing these variables (canMoveChars, canMoveOffset)
		for (object in stageObjects)
		{
			if (object.ID == curObjectSelected)
			{
				//object.shader = Paths.shader('outline');
				if (canMoveChars){
					if(controls.LEFT){
						object.x -= FlxG.keys.justPressed.E ? elapsed / 2 : 1;
						stageJson.objects[curObjectSelected].x -= FlxG.keys.justPressed.E ? elapsed / 2 : 1;
					}
					if(controls.RIGHT){
						object.x += FlxG.keys.justPressed.E ? elapsed / 2 : 1;
						stageJson.objects[curObjectSelected].x += FlxG.keys.justPressed.E ? elapsed / 2 : 1;
					}
					if(controls.UP){
						object.y -= FlxG.keys.justPressed.E ? elapsed / 2 : 1;
						stageJson.objects[curObjectSelected].y -= FlxG.keys.justPressed.E ? elapsed / 2 : 1;
					}
					if(controls.DOWN){
						object.y -= FlxG.keys.justPressed.E ? elapsed / 2 : 1;
						stageJson.objects[curObjectSelected].y -= FlxG.keys.justPressed.E ? elapsed / 2 : 1;
					}
				}
			}
		}

		// camera stuff
		if (!canMoveCam)
			textStatus.text = "[ NO CAMERA MODE ]";
		else
			textStatus.text = "[ CAMERA MODE ]";
		if(controls.ACCEPT && !canMoveCam)
			canMoveCam = true;
		if(controls.BACK && canMoveCam)
			canMoveCam = false;

		camFollow.x += elapsed/2 * directionX;
		camFollow.y += elapsed/2 * directionY;
		if (canMoveCam){
			//horizontal
			if (controls.LEFT)
				directionX = -1;
			if (controls.RIGHT)
				directionX = 1;
			//vertical
			if (controls.UP)
				directionY = -1;
			if (controls.DOWN)
				directionY = -1;
			if (FlxG.keys.justReleased.M){
				while (camGame.zoom < 3)
					camGame.zoom += elapsed/2;
			}else if (FlxG.keys.justReleased.N){
				while (camGame.zoom > 3)
					camGame.zoom -= elapsed/2;
			}
		}
		if (!canMoveCam && !canMoveChars){
			if (controls.LEFT)
				curObjectSelected -= 1;
			if (controls.RIGHT)
				curObjectSelected += 1;
		}

		super.update(elapsed);
	}

	//input texts
	var imageInputText:FlxUIInputText;
	//steppers
	var positionXStepper:FlxUINumericStepper; //x
	var positionYStepper:FlxUINumericStepper; //y
	var scaleStepper:FlxUINumericStepper;
	var stepByStep:Float = 1; //for position
	public function setUI()
	{
		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Object";
		
		imageInputText = new FlxUIInputText(15, 30, 200, 'stage/back', 8);
		imageInputText.focusGained = () -> FlxG.stage.window.textInputEnabled = true;
	
		positionXStepper = new FlxUINumericStepper(imageInputText.x, (imageInputText.y + imageInputText.height) + 18, stepByStep, stageObjects[curObjectSelected].x, -900000, 900000, 0);
		positionYStepper = new FlxUINumericStepper((positionXStepper.x + positionXStepper.width) + 10, (imageInputText.y + imageInputText.height) + 18, stepByStep, stageObjects[curObjectSelected].y, -900000, 900000, 0);
		scaleStepper = new FlxUINumericStepper(imageInputText.x, (positionXStepper.y + positionXStepper.height) + 8, 0.5, stageObjects[curObjectSelected].scale, 0.0, 20.0, 0);

		tab_group.add(imageInputText);
		tab_group.add(positionXStepper);
		tab_group.add(positionYStepper);
		tab_group.add(scaleStepper);
		UI_box.addGroup(tab_group);
	}
	public function loadTemplate()
	{
		var file:StageJSON = cast haxe.Json.parse(templateStage);
		for (i in 0...file.objects.length)
		{
			for (object in stageObjects)
			{
				var obj = file.objects[i];
				stageObjects.remove(object);
				setObject(obj.image, obj.x, obj.y, obj.scale, obj.scrollX, obj.scrollY, obj.frontChars, obj.flipX, obj.animated, obj.animations, obj.blend);
				//stageObjects.push(stageEditorMap.get(substring(obj.image.indexOf('/') + 1, obj.image.length)));
			}
		}
	}

	// a maior funçao que eu programei ate agora
	public function setObject(image:String, x:Float, y:Float, scale:Float, scrollX:Float, scrollY:Float, frontChars:Bool, flipX:Bool, animated:Bool, animations:Array<StageJSON.Animation>, blend:String)
	{
		//if (!stageEditorMap.exists(image.substring(image.indexOf('/') + 1, image.length)))
		//{
			var obj = new FlxSprite(x, y);
			if (animated) {
				for (i in 0...animations.length)
				{
					obj.frames = Paths.getSparrowAtlas(image);
					var name = animations[i].name;
					var prefix = animations[i].prefix;
					var fps = animations[i].fps;
					var indices = animations[i].indices;
					var offsets = animations[i].offsets;
					var loop = animations[i].loop;
	
					if (indices.length > 0)
						obj.animation.addByIndices(name, prefix, indices, "", fps);
					else
						obj.animation.addByPrefix(prefix, name, fps, loop);
	
					obj.offset.set(offsets[0], offsets[1]);
				}
			} else {
				obj.loadGraphic(Paths.image(image, 'stagejson'));
			}
			obj.flipX = flipX;
			obj.setGraphicSize(Std.int(obj.width * scale));
			obj.scrollFactor.set(scrollX, scrollY);

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
				default:
					obj.blend = NORMAL;
			}
	
			var objname:String = image.substring(image.indexOf('/') + 1, image.length);
			stageEditorMap.set(objname, obj);
			if(!frontChars)
				add(stageEditorMap.get(objname));
			else
				stage.foreground.add(stageEditorMap.get(objname));
			stageObjects.push(stageEditorMap.get(objname));
		//}
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
		_file.save(haxe.Json.stringify(stageData, "\t"), "data.json");
	}
}