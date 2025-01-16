/**
 * Loader Item
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.net.loader.items
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	public class LoaderItem extends SimpleItem
	{
		private var loader:Loader;
		public function LoaderItem( url:URLRequest, name:String, args:Object, priority:int, preventCache:Boolean, bufferSize:int, mode:String ):void {			
			super(url,name,args,priority,preventCache,bufferSize,mode);
		}
		
		override public function start():void {
			var context:LoaderContext;
			loader = new Loader();
			if ( mode == 'sameDomain' ) context = new LoaderContext(true, ApplicationDomain.currentDomain);
			else if ( mode == 'externalDomain' ) context = new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain);
			initListeners(loader.contentLoaderInfo);
			loader.load( url, context );
		}
		
		override public function stop():void { 
			try { loader.close(); }
			catch (e:Error) { /*throw e;*/ }
			end();
		}
		
		override protected function end():void {
			delListeners( loader );
			loader.unload();
		}
		
		override public function dispose():void {
			super.dispose();
			loader = null;
		}
		
		override protected function complete(evt:Event):void {
			content = loader.content;
			end();
			super.complete(evt);
		}
	}
}