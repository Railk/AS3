/**
 * Deserialize
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.foil
{
	import railk.as3.pattern.singleton.Singleton;
	import railk.as3.data.tree.TreeNode;
	import railk.as3.data.list.DLinkedList;
	import railk.as3.data.list.DListNode;
	
	public class Deserialize
	{
		public var type:String;
		public var name:String;
		public var info:String;
		
		private var rawData:String;
		private var toParse:String;
		private var pos:int = 0;
		
		private var root:TreeNode;
		private var node:TreeNode;
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 GET INSTANCE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function getInstance():Deserialize {
			return Singleton.getInstance(Deserialize);
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	SINGLETON
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Deserialize() { Singleton.assertSingle(Deserialize); }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 		 FEED
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function feed( rawData:String ):Object {
			if( root ) root.clear();
			this.rawData = rawData;
			toParse = rawData.replace(/[\t|\n]/mg, '');
			
			/////////////////////////////////////////////////////
			parseInfos( toParse );
			parseObjects( getData( toParse, 'Object' ), root );
			/////////////////////////////////////////////////////
			
			return { type:type, name:name, info:info, data:exportData( root ) };
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  PARSE FILE INFO
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function parseInfos( data:String ):void {
			var type:RegExp = /type[ ]{0,}:['|"][a-zA-Z0-9 -+=@#$£&%§_:,;'?\/!.~"çêéèàùïîöô\[\]()<>]{0,}['|"]/;
			var name:RegExp = /name[ ]{0,}:['|"][a-zA-Z0-9 -+=@#$£&%§_:,;'?\/!.~"çêéèàùïîöô\[\]()<>]{0,}['|"]/;
			var info:RegExp = /info[ ]{0,}:['|"][a-zA-Z0-9 -+=@#$£&%§_:,;'?\/!.~"çêéèàùïîöô\[\]()<>]{0,}['|"]/;
			
			this.type = (data.match(type)[0] as String).split(':')[1].replace(/["|']/g,"");
			this.name = (data.match(name)[0] as String).split(':')[1].replace(/["|']/g,"");
			this.info = (data.match(info)[0] as String).split(':')[1].replace(/["|']/g,"");
			
			///////////////////////////////////////////////////////////////////////
			root = new TreeNode( this.name, { type:this.type, info:this.info } );
			///////////////////////////////////////////////////////////////////////
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						PARSE CONTENT
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function parseObjects( data:Array, parent:TreeNode ):void {
			var content:String;
			var beginBloc:RegExp = /[a-zA-Z0-9 ]{0,}:[\r]{0,}\{/;
			
			for ( var i:int = 0; i< data.length; i++)
			{
				content = data[i].data;
				node = new TreeNode( (content.match(beginBloc)[0] as String).split(':')[0],null,parent );
				content = content.replace(beginBloc, '');
				content = content.slice(0, content.length - 1);
				
				//////////////////////////////////////////////
				parseContent( content, node);
				//////////////////////////////////////////////
			}
		}
		
		private function parseContent( data:String, parent:TreeNode ):void {
			var type:String;
			var content:Array = ['Object', 'Function', 'String', 'Array', 'Number', 'Custom', 'Boolean'];
			var classes:Array = [ FoilObject, FoilFunction, FoilString, FoilArray, FoilNumber, FoilCustom, FoilBoolean];
			for (var i:int = 0; i < content.length ; i++) {
				type = content[i];
				content[i] = getData(data, type );
				data  = reduceData( content[i], data );
				if (type != 'Object') createData( content[i], classes[i], parent );
				else parseObjects( content[i], parent );
			}
			
			
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							 GET DATA
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function getData( data:String, type:String ):Array {
			var result:Array = [];
			result = this['get'+type+'s']( data );
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  GET STRINGS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function getStrings( data:String ):Array {
			var result:Array = [];
			var reg:RegExp = /[a-zA-Z0-9 ]{1,}:['|\"]/;
			var pos:int = data.search(reg);
			var beginPos:int = pos;
			
			var bChar:RegExp = /['|"]/;
			var eChar:RegExp = /['|"][,|\r]/;
			
			var isArray:Boolean = false;
			var isString:Boolean = false;
			var stringType:String = '';
			
			var char:String;
			loop:while ( pos < data.length ) {
				char = data.charAt(pos);
				if ( !char.search(bChar) )
				{
					isString = true;
					stringType = char;
				}
				if ( !isString && char == '[') isArray = true;
				if ( !isString && char == ']') isArray = true;
				if ( isString ) {
					var toCheck:String=char+data.charAt(pos+1);
					if ( !toCheck.search(eChar) && char == stringType && !isArray ) {
						result.push( { data:data.slice(beginPos, pos + 1 ), begin:beginPos, end: pos+1} );
						isString = false;
						stringType = '';
						
						var found:Number = data.slice(pos + 1, data.length - 1).search(reg);
						if ( found == -1 ) beginPos = pos;
						else beginPos = pos = pos + found;
					}
				}
				pos++;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   GET ARRAYS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function getArrays( data:String ):Array {
			var result:Array = [];
			var reg:RegExp = /[a-zA-Z0-9 ]{1,}:\[/;
			var pos:int = data.search(reg);
			var beginPos:int = pos;
			
			var bChar:RegExp = /[\[]/;
			var eChar:RegExp = /[\]][,|\r]/;
			var isArray:Boolean = false;
			
			var char:String;
			loop:while ( pos < data.length ) {
				char = data.charAt(pos);
				if ( !char.search(bChar) )isArray = true;
				if ( isArray ) {
					var toCheck:String=char+data.charAt(pos+1);
					if ( !toCheck.search(eChar) ) {
						result.push( { data: data.slice(beginPos, pos + 1 ), begin:beginPos, end: pos + 1 } );
						isArray = false;
						
						var found:Number = data.slice(pos + 1, data.length - 1).search(reg);
						if ( found == -1 ) beginPos = pos;
						else beginPos = pos = pos + found;
					}
				}
				pos++;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  GET NUMBERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function getNumbers( data:String ):Array {
			var result:Array = [];
			var reg:RegExp = /[a-zA-Z0-9 ]{1,}:/;
			var pos:int = data.search(reg);
			var beginPos:int = pos;
			
			var bChar:RegExp = /[\d]/;
			var eChar:RegExp = /[\d][,|\r]/;
			var isNumber:Boolean = false;
			
			var char:String;
			loop:while ( pos < data.length ) {
				char = data.charAt(pos);
				if ( !char.search(bChar) ) isNumber = true;
				if ( isNumber )
				{
					var toCheck:String=char+data.charAt(pos+1);
					if ( !toCheck.search(eChar) ) 
					{
						result.push( { data: data.slice(beginPos, pos + 1 ), begin:beginPos, end: pos + 1 } );
						isNumber = false;
						
						var found:Number = data.slice(pos + 1, data.length - 1).search(reg);
						if ( found == -1 ) beginPos = pos;
						else beginPos = pos = pos + found;
					}
				}
				pos++;
			}
			
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 GET BOOLEANS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function getBooleans( data:String ):Array
		{
			var reg:RegExp = /[a-zA-Z0-9 ]{1,}:[ ]{0,}[true|false]{4,}/;
			var result:Array = data.match(reg);
			
			if(result) {
				for (var i:int = 0; i < result.length ; i++) 
				{
					var begin:int = data.search(result[i]);
					var end:int =  begin + result[i].length;
					result[i] = { data:result[i], begin:begin, end:end };
				}
			}
			else  result = [];
			
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  GET CUSTOMS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function getCustoms( data:String ):Array
		{
			var result:Array = [];
			var reg:RegExp = /[a-zA-Z0-9 ]{1,}:[ ]{0,}new/;
			var pos:int = data.search(reg);
			var beginPos:int = pos;
			
			var bChar:RegExp = /new/;
			var eChar:RegExp = /\)[,|\r]/;
			var isCustom:Boolean = false;
			
			var char:String, toCheck:String ;
			loop:while ( pos < data.length )
			{
				char = data.charAt(pos);
				toCheck = data.substr(pos, 3);
				if ( !toCheck.search(bChar) ) isCustom = true;
				if ( isCustom )
				{
					toCheck = char + data.charAt(pos + 1);
					if ( !toCheck.search(eChar) ) 
					{
						result.push( { data: data.slice(beginPos, pos + 1 ), begin:beginPos, end:pos+1 } );
						isCustom = false;
						
						var found:Number = data.slice(pos + 1, data.length - 1).search(reg);
						if ( found == -1 ) beginPos = pos;
						else beginPos = pos = pos + found;
					}
				}
				pos++;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  GET CUSTOMS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function getFunctions( data:String ):Array
		{
			var result:Array = [];
			var reg:RegExp = /[a-zA-Z0-9 ]{1,}:[ ]{0,}function\(/;
			var pos:int = data.search(reg);
			var beginPos:int = pos;
			
			var bChar:RegExp = /function\(/;
			var eChar:RegExp = /\}[,|\r]/;
			var isFunction:Boolean = false;
			
			var char:String, toCheck:String;
			loop:while ( pos < data.length )
			{
				char = data.charAt(pos);
				toCheck = data.substr(pos, 9);
				if ( !toCheck.search(bChar) ) isFunction = true;
				if ( isFunction )
				{
					toCheck = char + data.charAt(pos + 1);
					if ( !toCheck.search(eChar) ) 
					{
						result.push( { data: data.slice(beginPos, pos + 1 ), begin:beginPos, end:pos+1 } );
						isFunction = false;
						
						var found:Number = data.slice(pos + 1, data.length - 1).search(reg);
						if ( found == -1 ) beginPos = pos;
						else beginPos = pos = pos + found;	
					}
				}
				pos++;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  GET OBJECTS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function getObjects( data:String ):Array
		{
			var result:Array = [];
			var bloc:RegExp = /[a-zA-Z0-9 ]{1,}:[\n\r\t]{0,}\{/;
			var pos:int = data.search(bloc);
			var beginPos:int = pos;
			
			var bBegin:Boolean = false;
			var bEnd:Boolean = false;
			var subBegin:int = 0;
			var subEnd:int = 0;
			var isString:Boolean = false;
			var stringType:String = '';
			
			loop:while( pos < data.length )
			{
				switch( data.charAt(pos) )
				{
					case "{" :
						(bBegin)?(subBegin +=1):(bBegin = true);
						break;
					case "}" :
						if ( !isString )
						{
							(subBegin)?(subEnd +=1):(bEnd = true);
							if (subBegin == subEnd) 
							{
								subBegin = 0;
								subEnd = 0;
							}
							if (bBegin && bEnd)
							{
								bBegin = bEnd = false;
								result.push( { data:data.slice(beginPos, pos + 1), begin:beginPos, end:pos+1 } );
								beginPos = pos = pos + data.slice(pos + 1, data.length - 1).search(bloc);
							}
						}	
						break;
					case "'" :
						if (stringType == '')
						{
							isString = true;
							stringType = "'";
						}
						else if ( stringType == "'")
						{
							isString = false;
							stringType = '';
						}
						break;
					case '"' :
						if (stringType == '')
						{
							isString = true;
							stringType = '"';
						}
						else if ( stringType == '"')
						{
							isString = false;
							stringType = '';
						}
						break;
					default : break;
				}
				pos++;
			}
			return result;
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																							UTILITIES
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		private function reduceData( data:Array, string:String ):String {
			var result:String = '';
			var reduceLength:int=0;
			for (var i:int = 0; i < data.length ; i++) {
				result += string.slice(0, data[i].begin-reduceLength);
				result += string.slice(data[i].end - reduceLength, string.length );
				string = result;
				result = '';
				reduceLength = data[i].end - data[i].begin;
			}
			return string;
		}
		
		private function createData( data:Array, classe:Class, parent:TreeNode ):void {
			for (var i:int = 0; i < data.length ; i++) {
				var forNode:Array = (data[i].data as String).split(':');
				node = new TreeNode( forNode[0].replace(/[\r\t\n]/mg, ''), (new classe(forNode[1])).data, parent );
			}
		}
		
		private function exportData( from:TreeNode ):Array {
			var result:Array = new Array();
			var obj:Object ={};
			if( from.hasChildren()) {
				var walker:DListNode = from.childs.head;
				while (walker) {
					obj ={}
					var node:TreeNode = walker.data;
					if (node.hasChildren()) {
						obj[node.name] =subObject( node.childs );
						result.push( obj  );
					}
					else {
						obj[node.name] = node.data;
						result.push( obj );
					}
					walker = walker.next;
				}
			} else {
				obj[from.name] = from.data
				result.push( obj )
			}
			return result;
		}
		
		private function subObject( objects:DLinkedList ):Object {
			var result:Object ={};
			var walker:DListNode = objects.head;
			while (walker) {
				var node:TreeNode = walker.data;
				if (node.hasChildren()) result[node.name] =subObject( node.childs );
				else result[node.name] = node.data;
				walker = walker.next;
			}
			return result;
		}
	}	
}