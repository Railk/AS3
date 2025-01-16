/**
* Doubly linked list Node
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.data.list
{
	public class DListNode
	{
		public var prev:DListNode;
		public var next:DListNode;
		public var id:int;
		public var name:String;
		public var data:*;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	id
		 * @param	name
		 * @param	data
		 */
		public function DListNode( id:int, name:String, data:* ) {
			this.id = id;
			this.name = name;
			this.data = data;
		}
		
		/**
		 * INSERT AFTER
		 * @param	node
		 */
		public function insertAfter( node:DListNode ):void {
			node.next = next;
			node.prev = this;
			if (next) next.prev = node;
			next = node;
		}
		
		/**
		 * INSERT BEFORE
		 * @param	node
		 */
		public function insertBefore( node:DListNode ):void {
			node.next = this;
			node.prev = prev;
			if (prev) prev.next = node;
			prev = node;
		}
		
		/**
		 * TO STRING
		 * @return
		 */
		public function toString():String { return '[ DListNode/'+id+' -> '+ name + ', ' + String( data )+' ]'; }
		
		/**
		 * DISPOSE
		 */
		public function dispose():void { data = null; }
	}
}