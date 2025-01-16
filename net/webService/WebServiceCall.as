/**
 * Web Service Call
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.webService 
{
	public class WebServiceCall
	{	
		public static function data(data:XML):XML {
			return new XML(
			<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://schemas.xmlsoap.org/soap/envelope/">
				<soap12:Body>{data}</soap12:Body>
			</soap12:Envelope>
			);
		}
	}
}
