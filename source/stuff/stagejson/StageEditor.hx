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

class StageEditor extends FlxState
{
	var boyFriend:FlxSprite;
	var gf:FlxSprite;
	var dad:FlxSprite;

	var arrayText:Array<String> = ['Theres nothing lol'];
	var camGame:FlxCamera;
	var camUI:FlxCamera;
	var stageObjects:Array<FlxSprite> = [];
	var camFollow:FlxObject;
	var objectTexts:FlxTypedGroup<FlxText>;
	var textCam:FlxText;
	var canMoveCam:Bool = false;

	override function create()
	{
		super.create();

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
			//var text:FlxText(10, (20 * i), 0);
		}
		textCam = new FlxText(0, 0, FlxG.width, "", 32);
		textCam.y = (FlxG.height - textCam.frameHeight) - 20;
		add(textCam);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed())
	}

	private function setUI{
		
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
		_file.addEventList
	}
}