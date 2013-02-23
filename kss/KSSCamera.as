package org.kss 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSCamera 
	{
		private var _bitmap:Bitmap;
		
		private var _width:Number;
		private var _height:Number;
		private var _zoom:Number;
		
		public var buffer:Number = 20;
		
		private var _frame:Rectangle;
		public function get frame():Rectangle { return _frame; }
		
		private var _frameCenter:Point = new Point(0,0);
		/*public function get frameCenter():Point { 
			_frameCenter.x = _width / 2;
			_frameCenter.y = _height / 2;
			return _frameCenter; 
		}*/
		
		private var _deadZone:Rectangle;
		
		public function set deadZone(zone:Rectangle):void { _deadZone = zone; }
		
		private var _target:KSSEntity;

		public function KSSCamera(width:Number, height:Number)
		{
			_width = width;
			_height = height;

			_frame = new Rectangle(0, 0, _width, _height);

			_deadZone = frame.clone();
			_deadZone.x += _width / 5;
			_deadZone.width -= (_width / 5)*2;
			_deadZone.y += _height / 5;
			_deadZone.height -= (_height / 5)*2;
			trace(_deadZone);
		}
		
		public function PreUpdate():void
		{
		}
		
		public function Update():void
		{
			
		}
		
		public function set zoom(scale:Number):void
		{
			//_bitmap.scaleX = scale;
			//_bitmap.scaleY = scale;
			_zoom = scale;
		}
		
		public function get zoom():Number 
		{
			return _zoom;
		}
		
		public function Scroll(x:Number, y:Number):void
		{
			_frame.x += x;
			_frame.y += y;
		}
		
		public function SnapTo(x:Number, y:Number):void
		{
			_frame.x = x;
			_frame.y = y;
		}
		
		public function SnapCenterTo(x:Number, y:Number):void
		{
			_frameCenter.x = x;
			_frameCenter.y = y;
			
			_frame.x = _frameCenter.x - _width / 2;
			_frame.y = _frameCenter.y - _height / 2;
		}
		
		public function LateUpdate():void
		{

		}
		
		public function FollowTarget(entity:KSSEntity):void
		{//trace(entity.cameraPosition);
			_target = entity;
			if (_deadZone.left > _target.cameraPosition.x)
			{
				_frame.x += _target.cameraPosition.x - _deadZone.left;
			}
			if (_deadZone.right < _target.cameraPosition.x)
			{
				_frame.x += _target.cameraPosition.x - _deadZone.right;
			}
			if (_deadZone.top > _target.cameraPosition.y)
			{
				_frame.y += _target.cameraPosition.y - _deadZone.top;
			}
			
			if (_deadZone.bottom < _target.cameraPosition.y)
			{
				_frame.y += _target.cameraPosition.y - _deadZone.bottom;
			}
			
		}
		
		public function CenterOnTarget(entity:KSSEntity):void
		{
			_target = entity;
			_frame.x = _target.position.x-_width/2;
			_frame.y = _target.position.y-_height/2;
		}
		
	}

}