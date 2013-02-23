package org.kss.tilemaps 
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.kss.KSSCanvas;
	import org.kss.KSSEntity;
	import org.kss.KSSState;
	import org.kss.components.KSSCollider;
	import org.kss.tilemaps.TMXTileInfo;
	/**
	 * ...
	 * @author Matt
	 */
	public class TMXMap extends KSSEntity
	{
		
		private var _canvas:KSSCanvas; //canvas to draw to
		
		private var _mapWidth:Number;
		private var _mapHeight:Number;
		private var _tileWidth:Number;
		private var _tileHeight:Number;
		
		private var _tileSets:Vector.<TMXTileSet> = new Vector.<TMXTileSet>();
		private var _objectGroups:Vector.<TMXObjectGroup> = new Vector.<TMXObjectGroup>();
		public function get ObjectGroups():Vector.<TMXObjectGroup>{ return _objectGroups; }
		
		private var _layers:Vector.<TMXLayer> = new Vector.<TMXLayer>();
		
		public var loadedCallback:Function;
		
		// Bits on the far end of the 32-bit global tile ID are used for tile flags
		private const FLIPPED_HORIZONTALLY_FLAG:uint = 0x80000000;
		private const FLIPPED_VERTICALLY_FLAG:uint  = 0x40000000;
		private const FLIPPED_DIAGONALLY_FLAG:uint   = 0x20000000;
		
		private var _fileDirectory:String="";
		
		public function get ready():Boolean
		{
			for (var i:int = 0; i < _tileSets.length; i++)
			{
				if (!_tileSets[i].loaded) return false;
			}
			
			return true;
		}
		
		public function TMXMap(state:KSSState, canvas:KSSCanvas, filepath:String) 
		{
			super(state);
			_canvas = canvas;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onMapLoaded);
			loader.load(new URLRequest(filepath));
			
			var folders:Array = filepath.split('/');
			if(folders.length>0){
				for (var i:int = 0; i < folders.length-1; i++)
				{
					trace(folders[i]);
					_fileDirectory += folders[i] + "/";
				}
			}
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
			
			if (loadedCallback!=null)
			{
				loadedCallback();
			}
		}
		
		public function parseTileSets(src:XML):void
		{
			for (var i:int = 0; i < src.tileset.length(); i++)
			{
				_tileSets.push(new TMXTileSet(src.tileset[i],_fileDirectory));
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
	
		public function getSurroundingTiles(rect:Rectangle, tileBuffer:int):Vector.<TMXTileInfo>
		{
			//determine tile that point is in
			var startingColumn:int = int(rect.x / _tileWidth);
			var numColumnsInRect:int = int(rect.width / _tileWidth);;
			var numColumnsToReturn:int = startingColumn + numColumnsInRect + tileBuffer;
			var startingRow:int = int(rect.y / _tileHeight);
			var numRowsInRect:int = int(rect.height/_tileHeight);
			var numRowsToReturn:int = startingRow + numRowsInRect + tileBuffer;
			
			var numLayers:int = _layers.length;
			var numColumns:int = _mapWidth;
			var tile:TMXTile;
			var tilePos:Point = new Point(0, 0);
			
			var surroundingTiles:Vector.<TMXTileInfo> = new Vector.<TMXTileInfo>();
			for (var i:int = startingRow; i < numRowsToReturn; i++)
			{
				for (var j:int = startingColumn; j < numColumnsToReturn; j++)
				{
					for (var k:int = 0; k < numLayers; k++){
						var gid:uint = _layers[k].tileGIDs[j+(i*numColumns)];
						tile = getTile(gid);
						tilePos.x = j * _tileWidth;
						tilePos.y = i * _tileHeight;
						if(tile!=null)
							surroundingTiles.push(new TMXTileInfo(tile,tilePos.clone()));
					}
				}
			}
			
			return surroundingTiles;
		}
		
		override public function Draw():void
		{
			if (!ready) return;
			
			super.Draw();
			
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
		/*
		public function setupCollision():void
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
					var gid:uint = _layers[0].tileGIDs[j+(i*numColumns)];
					tileSet = getTileSetWithGID(gid);
					tile = getTile(gid);
					tilePos.x = j * _tileWidth;
					tilePos.y = i * _tileHeight;
					if (tileSet != null && tile != null) {
						if (tile.GetPropertyByName("collision"))
						{
							var worldRect:Rectangle = new Rectangle(tilePos.x, tilePos.y, _tileWidth, _tileHeight);
							var collider:KSSCollider = new KSSCollider(this, worldRect);
							collider.active = false;
							AddComponent(collider);
							trace("added collider at: " + worldRect);
						}
					}
				}
			}
		}
		*/
		public function getTileSetWithGID(gid:uint):TMXTileSet
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