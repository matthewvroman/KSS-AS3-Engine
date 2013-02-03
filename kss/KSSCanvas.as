package org.kss 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.kss.KSSCamera;
	
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSCanvas extends BitmapData 
	{
		public var Cameras:Vector.<KSSCamera> = new Vector.<KSSCamera>();
		private var _currentCamera:KSSCamera;
		public function get currentCamera():KSSCamera { return _currentCamera; }
		public var DefaultCamera:KSSCamera;
		
		public function KSSCanvas(width:int, height:int, transparent:Boolean=true, fillColor:uint=4294967295) 
		{
			super(width, height, transparent, fillColor);
			
			DefaultCamera = new KSSCamera(width, height);
			SwitchCamera(DefaultCamera);
			
		}
		
		public function RequestRender(pixels:BitmapData, rect:Rectangle, pos:Point,scroll:Number=1):void
		{

			pos.x -= _currentCamera.frame.x*scroll;
			pos.y -= _currentCamera.frame.y*scroll;
			//TODO: don't copy pixels if they're outside the frame
			copyPixels(pixels, rect, pos);
		}
		
		public function SwitchCamera(camera:KSSCamera):void
		{
			_currentCamera = camera;
		}
		
	}

}