/**
 * LOCALISATION
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 * language file exemple :
 * 
 * 	//begin
 * 		
 * 		[LANG=FR]
 *		title[M]text[E]
 * 	
 *  //end
 * 
 */

package railk.as3.ui
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import railk.as3.TopLevel;
	import railk.as3.pattern.singleton.Singleton;
	
	public class Localisation extends EventDispatcher
	{
		private var current:String = '';
		private var data:Dictionary = new Dictionary(true);
		
		public static function getInstance():Localisation{
			return Singleton.getInstance(Localisation);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function Localisation() { Singleton.assertSingle(Localisation); }
		
		/**
		 * ADD LANGUAGE
		 * @param	lang
		 */
		public function addLanguage(file:String):Localisation {
			if (file.length == 0) return this;
			var lang:String = file.match(/\[LANG=[A-Z]*\]/)[0].replace(/[\[|\]]/g,'').split('=')[1]; 
			var texts:Array = file.replace(/\[LANG=[A-Z]*\]/, '').replace(/\r|\t|\n/g, '').split('[E]');
			
			var a:Array, key:String;
			for (var i:int = 0; i < texts.length-1; i++) {
				a = texts[i].split('[M]'); 
				key = a[0];
				if (data[key] == undefined) data[key] = {};
				data[key][lang] = a[1];
			}
			return this;
		}
		
		public function setLanguage(lang:String):void {
			current = lang;
			dispatchEvent( new Event(Event.CHANGE));
		}
		
		/**
		 * GET THE TEXT IN THE CHOOSEN LANGUAGE
		 * @param	key
		 * @return
		 */
		public function getText(key:String):String { 
			return data[key][current]; 
		}
	}
}