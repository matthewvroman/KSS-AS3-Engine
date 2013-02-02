package org.kss 
{
	import org.kss.KSSEntity;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSComponent extends KSSObject
	{
		public var _entity:KSSEntity;
		
		public function KSSComponent(entity:KSSEntity) 
		{
			_entity = entity;
			super();
		}
		
		override public function Awake():void 
		{
			
		}
		
		//cleanup
		override public function Destroy():void
		{
			
		}
		
		
		
		
		
		
	}

}