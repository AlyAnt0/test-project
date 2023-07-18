package stuff.stagejson;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.FlxObject;
import flixel.FlxBasic;
import openfl.utils.Assets;

using StringTools;

typedef StageJSON = {
	var objects:Array<ObjectJeisom>;
	var bfPos:Array<Float>;
	var gfPos:Array<Float>;
	var dadPos:Array<Float>;
	var cameraZoom:Float;
	var curStage:String;
}

typedef ObjectJeisom = {
	var image:String;
	var x:Float;
	var y:Float;
	var scale:Float;
	var scrollX:Float;
	var scrollY:Float;
	@:optional var frontChars:Bool;
	@:optional var flipX:Bool;
	@:optional var animated:Bool;
	@:optional var animations:Array<Animation>;
	@:optional var blend:String;
}

typedef Animation = {
	var name:String;
	var prefix:String;
	var fps:Int;
	@:optional var indices:Array<Int>;
	@:optional var offsets:Array<Float>;
	@:optional var loop:Bool;
}
class Stage extends FlxTypedGroup<FlxBasic> {
  public static var jsonObjects:Map<String,FlxSprite>=[];

  public static var stageNames:Array<String> = [
    "stage"
  ];

  public var doDistractions:Bool = true;

  public var bfPosition:FlxPoint = FlxPoint.get(770,450);
  public var dadPosition:FlxPoint = FlxPoint.get(100,100);
  public var gfPosition:FlxPoint = FlxPoint.get(400,130);
  public var camPos:FlxPoint = FlxPoint.get(100,100);
  public var camOffset:FlxPoint = FlxPoint.get(100,100);

  public var layers:Map<String,FlxTypedGroup<FlxBasic>> = [
    "boyfriend"=>new FlxTypedGroup<FlxBasic>(), // stuff that should be layered infront of all characters, but below the foreground
    "dad"=>new FlxTypedGroup<FlxBasic>(), // stuff that should be layered infront of the dad and gf but below boyfriend and foreground
    "gf"=>new FlxTypedGroup<FlxBasic>(), // stuff that should be layered infront of the gf but below the other characters and foreground
  ];
  public var foreground:FlxTypedGroup<FlxBasic> = new FlxTypedGroup<FlxBasic>(); // stuff layered above every other layer
  public var overlay:FlxSpriteGroup = new FlxSpriteGroup(); // stuff that goes into the HUD camera. Layered before UI elements, still

  public var boppers:Array<Array<Dynamic>> = []; // should contain [sprite, bopAnimName, whichBeats]
  public var dancers:Array<Dynamic> = []; // Calls the 'dance' function on everything in this array every beat

  public var defaultCamZoom:Float = 1.05;

  public var curStage:String = '';

  // other vars
  public var gfVersion:String = 'gf';
  public var gf:Character;
  public var boyfriend:Character;
  public var dad:Character;
  public var currentOptions:Options;
  public var centerX:Float = -1;
  public var centerY:Float = -1;

  override public function destroy(){
    bfPosition = FlxDestroyUtil.put(bfPosition);
    dadPosition = FlxDestroyUtil.put(dadPosition);
    gfPosition = FlxDestroyUtil.put(gfPosition);
    camOffset =  FlxDestroyUtil.put(camOffset);

    super.destroy();
  }

  public function setPlayerPositions(?p1:Character,?p2:Character,?gf:Character){

    if(p1!=null)p1.setPosition(bfPosition.x,bfPosition.y);
    if(gf!=null)gf.setPosition(gfPosition.x,gfPosition.y);
    if(p2!=null){
      p2.setPosition(dadPosition.x,dadPosition.y);
      camPos.set(p2.getGraphicMidpoint().x, p2.getGraphicMidpoint().y);
    }

    if(p1!=null){
      switch(p1.curCharacter){

      }
    }

    if(p2!=null){

      switch(p2.curCharacter){
        case 'gf':
          if(gf!=null){
            p2.setPosition(gf.x, gf.y);
            gf.visible = false;
          }
        case 'dad':
          camPos.x += 400;
        case 'pico':
          camPos.x += 600;
        case 'senpai' | 'senpai-angry':
          camPos.set(p2.getGraphicMidpoint().x + 300, p2.getGraphicMidpoint().y);
        case 'spirit':
          camPos.set(p2.getGraphicMidpoint().x + 300, p2.getGraphicMidpoint().y);
        case 'bf-pixel':
          camPos.set(p2.getGraphicMidpoint().x, p2.getGraphicMidpoint().y);
      }
    }

    if(p1!=null){
      p1.x += p1.posOffset.x;
      p1.y += p1.posOffset.y;
    }
    if(p2!=null){
      p2.x += p2.posOffset.x;
      p2.y += p2.posOffset.y;
    }


  }

  public function new(stage:String,currentOptions:Options){
    super();
    curStage=stage;
    this.currentOptions=currentOptions;

    overlay.scrollFactor.set(0,0); // so the "overlay" layer stays static

    //my try at creating a stage with objects from json -aly-ant
    var path = 'assets/oneshot/images/bg/${stage}/data.json';
    var objName:String;
		if (Assets.exists(path)){
			for (i in 0...StageJSON.objects.length){
				var obj = new FlxSprite(StageJSON.objects[i][1], StageJSON.objects[i][2]);
				var stageObjs=StageJSON.objects[i];
				if (Assets.exists('assets/oneshot/images/bg/'+stage+stageObjs[0]+'.xml')){
					obj.frames=Paths.getSparrowAtlas(stage+stageObjs[i][0],'oneshot');
					objName = stageObjs.substring(stageObjs.indexOf('/') + 1, stageObjs.length);
					//TODO: make the condition if ends with some text else will add a animation prefix
					switch(objName){
						case 'place something here':
							obj.animation.addByPrefix('animation','sex',24,true);
					}
				}else{
					obj.loadGraphic(Paths.image(stageObjs[0],'oneshot'));
					obj.antialiasing=false;
				}if(stageObjs[3]!=1){
					obj.scale.set(stageObjs[3],stageObjs[3]);
					obj.updateHitbox();
				}
				obj.scrollFactor.set(stageObjs[4],stageObjs[5]);
				jsonObjects.set(stageObjs[0],obj);
				add(jsonObjects.get(stageObjs[0]));
				FlxG.log.add('Added JSON objects: '+StageJSON.objects[i][0]);
			}
		}
    switch (stage){
      default:
        defaultCamZoom = 0.9;
        curStage = 'stage';
        var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback','shared'));
        bg.antialiasing = true;
        bg.scrollFactor.set(0.9, 0.9);
        bg.active = false;
        add(bg);

        var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront','shared'));
        stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
        stageFront.updateHitbox();
        stageFront.antialiasing = true;
        stageFront.scrollFactor.set(0.9, 0.9);
        stageFront.active = false;
        add(stageFront);

        var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains','shared'));
        stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
        stageCurtains.updateHitbox();
        stageCurtains.antialiasing = true;
        stageCurtains.scrollFactor.set(1.3, 1.3);
        stageCurtains.active = false;

        centerX = bg.getMidpoint().x;
        centerY = bg.getMidpoint().y;

        foreground.add(stageCurtains);
      }
  }


  public function beatHit(beat){
    for(b in boppers){
      if(beat%b[2]==0){
        b[0].animation.play(b[1],true);
      }
    }
    for(d in dancers){
      d.dance();
    }
  }

  override function update(elapsed:Float){
    super.update(elapsed);
  }

  function trainStart():Void
  {
    trainMoving = true;
    trainSound.play(true,0);
  }

  function trainReset():Void
  {
    gf.playAnim('hairFall');
    phillyTrain.x = FlxG.width + 200;
    trainMoving = false;
    // trainSound.stop();
    // trainSound.time = 0;
    trainCars = 8;
    trainFinishing = false;
    startedMoving = false;
  }

  override function add(obj:FlxBasic){
    if(OptionUtils.options.antialiasing==false){
      if((obj is FlxSprite)){
        var sprite:FlxSprite = cast obj;
        sprite.antialiasing=false;
      }else if((obj is FlxTypedGroup)){
        var group:FlxTypedGroup<FlxSprite> = cast obj;
        for(o in group.members){
          if((o is FlxSprite)){
            var sprite:FlxSprite = cast o;
            sprite.antialiasing=false;
          }
        }
      }
    }
    return super.add(obj);
  }

}