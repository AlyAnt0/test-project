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
		return addChild(new FlxGame(0, 0, PlayState, 1, 60, 60, false));
	}
}
