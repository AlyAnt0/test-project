package;

import flixel.FlxGame;
import flixel.FlxG;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	public static var flixelStuff: Map<String, Dynamic> = [
		'width' => 1280,
		'height' => 720,
		'state' => PlayState,
		'fps' => 60,
		'zoom' => -1,
		'skipSplash' => false, //haxeflixel splash its cool :((
		'fullscreen' => false
	];

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

		if (Main.flixelStuff.get('zoom') == -1)
		{
			var gameWidth = Main.flixelStuff.get('width');
			var gameHeight = Main.flixelStuff.get('height');
			var ratioX:Float = stageWidth / Main.flixelStuff.get('width');
			var ratioY:Float = stageHeight / Main.flixelStuff.get('height');
			Main.flixelStuff.get('zoom') = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / Main.flixelStuff.get('zoom'));
			gameHeight = Math.ceil(stageHeight / Main.flixelStuff.get('zoom'));
		}

		addChild(new FlxGame(
			Main.flixelStuff.get('width'), //width
			Main.flixelStuff.get('height'), //height
			Main.flixelStuff.get('state'), // the initial state
			Main.flixelStuff.get('zoom'), //the zoom (-1)
			Main.flixelStuff.get('fps'), //the framerate
			Main.flixelStuff.get('fps'), //again
			Main.flixelStuff.get('skipSplash'), //the splash (its cool go apreciate it pls if you hide you are cring)
			Main.flixelStuff.get('fullscreen') //fullscreen
		));
	}
}
