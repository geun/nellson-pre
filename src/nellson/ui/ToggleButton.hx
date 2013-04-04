package nellson.ui;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;

/**
 * ...
 * @author Geun
 */

class ToggleButton extends Sprite
{
	private var upData:Bitmap;
	private var overData:Bitmap;
	private var selectedData:Bitmap;
	//private var previousData:BitmapData;
	private var iconData:Bitmap;
	
	public var img:Bitmap;
	public var icon:Bitmap;
	
	public var selected(default, setSelected):Bool;
	
	public function new(name:String, up:Bitmap, selcted:Bitmap, ?iconData:Bitmap, ?over:Bitmap) 
	{
		super();
		this.name = name;
		this.upData = up;
		this.overData = over;
		this.selectedData = selcted;
		this.iconData = iconData;
		init();
	}
	
	public function update():Void
	{
		img.bitmapData = upData.bitmapData;
		//icon.bitmapData = iconData.bitmapData;		
	}
	
	private function init():Void
	{
		img = new Bitmap();
		this.addChild(img);
		icon = iconData;
		this.addChild(icon);
		
		/*img = new Bitmap(upData);
		this.addChild(img);
		icon = new Bitmap(iconData);
		this.addChild(icon);*/
		
		this.mouseChildren = false;
		update();
		setCenter();
	}
	
	
	public function moveIcon(dx:Int, dy:Int):Void
	{
		icon.x = dx;
		icon.y = dy;
	}
	
	private function setSelected(value:Bool):Bool
	{
		selected = value;
		//previousData = img.bitmapData;
		if (selected) img.bitmapData = selectedData.bitmapData;
		else img.bitmapData = upData.bitmapData;
		
		return selected;
	}
	
	public function setCenter():Void
	{
		icon.x = (this.width - icon.width) * 0.5;
		icon.y = (this.height - icon.height) * 0.5;
	}
	
}