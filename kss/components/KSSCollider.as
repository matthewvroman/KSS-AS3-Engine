package org.kss.components 
{
	import flash.geom.Rectangle;
	import org.kss.KSSComponent;
	import org.kss.KSSEntity;
	import org.kss.tilemaps.TMXTileInfo;
	
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
		
		private var _touchingLeft:Boolean = false;
		private var _touchingRight:Boolean = false;
		private var _touchingUp:Boolean = false;
		private var _touchingDown:Boolean = false;
		
		public function get touchingLeft():Boolean { return _touchingLeft; }
		public function get touchingRight():Boolean { return _touchingRight; }
		public function get touchingUp():Boolean { return _touchingUp; }
		public function get touchingDown():Boolean { return _touchingDown; }
		
		public function get touching():Boolean 
		{ 
			if (_touchingDown || _touchingLeft || _touchingRight || _touchingUp) 
				return true; 
			else
				return false;
		}
		
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
		}
		
		override public function PreUpdate():void
		{
			if (!active) return;
			
			super.PreUpdate();
			_touchingDown = _touchingLeft = _touchingRight = _touchingUp = false;
		}
		
		public function OnCollision(c:KSSCollider):void
		{
			//trace("collision with " + c + "!");
			
		}
		
		public function OnTileCollision(t:TMXTileInfo):void
		{
			//trace("Collision with tile!");
		}
		
	}

}