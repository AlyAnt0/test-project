package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

class PlayState extends FlxStateCustom
{
	var theseObjs:Array<FlxObject> = [];
	//var inten:Float = 0;
	var canChangeState:Bool = false;
	override public function create()
	{
		var text = new FlxText(0, 0, FlxG.width, "Hello World!");
		text.setFormat(Paths.font("vcr.ttf"), 48, FlxColor.WHITE/*, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK*/);
		text.setPosition(0, (FlxG.height / 2) - (text.height / 2));
		theseObjs.push(text);

		new FlxTimer().start(1, function(tmr:FlxTimer){
			var text2 = new FlxText(0, 0, FlxG.width, "and goodbye world....", 32);
			text2.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE/*, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK*/);
			text2.y = (text.y + text.height) + 2;
			text2.alpha = 0.0000001;
			theseObjs.push(text2);

			FlxTween.tween(text2, {alpha: 0.5}, 1, {
				onComplete: function(_v:FlxTween){
					new FlxTimer().start(0.5, function (_tmr:FlxTimer){
						for (_obj in theseObjs)
						{
							for (i in 0...theseObjs.length)
							{
								var j:Int = 0;
								if (_obj.ID == j)
								{
									FlxTween.tween(_obj, {alpha: 0.0000001}, 0.3 * j, {
										onComplete: function(_:FlxTween){
											j++;
										}
									});
								}
								if (!theseObjs.contains(_obj)) {
									new FlxTimer().start(0.5, function(_tmr:FlxTween){
										canChangeState = true;
									});
								}
							}
						}
					});
				}
			});
		});
		//im a little proud of this code that ive made lmao -aly-ant0
		for (_obj in theseObjs) 
			add(_obj);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (canChangeState)
			FlxG.switchState(new MainMenu());

		super.update(elapsed);
	}
}
