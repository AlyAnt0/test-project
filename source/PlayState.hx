package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

class PlayState extends FlxStateCustom
{
	override public function create()
	{
		var text = new FlxText(0, 0, FlxG.width, "Hello World!");
		text.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE/*, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK*/);
		text.setPosition(0, (FlxG.height / 2) - (text.height / 2));
		add(text);

		new FlxTimer().start(1, function(tmr:FlxTimer){
			var text2 = new FlxText(0, 0, FlxG.width, "and goodbye world....", 32);
			text2.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE/*, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK*/);
			text2.y = (text.y + text.height) + 2;
			text2.alpha = 0.0000001;
			add(text2);

			FlxTween.tween(text2, {alpha: 0.5}, 1);
		});
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
