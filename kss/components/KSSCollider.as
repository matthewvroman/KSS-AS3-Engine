package org.kss.components 
{
	import flash.geom.Rectangle;
	import org.kss.KSSComponent;
	import org.kss.KSSEntity;
	
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSCollider extends KSSComponent 
	{	
		public function get entity():KSSEntity { return _entity; }
		
		private var _localBounds:Rectangle;
		private var _worldBounds:Rectangle = new Rectangle(0, 0, 0, 0);
		
		public function get worldBounds():Rectangle { 
			_worldBounds.x = _localBounds.x + _entity.position.x;
			_worldBounds.y = _localBounds.y + _entity.position.y;
			return _worldBounds;
		}
		public var windowBounds:Rectangle;
		
		public function KSSCollider(entity:KSSEntity,collisionRect:Rectangle=null) 
		{
			super(entity);
			_entity = entity;
			
			if (collisionRect) {
				bounds = collisionRect;
			}
		}
		
		public function set bounds(rect:Rectangle):void
		{
			_localBounds = rect;
			_worldBounds.width = rect.width;
			_worldBounds.height = rect.height;
			_worldBounds.x = rect.x+_entity.position.x;
			_worldBounds.y = rect.y + _entity.position.y;
			trace("Local Bounds: " + rect);
			trace("World Bounds: " + _worldBounds);
		}
		
		public function OnCollide(e:KSSCollider):void
		{
			//trace("collision with " + e + "!");
		}
		
	}

}