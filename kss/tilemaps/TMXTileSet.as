package org.kss.tilemaps 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.display.LoaderInfo;
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXTileSet 
	{
		private var _firstGID:uint;
		public function get FirstGID():uint { return _firstGID; }
		private var _name:String;
		private var _tileWidth:int;
		private var _tileHeight:int;
		
		private var _imgSrc:String;
		private var _imgWidth:int;
		private var _imgHeight:int;
		
		private var _loading:Boolean = false;
		private var _loaded:Boolean = false;
		public function get loaded():Boolean { return _loaded; }
		
		private var _tiles:Vector.<TMXTile> = new Vector.<TMXTile>();
		
		private var _bitmapData:BitmapData;
		public function get bitmapData():BitmapData { return _bitmapData; }
		
		public function TMXTileSet(src:XML) 
		{
			trace(src);
			_firstGID = src.@firstgid;
			_name = src.@name;
			_tileWidth = src.@tilewidth;
			_tileHeight = src.@tileheight;
			
			_imgSrc = src.image.@source;
			_imgWidth = src.image.@width;
			_imgHeight = src.image.@height;
			
			loadImage();
			
			generateTileArray();
		}
		
		public function loadImage():void
		{
			if (!_imgSrc || _loading) return;
			
			_loading = true;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			loader.load(new URLRequest(_imgSrc));
		}
		
		public function onImageLoaded(e:Event):void
		{
			_loading = false;
			_loaded = true;
			
			_bitmapData = Bitmap(e.target.content).bitmapData; 
			
		}
		
		public function generateTileArray():void
		{
			var numColumns:int = int(_imgWidth / _tileWidth);
			var numRows:int = int(_imgHeight / _tileHeight);
			
			for (var i:int = 0; i < numRows; i++)
			{
				
				for (var j:int = 0; j < numColumns; j++)
				{
					var tile:TMXTile = new TMXTile(i + j + _firstGID, new Rectangle(j * _tileWidth, i * _tileHeight,_tileWidth,_tileHeight));
					_tiles.push(tile);
				}
			}
		}
		
		public function getTile(gid:uint):TMXTile
		{
			if(gid>0 && gid<(_firstGID+_tiles.length)){
				return _tiles[gid - _firstGID];
			}
			
			return null;
		}

	}

}