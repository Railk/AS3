/**
 * Font Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui
{
	import flash.text.Font;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public class FontManager
	{
		static private var registeredFonts:Dictionary = new Dictionary(true);
		
		static public function addFonts(...fonts):void {
			for (var i:int = 0; i < fonts.length; i++) addFont(fonts[i])
		}
		
		static public function addFont(name:String):void {
			var c:Class = getDefinitionByName( name ) as Class;
			Font.registerFont(c);
			registeredFonts[name] = (new c()).fontName;
		}
		
		static public function hasLocalFont( name:String ):Boolean {
			var localFonts:Array = Font.enumerateFonts(true);
			for (var i:int = 0; i < localFonts.length; ++i) if ( (localFonts[i] as Font).fontName == name ) return true;
			return true;
		}
		
		static public function getFont(name:String):String {
			if ( registeredFonts[name] != undefined) return registeredFonts[name];
			throw new Error("la font n'existe pas");
		}
	}
}