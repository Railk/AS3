/**
* 
* Action handler for transformations tool
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.transform.item
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import railk.as3.data.list.DLinkedList;
	import railk.as3.data.list.DListNode;
	
	public class TransformItemAction 
	{
		private var active:DListNode;
		private var stage:Stage;
		private var objects:DLinkedList;
		private var functionsState:DLinkedList;
		private var walker:DListNode;
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  CONSTRUCTEUR
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function TransformItemAction(stage:Stage)
		{
			this.stage = stage;
			objects = new DLinkedList();
			functionsState = new DLinkedList();
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  ENABLE ITEMS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function enable( name:String, object:*, type:String='mouse', hover:Function=null,out:Function=null,up:Function=null,down:Function=null,move:Function=null,click:Function=null,doubleClick:Function=null):void
		{
			object.name = name;
			functionsState.add([name, object, null, null, { hover:(hover != null)?true:false, out:(out != null)?true:false, up:(up != null)?true:false, down:(down != null)?true:false, move:(move != null)?true:false, click:(click != null)?true:false, doubleClick:(doubleClick != null)?true:false } ])
			objects.add([name, object,null,null,{type:type, hover:hover, out:out, up:up, down:down, move:move, click:click, dClick:doubleClick}]);
			initListeners(object,type);
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					  MANAGE LISTENERS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function initListeners(object:*,type:String ):void
		{
			var states:Object = functionsState.getNodeByName( object.name).args;
			if (states.doubleClick) 
			{
				object.doubleClickEnabled = true;
				object.addEventListener( MouseEvent.DOUBLE_CLICK, manageEvent );
			}
			object.buttonMode = true;
			if(states.click) object.addEventListener( MouseEvent.CLICK, manageEvent, false, 0, true );
			if (type == 'mouse')
			{
				if(states.hover) object.addEventListener( MouseEvent.MOUSE_OVER, manageEvent, false, 0, true );
				if(states.out) object.addEventListener( MouseEvent.MOUSE_OUT, manageEvent, false, 0, true );
			}
			else if (type == 'roll' )
			{
				if(states.hover) object.addEventListener( MouseEvent.ROLL_OVER, manageEvent, false, 0, true );
				if(states.out) object.addEventListener( MouseEvent.ROLL_OUT, manageEvent, false, 0, true );
			}
			if(states.down) object.addEventListener( MouseEvent.MOUSE_DOWN, manageEvent, false, 0, true );
			if(states.up) object.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
		}
		
		private function delListeners(object:*,type:String):void
		{
			var states:Object = functionsState.getNodeByName( object.name).args;
			if (states.doubleClick) 
			{
				object.doubleClickEnabled = false;
				object.removeEventListener( MouseEvent.DOUBLE_CLICK, manageEvent );
			}
			object.buttonMode = false;
			if(states.click) object.removeEventListener( MouseEvent.CLICK, manageEvent );
			if (type == 'mouse')
			{
				if(states.hover) object.removeEventListener( MouseEvent.MOUSE_OVER, manageEvent);
				if(states.out) object.removeEventListener( MouseEvent.MOUSE_OUT, manageEvent );
			}
			else if (type == 'roll' )
			{
				if(states.hover) object.removeEventListener( MouseEvent.ROLL_OVER, manageEvent );
				if(states.out) object.removeEventListener( MouseEvent.ROLL_OUT, manageEvent);
			}
			if(states.down) object.removeEventListener( MouseEvent.MOUSE_DOWN, manageEvent );
			if(states.up) object.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  ENABLE EVENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function enableEvent():void
		{
			walker = objects.head;
			while ( walker )
			{
				if ( walker.args.active != true )
				{
					initListeners( walker.data, walker.args.type );
				}
				walker = walker.next;
			}
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 DISABLE EVENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function disableEvent():void
		{
			walker = objects.head;
			while ( walker )
			{
				if ( walker.data != active )
				{
					delListeners( walker.data, walker.args.type  );
				}
				walker = walker.next;
			}
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  	   DISPOSE
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function dispose():void
		{
			walker = objects.head;
			while ( walker )
			{
				delListeners(walker.data, walker.args.type );
				walker = walker.next;
			}
			objects.clear();
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 GETTER/SETTER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function get currentTarget():*
		{
			return active.data;
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						  MANAGE EVENT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function manageEvent( evt:* ):void
		{
			var target:* = evt.currentTarget;
			if( target != stage ) var f:Object = objects.getNodeByName(target.name).args;
			switch(evt.type)
			{
				case MouseEvent.CLICK :
					if (f.click != null) f.click.apply();
					break;
					
				case MouseEvent.DOUBLE_CLICK :
					if (f.dClick != null) f.dClick.apply();
					break;	
					
				case MouseEvent.MOUSE_DOWN :
					active = objects.getObjectByName( target.name );
					disableEvent();
					//////////////////////////////////////////////////////////////////////////
					if (f.down != null ) f.down.apply();
					active.data.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
					stage.addEventListener( MouseEvent.MOUSE_MOVE, manageEvent, false, 0, true );
					stage.addEventListener( MouseEvent.MOUSE_UP, manageEvent, false, 0, true );
					break;
				
				case MouseEvent.MOUSE_UP :
					if (active.args.up != null ) active.args.up.apply();
					active.data.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
					stage.removeEventListener( MouseEvent.MOUSE_MOVE, manageEvent );
					stage.removeEventListener( MouseEvent.MOUSE_UP, manageEvent );
					//////////////////////////////////////////////////////////////////////////
					enableEvent();
					break;
					
				case MouseEvent.MOUSE_MOVE :
					if (active.args.move != null ) active.args.move.apply();
					evt.updateAfterEvent();
					break;
					
				case MouseEvent.MOUSE_OVER :
					if (f.hover != null ) f.hover.apply();
					break;
					
				case MouseEvent.MOUSE_OUT :
					if (f.out != null ) f.out.apply();
					break;
					
				case MouseEvent.ROLL_OVER :
					if (f.hover != null ) f.hover.apply();
					break;
					
				case MouseEvent.ROLL_OUT :
					if (f.out != null ) f.out.apply();
					break;
					
				default : break;
			}
		}
	}
	
}