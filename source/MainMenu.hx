package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tween.FlxTween;
import flixel.math.FlxMath;
import flixel.groups.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import haxe.Json;

using StringTools;

class MainMenu extends FlxStateCustom
{
	var option:Map<String, FlxState> = [
		'stage_editor' => new stuff.stagejson.StageEditor()
	];

	var optionArray:Array<String> = [
		'stage_editor'
	];
	var grp:FlxTypedSpriteGroup<TestingOption>;
	var curSelected:Int = 0;
	var targetYPos:Float = 0;

	override function create()
	{
		//persistentDraw = true;
		persistentUpdate = persistentDraw = true;
		FlxG.camera.bgColor = 0xFFFAC40C;

		grp = new FlxTypedSpriteGroup<TestingOption>();
		add(grp);

		for (i in 0...optionArray.length)
		{
			var sprite = new TestingOption(0, 0, optionArray[i]);
			sprite.targetX = i;
			sprite.ID = i;
			sprite.setPosition(FlxG.width / 2, FlxG.height + sprite.height);
			grp.add(sprite);
		}
		changeS();
		super.create();

		#if mobile
		addVirtualPad(LEFT_RIGHT, A);
		#end
	}
	override function update(elapsed:Float)
	{
		//transition
		for (_obj in grp.members){
			for (j in 0...optionArray.length){
				var k:Int = 0;
				targetYPos = (FlxG.height / 2) - (_obj.height / 2);
				if (_obj.ID == k && grp.members.contains(_obj))
				{
					FlxMath.lerp(_obj.y, targetYPos, 0.09);
					_obj.angle+=2.2*j;
					FlxMath.lerp(_obj.angle, 0, 0.09);
					if (_obj.y <= targetYPos + 100)
						k++;
				}
			}
		}
		for (obj in grp.members)
			obj.updateHitbox();

		if (controls.LEFT)
			changeS(-1);

		if (controls.RIGHT)
			changeS(1);

		if (controls.ACCEPT)
			accept();

		super.update(elapsed);
	}

	private function changeS(s:Int = 0)
	{
		curSelected += s;
		if (curSelected >= optionArray.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = optionArray.length - 1;
		var u:Int = 0;
		for (obj in grp.members)
		{
			u = obj.targetX - curSelected;
			u++;
			if (obj.ID == curSelected)
				obj.play('select');
				//if (obj.animation.curAnim.name == 'select')
		}
	}

	function accept()
		return FlxG.switchState(option.get(optionArray[curSelected]));
}
class TestingOption extends FlxSprite
{
	public var targetX:Float = 0;
	public var _scale:Float = 1.8;
	public function new(x:Float, y:Float, sprite:String)
	{
		super(x,y);
		frames = Paths.sparrow('menu/'+sprite, 'shared');
		animation.addByPrefix('idle', sprite.replace('_', ' ') + ' idle', 24, true);
		animation.addByPrefix('select', sprite.replace('_', ' ') + ' slct', 24, true);
		scale.set(_scale, _scale);
		updateHitbox();
		play('idle');
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var limitScale:Float=FlxMath.remapToRange((targetX+_scale), 0, 1, 0, 2*1.01998);
		x = Utils.fakeLerp(x, (FlxG.width - 200) * targetX + (_scale / 2), 0.09);
		if (animation.curAnim.name == 'select')
			scaleObject(limitScale, limitScale);
		updateHitbox();
		//FlxMath.lerp(x, (FlxG.width - 200) * targetX + 10 * (scaleX - 2), );
	}

	public function scaleObject(targetScaleX:Float, targetScaleY:Float, elapsedVal:Float)
	{
		scale.set(Utils.fakeLerp(scale.x, targetScaleX, 0.09), Utils.fakeLerp(scale.y, targetScaleY, 0.09));
	}
	public function play(animationPrefix:String);
	{
		return animation.play(animationPrefix);
	}
}