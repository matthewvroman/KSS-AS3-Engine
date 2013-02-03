package org.kss.tilemaps 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXObject 
	{
		public var _type:String;
		public var _position:Point;
		public var _width:Number;
		public var _height:Number;
		public var _properties:Vector.<TMXProperty>;
		
		public function TMXObject(src:XML) 
		{
			_type = src.@type;
			_position = new Point(src.@x, src.@y);
			_width = src.@width;
			_height = src.@height;
			
			//Add properties
			for (var i:int = 0; i < src.properties.property.length(); i++)
			{
				var tmxObjectProperty:XML = src.properties.property[i];
				AddProperty(new TMXProperty(tmxObjectProperty));
			}
		}
		
		public function AddProperty(property:TMXProperty):void
		{
			if (!_properties) _properties = new Vector.<TMXProperty>();
			
			_properties.push(property);
		}
		
		public function GetProperty(propertyName:String):*
		{
			var propertiesLength:int = _properties.length;
			for (var i:int = 0; i < propertiesLength; i++)
			{
				if (_properties[i].name == propertyName)
				{
					return _properties[i].value;
				}
			}
			
			return null;
		}
		
	}

}