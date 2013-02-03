package org.kss.tilemaps 
{
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXProperty 
	{
		private var _name:String;
		private var _value:*;
		
		public function get name():String { return _name; }
		public function get value():* { return _value; }
		
		public function TMXProperty(src:XML)
		{
			_name = src.@name;
			_value = src.@value;
		}
		
	}

}