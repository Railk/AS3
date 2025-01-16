/**
 * Use to protect your application with a limit date for usage.
 * 
 * 	@usage :var bAutorize:Boolean = Protect.isAllow(2008, 9, 21);
 * 
 * 
 * @class Protect
 * @author Matthieu
 * @version 0.1
*/

package railk.as3.utils 
{
	public class Protect 
	{
		/**
		 * CONSTRUCTOR
		 * @usage   
		 * @return  
		 */
		public function Protect() {}
 
		/**
		 * Stop execution of the application flash if date isn't correct.
		 * 
		 * @see     
		 * @param   
		 * @return  
		 */
		public static function isAllow(nYear:int, nMonth:int, nDay : int) : Boolean 
		{	
			var oDate:Date = new Date();
 
			if(nYear < oDate.getFullYear())	return false;
			if(nMonth < (oDate.getMonth()+1) ) return false;// 0 pour janvier, 1 pour fevrier
			if(nDay < oDate.getDate() && nMonth==oDate.getMonth()+1) return false;		
			return true;
		}	
	}
}