package nellson.quadtree.systems;
import nellson.components.camera.Camera;
import nellson.core.Game;
import nellson.core.System;
import nellson.quadtree.components.QuarryResult;
import nellson.renderer.IViewport;
import nellson.tilelayer.TileLayer;
import nme.display.DisplayObjectContainer;

/**
 * ...
 * @author Geun
 */

class QTileLayerRendererSystem extends System
{
	
	private var viewport:IViewport;
	
	private var tilelayer:TileLayer;
	
	private var camera:Camera;
	private var renderNodes:QuarryResult;
	private var container:DisplayObjectContainer;

	public function new(container:DisplayObjectContainer, camera:Camera, renderNodes:QuarryResult) 
	{
		super();
		this.container = container;
		this.camera = camera;
		this.renderNodes = renderNodes;
		
		init();
	}
	
	private function init():Void
	{
	}
	
	override public function addToGame(game:Game):Void 
	{
		
	}
	
	override public function removeFromGame(game:Game):Void 
	{
		
	}
	
	override public function update(time:Float):Void 
	{
		
	}
	
	private function render():Void
	{
		
		
	}
	
	
	
	
}