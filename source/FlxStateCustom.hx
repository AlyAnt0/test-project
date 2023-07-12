package;

import flixel.addons.ui.FlxUIState;
#if mobile
import flixel.input.actions.FlxActionInput;
import mobile.FlxVirtualPad;
#end

class FlxStateCustom extends FlxUIState
{
	private var controls(get, never):Controls;
	#if android
	var virtualPad:FlxVirtualPad;
	var trackedInputs:Array<FlxActionInput> = [];

	public function addVirtualPad(?DPad:FlxDPadMode, ?Action:FlxActionMode) 
	{
		virtualPad = new FlxVirtualPad(DPad, Action);
		virtualPad.alpha = 0.75;
		add(virtualPad);

		controls.setVirtualPad(virtualPad, DPad, Action);
		controls.setVirtualPadTwo(virtualPad, DPad, Action);

		trackedInputs = controls.trackedInputs;
		controls.trackedInputs = [];
	}

	public function killVirtualPad()
	{
		if (virtualPad != null)
			virtualPad.kill();
	}

	public function addPadCamera() 
	{
		var camControl = new flixel.FlxCamera();
		FlxG.cameras.add(camControl);
		camControl.bgColor.alpha = 0;
		virtualPad.cameras = [camControl];
	}

	override function destroy() 
	{
		controls.removeFlxInput(trackedInputs);

		super.destroy();
	}
	#end
}