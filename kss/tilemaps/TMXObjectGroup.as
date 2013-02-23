package org.kss.tilemaps 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXObjectGroup 
	{
		public var name:String;
		public var position:Point;
		public var width:Number;
		public var height:Number;
		private var _objects:Vector.<TMXObject> = new Vector.<TMXObject>();
		public function get objects():Vector.<TMXObject> { return _objects; }
		
		public function TMXObjectGroup(src:XML) 
		{
			name = src.@name;
			position = new Point(src.@x, src.@y);
			width = src.@width;
			height = src.@height;

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