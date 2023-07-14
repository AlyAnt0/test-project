package;

import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxG;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	/*
	public static var flixelStuff: Map<String, Dynamic> = [
		'width' => 1280,
		'height' => 720,
		'state' => PlayState,
		'fps' => 60,
		'zoom' => -1,
		'skipSplash' => false,
		'fullscreen' => false
	];
	*/

	var width:Int = 1280;
	var height:Int = 720;
	var zoom:Float = -1;
	var skipSplash:Bool = false; //why you gonna hide it???
	var fullscreen:Bool = false;
	public static var state:Class<FlxState> = PlayState;
	public static var fps:Int = 60;

	public static function main()
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var gameWidth = width;
			var gameHeight = height;
			var ratioX:Float = stageWidth / width;
			var ratioY:Float = stageHeight / height;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		addChild(new FlxGame(
			width, //width
			height, //height
			state, // the initial state
			zoom, //the zoom
			fps, //the framerate
			fps, //again
			skipSplash, //the splash (its cool go apreciate it pls if you hide you are cring)
			fullscreen)); //fullscreen
	}
}
