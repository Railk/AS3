/**
* Single linked List Sort class
* 
* @author Richard Rodney
* @version 0.1
* 
* TODO:
* 	ALPHABETIC SORT
*/

package railk.as3.data.list
{	
	public class  SListSort
	{
		public static const NUMERIC                         :String = 'numeric';
		public static const ALPHA                           :String = 'alpha';
		public static const DESC                            :String = 'desc';
		public static const ASC                             :String = 'asc';
		
		private static var sortedList                       :SLinkedList;	
		private static var walker                           :SListNode;	
		
		/**
		 * SORT A LIST
		 * @param	list
		 * @param	sortType
		 * @param	sortMode
		 * @param	sortValue
		 * @return
		 */
		public static function sort( list:SLinkedList, sortType:String, sortMode:String, sortValue:String ):SLinkedList {
			if (sortType == NUMERIC) return numericSort( list, sortMode, sortValue );
			else if (sortType==ALPHA) return alphaSort( list, sortMode, sortValue );
			return null;
		}
		
		/**
		 * NUMERICAL SORT
		 * @param	list
		 * @param	mode
		 * @param	value
		 * @return
		 */
		private static function numericSort(list:SLinkedList, mode:String, value:String):SLinkedList {
			var currentValue = list.head.data[value];
			var currentNode:SListNode;
			var previousNode:SListNode = null;
			
			sortedList = new SLinkedList();
			walker = list.head;
			
			switch( mode )
			{
				case DESC :
					while ( walker ) {
						if ( sortedList.length == 0 ) {
							sortedList.add( [walker.name, walker.data, walker.group, walker.action] );
							currentNode = sortedList.head;
						}
						else if ( walker.data[value] <= currentValue ) {
							sortedList.insertAfter( currentNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = currentNode.next;
						}
						else {
							sortedList.insertAfter( previousNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = previousNode;
						}
						
						currentValue = walker.data[value];
						previousNode = walker;
						walker = walker.next;
					}
					break
					
				case ASC :
					while ( walker ) {
						if ( sortedList.length == 0 ) {
							sortedList.add( [walker.name, walker.data, walker.group, walker.action] );
							currentNode = sortedList.head;
						}
						else if ( walker.data[value] <= currentValue ) {
							sortedList.insertAfter( previousNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = previousNode;
						}
						else {
							sortedList.insertAfter( currentNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = currentNode.next;
						}
						
						currentValue = walker.data[value];
						previousNode = walker;
						walker = walker.next;
					}
					break;
				
				default : throw( new Error("this sort type doesn't exist");
			}
			return sortedList;
		}
		
		/**
		 * ALPHABETIC SORT
		 * @param	list
		 * @param	mode
		 * @param	value
		 * @return
		 */
		private static function alphaSort(list:SLinkedList, mode:String, value:String):SLinkedList {
			if (mode == DESC) return new SLinkedList();;
			else if (mode == ASC) return new SLinkedList();;
			return null;
		}
	}	
}