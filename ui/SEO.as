/**
 * SEO
 * 
 * @author Richard Rodney
 * @version 0.1
 */


package railk.as3.ui
{
	import flash.external.ExternalInterface;
	public class SEO
	{	
		private static const FUNCTION_SETCONTENT:String = 
		"function ()" +
		"{ " +
			"if (document.seo_setContent==null)" +
			"{" +
				"seo_setContent = function (id,content)" +
				"{" +
					"document.getElementById(id).innerHTML = content;"+
				"}" +
			"}" +
		"}";
		
		public static function init():void {
			if (ExternalInterface.available ) ExternalInterface.call(FUNCTION_SETCONTENT);
		}
			
		public static function setNav(data:Array):void {
			var content:String="";
			for (var i:int = 0; i < data.length; i++) content += data[i] + '\n';
			if(ExternalInterface.available ) ExternalInterface.call('seo_setContent', 'sitenav', content);
		}
		
		public static function setContent(data:String):void {
			if(ExternalInterface.available ) ExternalInterface.call('seo_setContent', 'copy', data);
		}
	}
}