/**
* Doubly linked List Sort class
* 
* @author Richard Rodney
* @version 0.1
* 
* TODO:
* 	ALPHABETIC SORT
*/


package railk.as3.data.list
{	
	public class  DListSort
	{
		public static const NUMERIC                         :String = 'numeric';
		public static const ALPHA                           :String = 'alpha';
		public static const DESC                            :String = 'desc';
		public static const ASC                             :String = 'asc';
		
		private static var sortedList                       :DLinkedList;	
		private static var walker                           :DListNode;	
		
		/**
		 * SORT A LIST 
		 * @param	list
		 * @param	sortType
		 * @param	sortMode
		 * @param	sortValue
		 * @return
		 */
		public static function sort( list:DLinkedList, sortType:String, sortMode:String, sortValue:String ):DLinkedList {
			if (sortType==NUMERIC) return numericSort( list, sortMode, sortValue );
			else if (sortType==ALPHA) return alphaSort( list, sortMode, sortValue );
			return null;
		}
		
		/**
		 * SORT NUERICAL
		 * @param	list
		 * @param	mode
		 * @param	value
		 * @return
		 */
		private static function numericSort(list:DLinkedList, mode:String, value:String):DLinkedList {
			var currentValue = list.head.data[value];
			var currentNode:DListNode;
			sortedList = new DLinkedList();
			walker = list.head;
			
			switch( mode ) {
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
							sortedList.insertBefore( currentNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = currentNode.prev;
						}
						
						currentValue = walker.data[value];
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
							sortedList.insertBefore( currentNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = currentNode.prev;
						}
						else {
							sortedList.insertAfter( currentNode, walker.name, walker.data, walker.group, walker.action );
							currentNode = currentNode.next;
						}
						
						currentValue = walker.data[value];
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
		private static function alphaSort(list:DLinkedList, mode:String, value:String):DLinkedList {
			if (mode==DESC) return new DLinkedList();
			else if (mode == ASC) return new DLinkedList();
			return null
		}
	}	
}