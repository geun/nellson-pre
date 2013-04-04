package nellson.blit.components;
import haxe.Public;
import nme.Lib;

/**
 * ...
 * @author Geun
 */

class DrawList implements Public
{
	var list:Array<Float>;
	var index:Int;
	var fields:Int;
	var offsetTransform:Int;
	var offsetRGB:Int;
	var offsetAlpha:Int;
	var flags:Int;
	var time:Int;
	var elapsed:Int;
	var runs:Int;

	function new() 
	{
		list = new Array<Float>();
		elapsed = 0;
		runs = 0;
	}

	function begin(elapsed:Int, useTransforms:Bool, useAlpha:Bool, useTint:Bool, useAdditive:Bool) 
	{
		#if (cpp||neko)
		flags = 0;
		fields = 3;
		if (useTransforms) {
			offsetTransform = fields;
			fields += 4;
			flags |= neash.display.Graphics.TILE_TRANS_2x2;
		}
		else offsetTransform = 0;
		if (useTint) {
			offsetRGB = fields; 
			fields+=3; 
			flags |= neash.display.Graphics.TILE_RGB;
		}
		else offsetRGB = 0;
		if (useAlpha) {
			offsetAlpha = fields; 
			fields++; 
			flags |= neash.display.Graphics.TILE_ALPHA;
		}
		else offsetAlpha = 0;
		if (useAdditive) flags |= neash.display.Graphics.TILE_BLEND_ADD;
		#end

		if (elapsed > 0) this.elapsed = elapsed;
		else
		{
			index = 0;
			if (time > 0) {
				var t = Lib.getTimer();
				this.elapsed = cast Math.min(67, t - time);
				time = t;
			}
			else time = Lib.getTimer();
		}
	}

	function end()
	{
		if (list.length > index) 
		{
			if (++runs > 60) 
			{
				list.splice(index, list.length - index); // compact buffer
				runs = 0;
			}
			else
			{
				while (index < list.length)
				{
					list[index + 2] = -2.0; // set invalid ID
					index += fields;
				}
			}
		}
	}
}