package meta;

import flixel.math.FlxMath;
import lime.utils.Assets;

using StringTools;

class Utils
{
	public static function difficultyFromNumber(number:Int):String
	{
		return difficultyArray[number];
	}

	public static function dashToSpace(string:String):String
	{
		return string.replace("-", " ");
	}

	inline public static function clamp(value:Float, min:Float, max:Float):Float
	{
		return Math.max(min, Math.min(max, value));
	}

	public static function spaceToDash(string:String):String
	{
		return string.replace(" ", "-");
	}

	public static function swapSpaceDash(string:String):String
	{
		return StringTools.contains(string, '-') ? dashToSpace(string) : spaceToDash(string);
	}

	public static function getOffsetsFromTxt(path:String):Array<Array<String>>
	{
		var fullText:String = Assets.getText(path);

		var firstArray:Array<String> = fullText.split('\n');
		var swagOffsets:Array<Array<String>> = [];

		for (i in firstArray)
			swagOffsets.push(i.split(' '));

		return swagOffsets;
	}

	public static function getAnimsFromTxt(path:String):Array<Array<String>>
	{
		var fullText:String = Assets.getText(path);

		var firstArray:Array<String> = fullText.split('\n');
		var swagOffsets:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagOffsets.push(i.split('--'));
		}

		return swagOffsets;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static var lerpSnap:Bool = false;
	public static function fakeLerp(val1:Float, val2:Float, ratio:Float) {
		if (lerpSnap)
			return FlxMath.lerp(val1, val2, 1);
		return FlxMath.lerp(val1, val2, ratio);
	}
	// eu so botei isso aqui so pra mostra que eu sabo muito -alyant
	/**
	  * @author: AlyAnt0
	  * sei la eu so tive a ideia se faze isso e eu to um pouco orgulhoso disso kkkk
	  * @param text       The text where the first char of this text if its lowercase will be UPPERCASE.
	*/
	static function firstLetterToUpperCase(text:String):String
	{
		if (StringTools.startsWith(text, text.charAt(0).toLowerCase()))
			text = text.replace(text.charAt(0), text.charAt(0).toUpperCase());
		return text;
	}
}
