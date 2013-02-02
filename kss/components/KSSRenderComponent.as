package org.kss.components 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.kss.KSSCanvas;
	import org.kss.KSSComponent;
	import org.kss.KSSEntity;
	import org.kss.animation.KSSAnimationFrame;
	import flash.display.PixelSnapping;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSRenderComponent extends KSSComponent
	{
		private var _canvas:KSSCanvas;
		private var _pixels:BitmapData;
		private var _bitmap:Bitmap;
		private var _rect:Rectangle;
		private var _position:Point; //position in the bitmap
		
		private var _worldPosition:Point = new Point(0, 0); //position to draw on current state
		
		private var _playAnimation:Boolean = false;
		private var _loop:Boolean = true;
		private var _animationArray:Array; //array containing ordered vectors of animations
		private var _currentAnimation:Array;
		private var _currentFrame:int = 0;
		private var _frameSpeed:int = 10; //play animation every '_frameSpeed' frames
		private var _frameCount:int = 0;
		
		public function KSSRenderComponent(entity:KSSEntity, canvas:KSSCanvas) 
		{
			super(entity);
			
			_canvas = canvas;
		}
		
		public function set bitmap(data:Bitmap):void
		{
			_bitmap = data;
			_pixels = _bitmap.bitmapData;
			
		}
		public function set pixels(data:BitmapData):void
		{
			_pixels = data;
		}
		
		public function set rect(data:Rectangle):void
		{
			_rect = data;
		}
		
		public function set position(data:Point):void
		{
			_position = data;
		}
		
		public function Render():void
		{
			if (!_pixels) return;
			
			
			_worldPosition.x = _position.x + _entity.position.x;
			_worldPosition.y = _position.y + _entity.position.y;
			
			updateAnimation();
			
			//_canvas.copyPixels(_pixels, _rect, _worldPosition);
			_canvas.RequestRender(_pixels, _rect, _worldPosition);
			
			//Debug Draw rectangle
			//_canvas.copyPixels(new BitmapData(_rect.width, _rect.height, true, 0x77FF0000),_rect,_worldPosition);
		}
		
		//TODO: organize by labels and then sort by frame position
		public function AddAnimationFrame(frameRect:Rectangle,frameLabel:String="",framePosition:int=-1):void
		{
			//if (!_frames) _frames = new Vector.<KSSAnimationFrame>();
			if (!_animationArray){ _animationArray = new Array(); }
			
			var newFrame:KSSAnimationFrame = new KSSAnimationFrame(frameRect, frameLabel, framePosition);
			//_frames.push(newFrame);
			
			var newAnimationLabel:Boolean = true;
			for (var i:int = 0; i < _animationArray.length; i++)
			{
				if (_animationArray[i].length>0 && _animationArray[i][0].label == frameLabel)
				{
					_animationArray[i].push(newFrame);
					newAnimationLabel = false;
					//reorder frames
					_animationArray[i].sort(sortByFramePosition);
				}
			}
			
			//new label
			if (newAnimationLabel)
			{
				_animationArray.push(new Array(newFrame));
			}
		}
		
		//Lower number gets placed in front of higher number
		private function sortByFramePosition(a:KSSAnimationFrame, b:KSSAnimationFrame):int
		{
			if(a.position<b.position)
				return -1;
			else if(a.position>b.position)
				return 1;
			else
				return 0;
		}
		
		public function updateAnimation():void
		{
			if (_playAnimation)
			{
				_frameCount++;
				if(_frameCount%_frameSpeed==0){
					_frameCount = 0;
				}else{
					return;
				}
				
				_rect = _currentAnimation[_currentFrame].rect;
				
				if (_currentFrame >= _currentAnimation.length-1)
				{
					if (_loop) _currentFrame = -1;
					else _playAnimation = false;
				}
				_currentFrame++;
			}
		}
		
		public function play(animationName:String="",loop:Boolean=true):void
		{
			if (!_animationArray) return;
			
			_loop = loop;
			_playAnimation = true;
			
			//find animation based on label
			for (var i:int = 0; i < _animationArray.length; i++)
			{
				if (_animationArray[i][0].label == animationName)
				{
					_currentAnimation = _animationArray[i];
					return;
				}
			}
			_currentAnimation = _animationArray[0]; //default
		}
		
		public function stop():void
		{
			_playAnimation = false;
		}
		
	}

}