package org.kss.tilemaps 
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.kss.KSSCanvas;
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXMap 
	{
		
		private var _canvas:KSSCanvas; //canvas to draw to
		
		private var _mapWidth:Number;
		private var _mapHeight:Number;
		private var _tileWidth:Number;
		private var _tileHeight:Number;
		
		private var _tileSets:Vector.<TMXTileSet> = new Vector.<TMXTileSet>();
		private var _objectGroups:Vector.<TMXObjectGroup> = new Vector.<TMXObjectGroup>();
		private var _layers:Vector.<TMXLayer> = new Vector.<TMXLayer>();
		
		public function TMXMap(canvas:KSSCanvas, filepath:String) 
		{
			
			_canvas = canvas;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onMapLoaded);
			loader.load(new URLRequest(filepath));
		}
		
		private function onMapLoaded(e:Event):void
		{
			var src:XML = new XML(e.target.data);
			//trace(src);
			
			//assign map properties
			_mapWidth = src.@width;
			_mapHeight = src.@height;
			_tileWidth = src.@tilewidth;
			_tileHeight = src.@tileheight;
			
			parseTileSets(src);
			parseTMXLayers(src);
			parseTMXObjectGroups(src);
		}
		
		public function parseTileSets(src:XML):void
		{
			for (var i:int = 0; i < src.tileset.length(); i++)
			{
				_tileSets.push(new TMXTileSet(src.tileset[i]));
			}
		}
		
		public function parseTMXLayers(src:XML):void
		{
			for (var i:int = 0; i < src.layer.length(); i++)
			{
				_layers.push(new TMXLayer(src.layer[i]));
			}
		}
		
		public function parseTMXObjectGroups(src:XML):void
		{
			for (var i:int = 0; i < src.objectgroup.length(); i++)
			{
				_objectGroups.push(new TMXObjectGroup(src.objectgroup[i]));
			}
		}
		
		public function draw():void
		{
			var numColumns:int = _mapWidth;
			var numRows:int = _mapHeight;
			var tilePos:Point = new Point(0, 0);
			var tileSet:TMXTileSet;
			var tile:TMXTile;
			for (var i:int = 0; i < numRows; i++)
			{
				for (var j:int = 0; j < numColumns; j++)
				{
					var gid:int = _layers[0].tileGIDs[j+(i*numColumns)];
					tileSet = getTileSetWithGID(gid);
					tile = getTile(gid);
					tilePos.x = j * _tileWidth;
					tilePos.y = i * _tileHeight;
					if (tileSet != null && tile != null) {
						_canvas.RequestRender(tileSet.bitmapData, tile.rect, tilePos);
					}
				}
			}
			//_canvas.RequestRender(_tileSets[0].bitmapData, new Rectangle(0, 0, 32, 8), new Point(0, 0));
		}
		
		public function getTileSetWithGID(gid:int):TMXTileSet
		{
			for (var i:int = 0; i < _tileSets.length; i++)
			{
				if (_tileSets[i].FirstGID > gid) continue;

				return _tileSets[i];
			}
			
			return null;
		}
		
		public function getTile(gid:int):TMXTile
		{  
			for (var i:int = 0; i < _tileSets.length; i++)
			{
				if (_tileSets[i].FirstGID > gid) continue;

				return _tileSets[i].getTile(gid);
			}
			
			return null;
		}
		
	}

}