package;

import flixel.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;

class PlayState extends FlxStateCustom
{
	override public function create()
	{
		var text:FlxText(0, 0, FlxG.width, "GOODBYE WORLD", 32);
		text.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		text.setPosition(0, (FlxG.height / 2) - (text.height / 2));
		add(text);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
