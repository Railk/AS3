/**
 * Folder
 * 
 * @author Richard Rodney
 */

package railk.as3.ui
{
	import flash.display.Stage;
	public class Folder
	{
		public static var stage:Stage;
		public static function init(s:Stage):void { stage = s; }
		public static function get folder():String {
			var regLocal:RegExp = new RegExp("file:///[A-Z][|]/", "");
			var regLocalExtended:RegExp = new RegExp("file:///[A-Z][|]/[0-9A-Za-z%_./]*/www/", "");
			var regServer:RegExp = new RegExp("http://[A-Za-z0-9.]*/", "");
			var folder:String = unescape( stage.loaderInfo.loaderURL );
			if ( folder.search(regLocal) != -1) folder = folder.replace( regLocalExtended, '');
			else if ( folder.search(regServer) != -1) folder = folder.replace( regServer, '');
			return folder.replace(folder.split('/')[folder.split('/').length - 1], "");
		}
		public static function get url():String {
			return stage.loaderInfo.loaderURL.replace(stage.loaderInfo.loaderURL.split('/')[stage.loaderInfo.loaderURL.split('/').length - 1], "");
		}
	}
}