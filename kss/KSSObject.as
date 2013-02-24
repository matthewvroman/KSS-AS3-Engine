package org.kss 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSObject 
	{
		
		public var name:String;
		private var _active:Boolean = true;
		public function set active(value:Boolean):void
		{
			if (_active != value)
			{
				if (value)
				{
					OnActive();
				}
				else 
				{
					OnDeactive();
				}
			}
			_active = value;
		}
		
		public function get active():Boolean { return _active; }
		
		public function KSSObject() 
		{
			Awake();
		}
		
		public function Awake():void
		{

		}
		
		public function Start():void
		{
			
		}
		
		public function OnActive():void
		{

		}
		
		public function OnDeactive():void
		{

		}
		
		public function PreUpdate():void
		{
			
		}
		
		public function Update():void
		{
			
		}
		
		public function LateUpdate():void
		{
			
		}
		
		public function Draw():void
		{
			
		}
		
		public function Destroy():void
		{
			
		}
	
	}

}