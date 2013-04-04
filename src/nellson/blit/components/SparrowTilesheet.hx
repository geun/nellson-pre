package nellson.blit.components;

/**
 * ...
 * @author Geun
 */

import nellson.ds.ObjectHash;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Lib;

using StringTools;

#if js
class Tilesheet { 
	function new(img:BitmapData) {
	}
}
#else
typedef Tilesheet = nme.display.Tilesheet;
#end

/**
 * Sparrow spritesheet parser (supports trimmed PNGs)
 * compatible with TileLayer.
 * @author Philippe / http://philippe.elsass.me
 */
class SparrowTilesheet extends Tilesheet, implements ITilesheet
{
	
	//var regions:ObjectHash<Rectangle>;
	//var frames:ObjectHash<Rectangle>;
	
	var names:Array<String>;
	var regions:Array<Rectangle>;
	var frames:Array<Rectangle>;
	
	
	var anims:Hash<Array<Int>>;
	//#if (flash||js)
	var bmps:Array<BitmapData>;
	private var name:String;
	//#end

	public function new(img:BitmapData, xml:String) 
	{
		super(img);
		
		//regions = new ObjectHash();
		//frames = new ObjectHash();
		
		names = new Array<String>();
		regions = new Array<Rectangle>();
		frames = new Array<Rectangle>();
		anims = new Hash<Array<Int>>();
		
		//#if (flash||js)
		bmps = new Array<BitmapData>();
		//#end

		var ins = new Point(0,0);
		var x = new haxe.xml.Fast( Xml.parse(xml).firstElement() );
		name = x.att.imagePath;
		name = name.split('.')[0];
		//trace(name);
		for (texture in x.nodes.SubTexture)
		{
			
			var r:Rectangle = new Rectangle(
				Std.parseInt(texture.att.x), Std.parseInt(texture.att.y),
				Std.parseInt(texture.att.width), Std.parseInt(texture.att.height));

			var s:Rectangle = if (texture.has.frameX)
					new Rectangle(
						Std.parseInt(texture.att.frameX), Std.parseInt(texture.att.frameY),
						Std.parseInt(texture.att.frameWidth), Std.parseInt(texture.att.frameHeight));
				else 
					new Rectangle(0, 0, r.width, r.height);
					
			names.push(texture.att.name);
			regions.push(r);
			frames.push(s);
			
			
			var bmp:BitmapData = getBitmapData(img, r, s);
			bmps.push(bmp);
			//#if (flash || js)
			#if cpp
			addTileRect(r, new Point(s.x + s.width / 2, s.y + s.height / 2));
			#end
		}
	}
	
	public function getIndexByName(name:String):Int
	{
		var indices = new Array<Int>();
		for (i in 0...names.length)
		{
			var s:String;
			if (names[i].startsWith(name)) 
			{
				return i;
			}
		}
		return -1;
	}
	private function getBitmapData(source:BitmapData, rect:Rectangle, frameX:Rectangle):BitmapData
	{
		var ins:Point = new Point(0,0);
		//var img:BitmapData = new BitmapData(cast frameX.width + 20, cast frameX.height + 20, true, 0);
		var img:BitmapData = new BitmapData(Std.int(frameX.width + 30), Std.int(frameX.height + 30), true, 0);
		ins.x = -frameX.left - 10 ;
		ins.y = -frameX.top - 10;
		rect.x -= 15;
		rect.y -= 15;
		rect.width += 30;
		rect.height += 30;
		
		img.copyPixels(source, rect, ins);
		//trace(ins);
		//trace([ins.x, ins.y]);
		//trace(rect);
		//trace([rect.x, rect.y]);
		//trace([rect.width, rect.height]);
		return img;
	}
	
	public function getTextures(name:String):Array<Int>
	{
		if (anims.exists(name))
			return anims.get(name);
		var indices = new Array<Int>();
		for (i in 0...names.length)
		{
			var s:String;
			if (names[i].startsWith(name)) 
				indices.push(i);
		}
		anims.set(name, indices);
		return indices;
	}

	inline public function getFrametoRectangle(indice:Int):Rectangle
	{
		if (indice < frames.length) return frames[indice];
		else return new Rectangle();
	}
	
	inline public function getFrametoPoint(indice:Int):Point
	{
		if (indice < frames.length)
		{
			var s:Rectangle = frames[indice];
			return new Point( -s.left, -s.top);
		}
		else return new Point();
	}
	
	inline public function getRegion(indice:Int):Rectangle
	{
		if (indice < regions.length) return regions[indice];
		else return new Rectangle();
	}

	//#if (flash||js)
	inline public function getBitmap(indice:Int):BitmapData
	{
		return bmps[indice];
	}
	
	/* INTERFACE nellson.blit.components.ITilesheet */
	
	public function getName():String 
	{
		return name;
	}
	
	/* INTERFACE nellson.blit.components.ITilesheet */
	//public function drawTiles(graphics:Graphics, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0):Void 
	//{
		//
	//}
	//#end
	
	
}
