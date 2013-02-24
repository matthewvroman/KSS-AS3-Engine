package org.kss.tilemaps 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXObject 
	{
		private var _name:String;
		public function get name():String { return _name; }
		private var _type:String;
		public function get type():String { return _type; }
		private var _position:Point;
		public function get position():Point { return _position; }
		private var _width:Number;
		public function get width():Number { return _width; }
		private var _height:Number;
		public function get height():Number { return _height; }
		private var _properties:Vector.<TMXProperty>;
		public function get properties():Vector.<TMXProperty> { return _properties; }
		
		public function TMXObject(src:XML) 
		{
			_name = src.@name;
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
			if (!_properties) return null;
			
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