/**
 * open Calais Tag semantic search
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.external.openCalais
{
	import railk.as3.net.webService.*;
	
	public class OpenCalais extends WebService
	{
		private const URL:String="http://api.opencalais.com/enlighten/";
		private var apiKey:String;
		
		public function OpenCalais(apiKey:String) {
			this.apiKey = apiKey;
			super(URL);
		}
		
		public function getTags(from:String):void {
			data = new XML(
			<Enlighten xmlns="http://clearforest.com/">
				<licenseID>{apiKey}</licenseID>
				<content>{from}</content>
				<paramsXML>
					<c:params xmlns:c="http://s.opencalais.com/1/pred/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
						<c:processingDirectives c:contentType="TEXT/TXT" c:outputFormat="XML/RDF"></c:processingDirectives>
						<c:userDirectives c:allowDistribution="false" c:allowSearch="false" c:externalID="" c:submitter=""></c:userDirectives>
						<c:externalMetadata></c:externalMetadata>
					</c:params>
				</paramsXML>
			</Enlighten>	
			);
			
			call();
		}
	}
}