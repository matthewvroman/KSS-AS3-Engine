package org.kss.tilemaps 
{
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXObjectGroup 
	{
		private var _objects:Vector.<TMXObject> = new Vector.<TMXObject>();
		
		public function TMXObjectGroup(src:XML) 
		{
			//generate objects
			for (var i:int = 0; i < src.object.length(); i++)
				{
					var object:XML = src.object[i];
					var tmxObject:TMXObject = new TMXObject(object);
					
					//add to our vector of objects
					_objects.push(tmxObject);
				}
			}
		
	}

}