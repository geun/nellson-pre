package nellson.components;
import haxe.Timer;

/**
 * ...
 * @author Geun
 */

 
enum StorageType
{
	Goods;
}
 
enum StorageState
{
	NotChange;
	Full;
	UseAble;
	Use;
	NotEnoughCount;
	Empty;
}
 
class Storage 
{
	
	public var type:IStorage;
	public var maxCount(default, null):Int;
	public var refilledTimeStamp:Date;
	
	public var currentCount:Int;
	public var invalidateStorage:Bool;
	
	public var currentStats:StorageState;
	
	public function new(type:IStorage) 
	{
		this.type = type;
		this.maxCount = type.getMaxNum();
		invalidateStorage = false;
		//refill();
		
	}
	
	public function refill(?num:Int):Void
	{
		refilledTimeStamp = Date.now();
		
		
		if (num != null) 
		{
			
			if ( num == 0) 
			{
				currentStats = StorageState.NotChange;
				return;
			}
			if (currentCount + num < maxCount)
			{
				currentCount += num;
				currentStats = StorageState.UseAble;
			}
			else
			{
				currentCount = maxCount;
				currentStats = StorageState.Full;
			}
			trace('            refill : ' + num + ' / ' +currentStats + ' / macCount' +  maxCount + ' / CurrentCount ' + currentCount);
		}
		else 
		{
			currentCount = maxCount;
			currentStats = StorageState.Full;
		}
		
		invalidateStorage = true;
	}
	
	inline private function checkUseable(num:Int):Bool
	{
		if (currentCount - num >= 0) return true;
		else return false;
	}
	
	public function use(num:Int):StorageState
	{
		invalidateStorage = true;
		var result:StorageState = null;
		if (currentCount == 0)
		{
			result = StorageState.Empty;
		}
		else
		{
			if (checkUseable(num))
			{
				currentCount -= num;
				//trace([type, currentCount]);
				result = StorageState.Use;
			}
			else
			{
				trace('result = StorageState.NotEnoughCount');
				result = StorageState.NotEnoughCount;
			}
		}
		currentStats = result;
		return result;
	}
	
}