/**
 * Texte manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.text
{	
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import railk.as3.pattern.singleton.Singleton;
	
	public class TextManager
	{
		public static function getInstance():TextManager{
			return Singleton.getInstance(TextManager);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function TextManager() { Singleton.assertSingle(TextManager); }
		
		
		public function add(text:TextField):void {
			
		}
		
		public function remove(text:TextField):void {
			
		}
		
		public function search(word:String):void {
			
		}
		
		public function highLight(word:String):void {
			
		}
	}
}