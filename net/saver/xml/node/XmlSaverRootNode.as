/**
 * XML saver nodes
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.saver.xml.node
{
	public class XmlSaverRootNode
	{
		public var root:String;
		public var type:String;
		public var attribute:Object;
		public var content:*;
		
		public  function XmlSaverRootNode( root:String, type:String, attribute:Object, content:*= null):void 
		{
			this.content = new Array();
			this.root = root;
			this.type = type;
			this.attribute = attribute;
			if(content) this.content = new String(content);
		}
		
		public function addContent( type:String, attribute:Object, content:*=null ):XmlSaverNode
		{
			var node:XmlSaverNode = new XmlSaverNode( type, attribute, content );
			this.content.push( node );
			return node;
		}
		
		public function toString():String 
		{
			return '[ XmlSaverRootNode > '+this.root+' ]'
		}
	}	
}