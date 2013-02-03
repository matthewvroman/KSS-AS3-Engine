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
		
		public function get ready():Boolean
		{
			for (var i:int = 0; i < _tileSets.length; i++)
			{
				if (!_tileSets[i].loaded) return false;
			}
			
			return true;
		}
		
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
			if (!ready) return;
			//TODO: some of these values should only be assigned once not recalculated every frame
			//cull based on camera frame
			var cameraFrame:Rectangle = _canvas.currentCamera.frame;
			var buffer:int = 2;
			var startingRow:int = int(cameraFrame.y / _tileHeight);
			var numRowsInFrame:int = int(cameraFrame.height / _tileHeight);
			var numRowsToDraw:int = startingRow + numRowsInFrame + buffer;
			var startingColumn:int = int(cameraFrame.x / _tileWidth);
			var numColumnsInFrame:int = (cameraFrame.width / _tileWidth);
			var numColumnsToDraw:int = startingColumn + numColumnsInFrame + buffer;
			var numColumns:int = _mapWidth;
			var numRows:int = _mapHeight;
			var numLayers:int = _layers.length;
			var tilePos:Point = new Point(0, 0);
			var tileSet:TMXTileSet;
			var tile:TMXTile;
			for (var i:int = startingRow; i < numRowsToDraw; i++)
			{
				for (var j:int = startingColumn; j < numColumnsToDraw; j++)
				{
					for (var k:int = 0; k < numLayers; k++){
						var gid:uint = _layers[k].tileGIDs[j+(i*numColumns)];
						tileSet = getTileSetWithGID(gid);
						tile = getTile(gid);
						tilePos.x = j * _tileWidth;
						tilePos.y = i * _tileHeight;
						if (tileSet != null && tile != null) {
							_canvas.RequestRender(tileSet.bitmapData, tile.rect, tilePos);
						}
					}
				}
			}
			
			/*draw everything
			var numColumns:int = _mapWidth;
			var numRows:int = _mapHeight;
			var tilePos:Point = new Point(0, 0);
			var tileSet:TMXTileSet;
			var tile:TMXTile;
			for (var i:int = 0; i < numRows; i++)
			{
				for (var j:int = 0; j < numColumns; j++)
				{
					var gid:uint = _layers[0].tileGIDs[j+(i*numColumns)];
					tileSet = getTileSetWithGID(gid);
					tile = getTile(gid);
					tilePos.x = j * _tileWidth;
					tilePos.y = i * _tileHeight;
					if (tileSet != null && tile != null) {
						_canvas.RequestRender(tileSet.bitmapData, tile.rect, tilePos);
					}
				}
			}*/
		}
		
		public function getTileSetWithGID(gid:uint):TMXTileSet
		{
			for (var i:int = 0; i < _tileSets.length; i++)
			{
				if (_tileSets[i].FirstGID > gid) continue;

				return _tileSets[i];
			}
			
			return null;
		}
		
		public function getTile(gid:uint):TMXTile
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