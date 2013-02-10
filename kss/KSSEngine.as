package org.kss 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.display.PixelSnapping;
	import org.kss.components.KSSCollider;
	import org.kss.helpers.KSSInput;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSEngine extends Sprite
	{	
		//State Machine
		private var _currentState:KSSState;
		public function get currentState():KSSState { return _currentState; }
		public var DefaultState:KSSState;
		
		//Canvas - Everything is drawn to this
		private var CanvasData:KSSCanvas;
		private var Canvas:Bitmap;
		public function get WriteCanvas():KSSCanvas { return CanvasData; }
		private var CanvasRect:Rectangle;
		private var CanvasColor:uint;

		private var _tickPosition:Number;
		private var _tickLastPosition:Number;
		private var _framePeriod:Number = 1; //paramatize this
		
		private var _fps:int;
		
		private var _input:KSSInput;
		
		private var _t:int;
		public static var deltaTime:Number = 0; 
		
		private static var _stageScale:Number;
		
		public function KSSEngine(width:int = 640, height:int = 360, scale:Number = 1.0, bgColor:uint = 0x000000, fps:int = 60 ) 
		{
			
			CanvasData = new KSSCanvas(width, height,false,bgColor);
			Canvas = new Bitmap(CanvasData);
			Canvas.scaleX = Canvas.scaleY = scale;
			_stageScale = scale;
			CanvasRect = new Rectangle(0, 0, width, height);
			CanvasColor = bgColor;
			Canvas.smoothing = false;
			
			_fps = fps;
			
			DefaultState = new KSSState(this);
			
			if (stage) init();
				else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		public static function get StageScale():Number
		{
			return _stageScale;
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.frameRate = _fps;
			
			_input= new KSSInput(stage);
			
			addChild(Canvas);

			_currentState = DefaultState;
			
			_t = getTimer();
			
			this.addEventListener(Event.ENTER_FRAME, OnEnterFrame);
		}
		
		private function OnEnterFrame(e:Event):void
		{
			
			_tickPosition = int((getTimer() % 1000) / _framePeriod);
			var t:int = getTimer();
			deltaTime = (t- _t) * 0.001;
			_t = t;

		   if (_tickLastPosition != _tickPosition)
		   {
				_tickLastPosition = _tickPosition;
				CanvasData.lock();
				CanvasData.fillRect(CanvasRect, CanvasColor);
				PreUpdate();
				Update();
				LateUpdate();
				CanvasData.unlock();
				_input.flush();
				
		   }
		   
		   
		}
		
		public function SwitchStates(state:KSSState):void
		{
			_currentState.Destroy();
			_currentState = state;
		}
		
		public function PreUpdate():void
		{
			_currentState.PreUpdate();
			CanvasData.currentCamera.PreUpdate();
		}
		
		public function Update():void
		{
			_currentState.Update();
			CanvasData.currentCamera.Update();
		}
		
		public function LateUpdate():void
		{
			_currentState.LateUpdate();
			CanvasData.currentCamera.LateUpdate();
		}
		
	}

}