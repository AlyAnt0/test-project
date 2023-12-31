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

	public function new()
	{
		super();
		SUtil.uncaughtErrorHandler();

		addChild(new FlxGame(1280, 720, PlayState, 1, 60, 60, false));
	}
}
