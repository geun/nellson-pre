package nellson.components.display;
import nme.display.Sprite;


/**
 * ...
 * @author Geun
 */

class Scene extends Sprite
{
	public var type:SceneType;
	public var view:String
	
	public function new(type:SceneType) 
	{
		super();
		this.type = type;
	}
	
}

enum SceneType
{
	GameMain;
	Popup;
	AssetsLoading;
	Store;
	FriendLoading;
}
