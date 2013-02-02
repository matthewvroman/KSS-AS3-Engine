package org.kss 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSCamera 
	{
		private var _stateCanvas:BitmapData;
		private var _canvas:BitmapData;
		public function get Canvas():BitmapData { return _canvas; }
		private var _canvasColor:uint;
		private var _width:Number;
		private var _height:Number;
		private var _zoom:Number;
		
		private var _frame:Rectangle;
		private var _destPos:Point;
		
		private var _target:KSSEntity;
		
		public function KSSCamera(width:Number, height:Number, canvas:BitmapData,bgColor:uint = 0x000000)
		{
			_stateCanvas = canvas;
			_width = width;
			_height = height;
			_canvasColor = bgColor;
			_canvas = new BitmapData(_width, _height, false, _canvasColor);

			_frame = new Rectangle(0,0, _width, _height);
			
			_destPos = new Point(0, 0);
			
		}
		
		public function PreUpdate():void
		{
			_canvas.fillRect(_frame, _canvasColor);
		}
		
		public function Update():void
		{
			
		}
		
		public function Scroll(x:int, y:int):void
		{
			_frame.x += x;
			_frame.y += y;
		}
		
		public function LateUpdate():void
		{
			_stateCanvas.copyPixels(_canvas, _frame, _destPos);
		}
		
		public function FollowTarget(entity:KSSEntity):void
		{
			_target = entity;
		}
		
		public function CenterOnTarget(entity:KSSEntity):void
		{
			_target = entity;
		}
		
	}

}