package org.kss.tilemaps 
{
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXBase 
	{
		private var _properties:Vector.<TMXProperty>;
		private var _numProperties:int;
		public function get numProperties():int { return _numProperties; }
		
		public function TMXBase() 
		{
			
		}
		
		public function set Properties(_propertySet:Vector.<TMXProperty>):void
		{
				_properties = _propertySet;
				_numProperties = _properties.length;
		}
		
		public function get Properties():Vector.<TMXProperty>
		{
			return _properties;
		}
		
		public function AddProperty(_property:TMXProperty):void
		{
			if (_properties == null) _properties = new Vector.<TMXProperty>();

			_properties.push(_property);
			_numProperties = _properties.length;
			trace("Added property: " + _property.name);
		}
		
		public function GetPropertyByName(propertyName:String):TMXProperty
		{
			for (var i:int = 0; i < _numProperties; i++)
			{
				if (_properties[i].name == propertyName)
				{
					return _properties[i];
				}
			}
			return null;
		}
	}

}