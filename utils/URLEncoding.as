/**
 * URLencoding
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils
{	
	public class URLEncoding
	{
		/**
		 * ESCAPE
		 */
		public static function escape(str:String):String {
			var result:String='', exclude:RegExp = /(^[a-zA-Z0-9~._-]*)/;			
			var match:Object, charCode:Number, hexVal:String, i:int = 0;
			
			while (i < str.length) {
				match = exclude.exec(str.substr(i));
				if (match != null && match.length > 1 && match[1] != '') {
					result += match[1];
					i += match[1].length;
				} else {
					if (str.substr(i,1)=='') result += "+";
					else {
						charCode = str.charCodeAt(i);
						hexVal = charCode.toString(16);
						result += "%" + ((hexVal.length < 2)?'0':'') + hexVal.toUpperCase();
					}
					i++;
				}
			}
			return result;
		}
		
		/**
		 * UNESCAPE
		 */
		public static function unescape(str:String):String {
			var regexp:RegExp = /(%[^%]{2})/, plusPattern:RegExp = /\+/gm;
			var binVal:Number, thisString:String, match:Object;
			str = str.replace(plusPattern,' ');
			
			while ((match = regexp.exec(str)) != null && match.length > 1 && match[1] != '') {
				binVal = parseInt(match[1].substr(1),16);
				thisString = String.fromCharCode(binVal);
				str = str.replace(match[1], thisString);
			}
			return str;
		}

	}
}