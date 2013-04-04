package nellson.blit.components;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * ...
 * @author Geun
 */

interface ITilesheet
{
	
	//function getSize(indice:Int):Rectangle;
	//function getFrame(indice:Int):Point;
	
	function getName():String;
	function getTextures(name:String):Array<Int>; //  getAnim(name:String):Array<Int>;
	function getRegion(indice:Int):Rectangle; //getSize(indice:Int):Rectangle;

	
	function getFrametoRectangle(indice:Int):Rectangle;
	function getFrametoPoint(indice:Int):Point;
	function getBitmap(indice:Int):BitmapData;
	
	function getIndexByName(name:String):Int;

	#if (flash||js)
	#else
	function drawTiles(graphics:Graphics, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0):Void;
	#end
}