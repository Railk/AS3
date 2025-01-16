/**
*   COOKIE UTIL
* 	
* 	@original http://myflex.wordpress.com/2008/11/12/actionscript-cookie-util/
*   @author Alexander
* 
* 	SWFCOOKIE / REWRITE
* 
* 	@javascript http://techpatterns.com/downloads/javascript_cookies.php
* 	@author Richard Rodney
* 	@version 0.1
*/

package railk.as3.utils
{
	import flash.external.ExternalInterface;
	public class CookieUtil
	{
		private static const ADD_COOKIE:String = "SWFCookie.add";
		private static const REMOVE_COOKIE:String = "SWFCookie.remove";
		private static const GET_COOKIE:String = "SWFCookie.get";
		private static const ENABLE_SWFCOOKIE:String = "function() {if (window.SWFCookie) return;var SWFCookie = window.SWFCookie = {};SWFCookie.add = function (name, value, expire) { var exdate = new Date(); exdate.setDate(exdate.getDate() + expire); document.cookie = name + '=' +escape(value) + ((expire == null) ? '' : ';expires=' + exdate.toUTCString()); };SWFCookie.get = function ( name ) { var a_all_cookies = document.cookie.split( ';' );var a_temp_cookie = '';var cookie_name = '';var cookie_value = '';var b_cookie_found = false;for ( i = 0; i < a_all_cookies.length; i++ ){a_temp_cookie = a_all_cookies[i].split( '=' );cookie_name = a_temp_cookie[0].replace(/^\s+|\s+$/g, '');if ( cookie_name == name ){b_cookie_found = true;if ( a_temp_cookie.length > 1 ){cookie_value = unescape( a_temp_cookie[1].replace(/^\\s+|\\s+$/g, '') );}return cookie_value;break;}a_temp_cookie = null;cookie_name = '';}if ( !b_cookie_found ){return null;}};SWFCookie.remove = function ( name ) { if (SWFCookie.get( name )){ document.cookie = name+'='+';expires=Thu, 01-Jan-1970 00:00:01 GMT'; }};}";
		
		/**
		 * INIT
		 */
		public static function init():void {
			if (!available) return;
            ExternalInterface.call( ENABLE_SWFCOOKIE );
		}
		
		/**
		 * ADD
		 * 
		 * @param	name
		 * @param	value
		 * @param	expire
		 */
		public static function add(name:String, value:String, expire:int):void {
			if (!available) return;
			ExternalInterface.call(ADD_COOKIE, name, value, expire);
		}
		
		/**
		 * REMOVE
		 * 
		 * @param	name
		 */
		public static function remove(name:String):void {
			if (!available) return;
			ExternalInterface.call(REMOVE_COOKIE,name);
		}
		
		/**
		 * CHECK
		 * 
		 * @param	name
		 * @return
		 */
		public static function check(name:String):String {
			if (!available) return"";
			return ExternalInterface.call(GET_COOKIE, name);
		}
		

        /**
         *  @return bool	true if SWFCookie is available.
         */
        public static function get available():Boolean {
            var result:Boolean = false;
            if (!ExternalInterface.available) return result;
            try {
                result = Boolean(ExternalInterface.call("function(){return true;}"));
            }
            catch (e:Error) {
                trace("No external interface for SWFCookie.");
            }
            return result;
        }
	}
}