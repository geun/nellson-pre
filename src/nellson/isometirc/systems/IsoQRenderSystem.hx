package nellson.isometirc.systems;
import nellson.components.camera.Camera;
import nellson.components.Info;
import nellson.core.Game;
import nellson.grid.IGrid;
import nellson.quadtree.components.QuarryResult;
import nellson.quadtree.systems.QRenderSystem;
import minject.Injector;


#if flash
import nellson.renderer.IsoBMPViewport;
#else
import nellson.renderer.IsoNMEViewport;
#end 
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObjectContainer;
import nme.errors.Error;

/**
 * ...
 * @author Geun
 */

class IsoQRenderSystem extends QRenderSystem
{
	@inject 
	public var inject:Injector;
	
	private var grid:IGrid;
	public function new(?container:DisplayObjectContainer, camera:Camera, renderNodes:QuarryResult, grid:IGrid) 
	{
		this.grid = grid;
		trace(container);
		super(container, camera, renderNodes);
	}
	
	override private function init():Void 
	{
		#if flash
		viewport = new IsoBMPViewport(container, camera, grid);
		#else
		viewport = new IsoNMEViewport(container, camera, grid);
		#end
	}
	
	override public function addToGame(game:Game):Void 
	{
		super.addToGame(game);
		inject.injectInto(viewport);
		
	}
	
	override public function removeFromGame(game:Game):Void 
	{
		super.removeFromGame(game);
	}
	
	override public function update(time:Float):Void 
	{
		super.update(time);
		//if (camera.scaleDirty) viewport.resize();
 	}
	
}