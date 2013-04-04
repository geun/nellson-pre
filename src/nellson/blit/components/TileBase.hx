package nellson.blit.components;
import haxe.Public;
import nme.display.DisplayObject;

/**
 * ...
 * @author Geun
 */
class TileBase implements Public
{
	var layer:TileLayer;
	var parent:TileGroup;
	var x:Float;
	var y:Float;
	var animated:Bool;
	var visible:Bool;

	function new()
	{
		x = y = 0.0;
		visible = true;
	}

	function init(layer:TileLayer):Void
	{
		this.layer = layer;
	}

	function step(elapsed:Int)
	{
	}

	#if (flash||js)
	function getView():DisplayObject { return null; }
	#end
}