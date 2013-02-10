package org.kss 
{
	
	import adobe.utils.ProductManager;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.kss.components.KSSCollider;
	import org.kss.components.KSSRenderer;
	import org.kss.KSSEntity;
	import org.kss.helpers.KSSInput;
	/**
	 * ...
	 * @author Matt
	 */
	public class KSSButton extends KSSEntity
	{
		[Embed(source = '../data/DefaultButton.png')]
		public static const DefaultGraphic:Class;
		
		private var _graphic:Bitmap;
		public function get graphic():Bitmap { return _graphic; }
		
		private var _onMouseOverFunction:Function = new Function();
		public function set onMouseOver(callback:Function):void { _onMouseOverFunction = callback; }
		
		private var _onMouseOutFunction:Function = new Function();
		public function set onMouseOut(callback:Function):void { _onMouseOutFunction = callback; }
		
		private var _onClickFunction:Function = new Function();
		public function set onClick(callback:Function):void { _onClickFunction = callback; }
		
		private var _collider:KSSCollider;
		private var _renderer:KSSRenderer;
		
		private var _mouseInside:Boolean=false;
		
		public function KSSButton(state:KSSState,graphic:Bitmap=null) 
		{
			super(state);
			
			if (!graphic)
			{
				_graphic = new DefaultGraphic();
			}else{
				_graphic = graphic;
			}
			
			_renderer = new KSSRenderer(this, state.Canvas);
			_renderer.bitmap = _graphic;
			_renderer.position = new Point(0, 0);
			AddComponent(_renderer);

			_collider = new KSSCollider(this, new Rectangle(0, 0, _graphic.width, _graphic.height));
			
		}
		
		
		override public function Update():void
		{
			super.Update();
			
			if (_collider.worldBounds.containsPoint(KSSInput.MousePosition))
			{
				if(!_mouseInside){
					_onMouseOverFunction(this);
					_mouseInside = true;
				}
				
				if (KSSInput.MouseClicked)
				{
					_onClickFunction(this);
				}
			}
			else
			{
				if (_mouseInside)
				{
					_onMouseOutFunction(this);
					_mouseInside = false;
				}
			}
		}
		
		
		
	}

}