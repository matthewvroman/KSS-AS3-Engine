package org.kss.components 
{
	import flash.geom.Point;
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
			determineCollisionAreas(c.worldBounds);
			
		}
		
		public function OnTileCollision(t:TMXTileInfo):void
		{
			//trace("Collision with tile!");
			determineCollisionAreas(t.worldRect);
		}
		
		public function determineCollisionAreas(rect:Rectangle):void
		{
			var intersectPoint:Point = new Point();
			
			//RIGHT
			intersectPoint.x = _worldBounds.right;
			intersectPoint.y = _worldBounds.top+_worldBounds.height/2;
			if (!_touchingRight && rect.containsPoint(intersectPoint)){
				_touchingRight = true;
			}
			
			//LEFT
			intersectPoint.x = _worldBounds.left;
			intersectPoint.y = _worldBounds.top+_worldBounds.height/2;
			if (!_touchingLeft &&  rect.containsPoint(intersectPoint)){
				_touchingLeft = true;
			}
			
			//UP
			intersectPoint.x = _worldBounds.right-_worldBounds.width/2;
			intersectPoint.y = _worldBounds.top;
			if (rect.containsPoint(intersectPoint)){
				_touchingUp = true;
			}
			
			//DOWN
			intersectPoint.x = _worldBounds.right-_worldBounds.width/2;
			intersectPoint.y = _worldBounds.bottom;
			if (rect.containsPoint(intersectPoint)){
				_touchingDown = true;
				
			}
			
			unembedFromCollision(rect);
			
		}
		
		private function unembedFromCollision(collisionRect:Rectangle):void
		{
			var adjustment:Number;
			if (_touchingDown)
			{
				adjustment = collisionRect.top - _worldBounds.bottom;
				if(adjustment<1 && adjustment>-1){
					_entity.position.y += adjustment;
				}
			}else if (_touchingUp)
			{
				adjustment = collisionRect.bottom - _worldBounds.top;
				if(adjustment<1 && adjustment>-1){
					_entity.position.y += adjustment;
				}
			}
			if (_touchingRight)
			{
				adjustment = _worldBounds.right - collisionRect.left;
				if(adjustment<1 && adjustment>-1){
					_entity.position.x -= adjustment;
				}
			}
			if (_touchingLeft)
			{
				adjustment = _worldBounds.left - collisionRect.right;
				if(adjustment<1 && adjustment>-1){
					_entity.position.x -= adjustment;
				}
			}
		}
		
	}

}