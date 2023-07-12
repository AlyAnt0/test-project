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

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / flixelStuff.get('width');
			var ratioY:Float = stageHeight / flixelStuff.get('height');
			flixelStuff.get('zoom') = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / flixelStuff.get('zoom'));
			gameHeight = Math.ceil(stageHeight / flixelStuff.get('zoom'));
		}

		addChild(new FlxGame(
			flixelStuff.get('width'),
			flixelStuff.get('height'),
			flixelStuff.get('state'),
			flixelStuff.get('zoom'),
			flixelStuff.get('fps'),
			flixelStuff.get('fps'),
			flixelStuff.get('skipSplash'),
			flixelStuff.get('fullscreen')
		));
	}

	public static function updateFramerate()
	{
		if (Main.framerate > FlxG.updateFramerate)
		{
			FlxG.updateFramerate = Main.flixelStuff.get('fps');
			FlxG.drawFramerate = Main.flixelStuff.get('fps');
		}
		else
		{
			FlxG.drawFramerate = Main.flixelStuff.get('fps');
			FlxG.updateFramerate = Main.flixelStuff.get('fps');
		}
	}

	public static function adjustFPS(num:Float):Float{
		return FlxG.elapsed / (1/60) * num;
	}

	public static function setFPSCap(cap:Int)
	{
		Main.flixelStuff.get('fps') = cap;
		updateFramerate();
	}
}
