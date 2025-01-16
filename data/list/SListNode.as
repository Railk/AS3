/**
* Single linked list Node
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.list
{
	public class SListNode
	{
		public var id                            :int;
		public var name                          :String;
		public var data                          :*;
		public var next                          :SListNode;
		
		/**
		 * CONSTRUCTEUR
		 * @param	id
		 * @param	name
		 * @param	data
		 */
		public function SListNode( id:int, name:String, data:* ) {
			id = id;
			name = name;
			data = data;
		}
		
		/**
		 * INSERT AFTER
		 * @param	node
		 */
		public function insertAfter( node:SListNode ):void {
			node.next = next;
			next = node;
		}
		
		/**
		 * TOSTRING
		 * @return
		 */
		public function toString():String { return '[ SListNode/'+id+' -> '+ name + ', ' + String( data )+' ]'; }
		
		/**
		 * DISPOSE
		 */
		public function dispose():void { data = null; }
	}
}