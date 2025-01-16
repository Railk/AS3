package railk.as3.html
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.Capabilities;

	/**
	* Safe standalone open window
	* @author Philippe / http://philippe.elsass.me
	*/
	public class Window 
	{
		
		static public function open(url:String, name:String = null, width:int = 600, height:int = 600, 
			sizeable:Boolean = true, scrollbars:Boolean = true):void
		{
			var top:int = (Capabilities.screenResolutionY - height) / 2;
			var left:int = (Capabilities.screenResolutionX - width) / 2;
			var params:String = "top=" + top + ",left=" + left + ",width=" + width + ",height=" + height;
			if (sizeable) params += ",resize=yes";
			if (scrollbars) params += ",scrollbars=yes";
			if (name == null) name = "pop" + int(Math.random() * 65536);
			
			var script:XML = <![CDATA[
				function(url, name, params) {
					if (navigator.userAgent.toLowerCase().indexOf("chrome") < 0) {
						return window.open(url, name, params) != null;
					}
					else return false;
				}
			]]>;
			
			if (ExternalInterface.available)
			{
				if (!ExternalInterface.call(script, url, name, params))
					navigateToURL(new URLRequest(url));
			}
			else navigateToURL(new URLRequest(url));
		}
		
	}
}