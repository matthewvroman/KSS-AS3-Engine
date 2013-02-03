package org.kss.tilemaps 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * ...
	 * @author Matt
	 */
	/*******************************************************************************
	 * Shamelessly pulled from the TMX Parser files written by Thomas Jahn for Flixel
	 * Copyright (c) 2010 by Thomas Jahn
	 * This content is released under the MIT License.
	 ******************************************************************************/
	public class TMXLayer 
	{
		
		public var name:String;
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		public var opacity:Number;
		public var visible:Boolean;
		public var tileGIDs:Array;
		//public var allTileGIDS:Array;

		public function TMXLayer(src:XML) 
		{
			name = src.@name;
			x = src.@x; 
			y = src.@y; 
			width = src.@width; 
			height = src.@height; 
			visible = !src.@visible || (src.@visible != 0);
			opacity = src.@opacity;
			
			var node:XML;
			//load tile GIDs
			tileGIDs = [];
			var data:XML = src.data[0];
			if(data)
			{
				var chunk:String = "";
				if(data.@encoding.length() == 0)
				{
					//create a 2dimensional array
					var lineWidth:int = width;
					var rowIdx:int = -1;
					for each(node in data.tile)
					{
						//new line?
						if(++lineWidth >= width)
						{
							tileGIDs[++rowIdx] = [];
							lineWidth = 0;
						}
						var gid:int = node.@gid;
						tileGIDs[rowIdx].push(gid);
					}
				}
				else if(data.@encoding == "csv")
				{
					chunk = data;
					trace(chunk);
					tileGIDs = csvToArray(chunk, width);
				}
				else if(data.@encoding == "base64")
				{
					chunk = data;
					var compressed:Boolean = false;
					if(data.@compression == "zlib")
						compressed = true;
					else if(data.@compression.length() != 0)
						throw Error("TmxLayer - data compression type not supported!");
					
					//for (var i:int = 0; i < 100; i++) {
						tileGIDs = base64ToArray(chunk, width, compressed);	
						trace(tileGIDs);
						var tempTileGIDs:Array = new Array();
						for (var i:int = 0; i < tileGIDs.length; i++)
						{
							var splitArray:Array = String(tileGIDs[i]).split(",");
							for (var j:int = 0; j < splitArray.length; j++)
							{
								tempTileGIDs.push(splitArray[j]);
							}
						}
						tileGIDs = tempTileGIDs;
						trace(tileGIDs);
						//trace(tileGIDs[0]);
						trace("length: " + tileGIDs.length);
					//}
				}
			}
		}
		
		/*******************************************************************************
		 * Shamelessly pulled from the TMX Parser files written by Thomas Jahn for Flixel
		 * Copyright (c) 2010 by Thomas Jahn
		 * This content is released under the MIT License.
		 ******************************************************************************/
		public static function csvToArray(input:String, lineWidth:int):Array
		{
			var result:Array = [];
			var rows:Array = input.split("\n");
			for each(var row:String in rows)
			{
				var resultRow:Array = [];
				var entries:Array = row.split(",", lineWidth);
				for each(var entry:String in entries)
					resultRow.push(uint(entry)); //convert to uint
				result.push(resultRow);
			}
			return result;
		}
		
		/*******************************************************************************
		 * Shamelessly pulled from the TMX Parser files written by Thomas Jahn for Flixel
		 * Copyright (c) 2010 by Thomas Jahn
		 * This content is released under the MIT License.
		 ******************************************************************************/
		public static function base64ToArray(chunk:String, lineWidth:int, compressed:Boolean):Array
		{
			var result:Array = [];
			var data:ByteArray = base64ToByteArray(chunk);
			if(compressed)
				data.uncompress();
			data.endian = Endian.LITTLE_ENDIAN;
			while(data.position < data.length)
			{
				var resultRow:Array = [];
				for(var i:int = 0; i < lineWidth; i++)
					resultRow.push(data.readInt())
				result.push(resultRow);
			}
			return result;
		}
		
		/*******************************************************************************
		 * Shamelessly pulled from the TMX Parser files written by Thomas Jahn for Flixel
		 * Copyright (c) 2010 by Thomas Jahn
		 * This content is released under the MIT License.
		 ******************************************************************************/
		private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		
		public static function base64ToByteArray(data:String):ByteArray 
		{
			var output:ByteArray = new ByteArray();
			//initialize lookup table
			var lookup:Array = [];
			for(var c:int = 0; c < BASE64_CHARS.length; c++)
				lookup[BASE64_CHARS.charCodeAt(c)] = c;

			var outputBuffer:Array = new Array(3);
			
			for (var i:uint = 0; i < data.length - 3; i += 4) 
			{
				//read 4 bytes and look them up in the table
				var a0:int = lookup[data.charCodeAt(i)];
				var a1:int = lookup[data.charCodeAt(i + 1)];
				var a2:int = lookup[data.charCodeAt(i + 2)];
				var a3:int = lookup[data.charCodeAt(i + 3)];
			
				// convert to and write 3 bytes
				if(a1 < 64)
					output.writeByte((a0 << 2) + ((a1 & 0x30) >> 4));
				if(a2 < 64)
					output.writeByte(((a1 & 0x0f) << 4) + ((a2 & 0x3c) >> 2));
				if(a3 < 64)
					output.writeByte(((a2 & 0x03) << 6) + a3);
			}
			
			// Rewind & return decoded data
			output.position = 0;
			return output;
		}
		
		
		
	}

}