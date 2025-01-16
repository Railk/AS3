/**
 * XML saver nodes
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.saver.xml.node
{
	public class XmlSaverNodes
	{
		private var _rootNodes:Array;
		
		public function XmlSaverNodes() 
		{
			_rootNodes  = new Array();
		}
		
		public function add( name:String, root:String, type:String, attribute:Object = null, content:*= null):XmlSaverRootNode 
		{
			var node:XmlSaverRootNode = new XmlSaverRootNode( root, type, attribute, content );
			_rootNodes.push( node );
			return node;
		}
		
		public function get data():Array 
		{
			return _rootNodes;
		}
		
		public function empty():void 
		{
			_rootNodes = new Array();
		}
	}	
}