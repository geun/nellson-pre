package nellson.scene;
import nellson.components.camera.Camera;
import nellson.core.System;
import nellson.statemachine.StateKey;
import nellson.statemachine.StateMachine;
import de.polygonal.ds.HashableItem;
import de.polygonal.ds.HashTable;
import nme.display.DisplayObjectContainer;

/**
 * ...
 * @author Geun
 */
class SceneManager extends System
{
	public var current(default, null):SceneType;
	public var prevScene(default, null):SceneType;
	private var currentScene:Scene;
	
	
	private var scenes:HashTable<SceneType, Scene>;
	//private var sceneStateMachine:StateMachine;
	private var container:DisplayObjectContainer;
	private var camera:Camera;
	
	
	//private var children:Array<Scene>;
	
	public function new(container:DisplayObjectContainer, ?camera:Camera) 
	{
		super();
		this.container = container;
		this.camera = camera;
		scenes = new HashTable(64);
	}
	
	
	inline public function addScene(key:SceneType, scene:Scene):Void
	{
		//var type:SceneType = new SceneType(scene.name);
		//scenes.hasKey(key)
		scenes.set(key, scene);
		container.addChild(scene);
		scene.visible = false;
	}
	
	inline public function addSceneAt(key:SceneType, scene:Scene, idx:Int):Void
	{
		//var type:SceneType = new SceneType(scene.name);
		//scenes.hasKey(key)
		scenes.set(key, scene);
		container.addChildAt(scene, idx);
		scene.visible = false;
	}
	
	inline public function getCurrentScene():Scene
	{
		return currentScene;
	}
	
	inline public function getScene(key:SceneType):Scene
	{
		//trace('get State' + key.key);
		
		var state:Scene = null;
		if (scenes.hasKey(key))
		{
			state = scenes.get(key);
		}
		return state;
	}
	
	inline public function removeScene(scene:Scene):Void
	{
		scenes.remove(scene);
	}
	
	 public function updateScene(key:SceneType):Bool
	{
		if (current == null)
		{
			current = key;
			currentScene = scenes.get(current);
			currentScene.enter();
			return true;
		}
		
		if (current == key)
		{
			//trace('already in the ' + key + ' state' );
			return false;
		}
		
		if (scenes.hasKey(key))
		{
			currentScene.exit();
			prevScene = current;
			current = key;
			//trace('Set State' + current);
			currentScene = scenes.get(current);
			currentScene.enter();
		}
		else
		{
			//trace('state ' + key + 'cannot be used while in the ' + current + ' state');
			return false;
		}
		
		return true;
	}
	
	
	override public function update(time:Float):Void 
	{
		super.update(time);
		
		if (camera.scaleDirty && currentScene != null)
		{
			trace([camera.scaleDirty, camera.scale]);
			currentScene.resize(camera.scale, camera.scaleOffset);
		}
	}
	
}