/**
* Logger
* 
* @author Richard Rodney
* @version 0.2
*/

package railk.as3.utils 
{
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	
	public class Logger 
	{
		static public var enabled:Boolean;
		static private var stg:Stage;
		static private var txt:TextField;
		static private var tpe:String;
		/**
		 * START
		 */
		static public function init(stage:Stage,color:uint=0x000000,type:String="all"):void {
			enabled = true; 
			stg = stage;
			tpe = type;
			txt = stg.addChild(new TextField()) as TextField;
			txt.height = stg.stageHeight;
			txt.width = 400;
			txt.wordWrap = true;
			txt.textColor = color;
			txt.mouseEnabled = false;
			print('LOGGER IS '+type.toUpperCase(),"start");
		}
		
		/**
		 * MESSAGE
		 */
		static public function log( ...info ):void { if ( enabled) print( inline(info),'log' ); }
		static public function warn( ...info ):void { if ( enabled) print( inline(info),'warn' ); }
		static public function error( ...info ):void { if ( enabled) print( inline(info), 'error' ); }
		static public function debug( ...info ):void { if ( enabled) print( inline(info), 'debug' ); }
		
		/**
		 * UTILITIES
		 */
		static private function inline(info:Array):String { return String(info).replace(',', ' '); }
		
		static private function print(mess:String, type:String):void {
			if (type != tpe && tpe != "all" && type != "start") return;
			trace( '[' + type.toUpperCase() + '] ' + mess );
			txt.text = '[' + type.toUpperCase() + '] ' + mess + '\n' + txt.text;
			if (ExternalInterface.available) ExternalInterface.call('console.'+type, '['+type.toUpperCase()+'] '+mess);
			stg.swapChildrenAt(stg.getChildIndex(txt), (stg.numChildren==0)?0:stg.numChildren-1);
		}
	}
}