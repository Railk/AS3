/**
 * XML saver nodes
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.saver.xml.node
{
	public class XmlSaverNode
	{
		public var type:String;
		public var attribute:Object;
		public var content:*;
		
		public function XmlSaverNode( type:String, attribute:Object, content:*=null)
		{
			this.content = new Array();
			this.type = type;
			this.attribute = attribute;
			if(content) this.content = new String( content );
		}
		
		public function addContent( type:String, attribute:Object, content:*=null):XmlSaverNode
		{
			var node:XmlSaverNode = new XmlSaverNode( type, attribute, content );
			this.content.push( node );
			return node;
		}
	}	
}