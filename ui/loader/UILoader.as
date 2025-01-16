/**
 * UIloader
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.loader
{	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.getDefinitionByName;
	import railk.as3.utils.Logger;

	public class UILoader
	{
		public static const CONTENT:String = 'content';
		public static const CONTENT_ARRAY:String = 'contentArray';
		public static const FILE:String = 'current';
		public static const FILE_URL:String = 'currentUrl';
		public static const PERCENT:String = 'percent';
		public static const PERCENTS:String = 'percents';
		
		public var percent:Number;
		public var content:Dictionary = new Dictionary(true);
		public var contentArray:Array = [];
		public var active:Boolean;
		
		private var loading:int = 0;
		private var urls:Array = [];
		private var loaders:Dictionary = new Dictionary(true);
		private var listeners:Dictionary = new Dictionary(true);
		private var types:Dictionary = new Dictionary(true);
		private var percents:Dictionary = new Dictionary(true);
		private var _dispose:Boolean = true;
		private var _progress:Function;
		private var _complete:Function;
		private var _file:Function;
		private var pArgs:Array=[];
		private var cArgs:Array = [];
		private var fArgs:Array = [];
		private var paused:Boolean;
		private var count:int;
		private var current:Object;
		private var currentUrl:String;
		
		
		/**
		 * CONSTRUCTEUR
		 * @param	url
		 * @param	noCache
		 */
		public function UILoader(url:*=null, noCache:Boolean=false) { if(url) (url is String)?add(url,noCache):addList(url,noCache); }
		
		/**
		 * ADD FILE TO LOAD
		 */
		public function add(url:String, noCache:Boolean = false):UILoader {
			urls[urls.length] = new URLRequest(init( url )+(noCache?'?nocache='+int(Math.random()*1000)*getTimer()+''+getTimer():''));
			return this;
		}
		
		public function addList(list:Array, noCache:Boolean = false):UILoader {
			for (var i:int = 0; i < list.length; i++) add(list[i], noCache);
			return this;
		}
		
		private function init(url:String):String {
			var types:Object = { 'flash.display.Loader,contentLoaderInfo,content':'jpg,gif,png,swf', 'flash.net.URLLoader,,data':'xml,zip,json,css,txt' }, type:Array;
			for ( var t:String in types) if (types[t].search(url.split('.')[url.split('.').length - 1]) != -1) { this.types[url] = type = t.split(','); break; }
			loaders[url] = new (getDefinitionByName(type[0]))();
			listeners[url] = (type[1])?loaders[url][type[1]]:loaders[url];
			percents[url] = 0;
			count++;
			return url;
		}
		
		/**
		 * DISPOSE
		 * 
		 * @param	value
		 * @return
		 */
		public function dispose(value:Boolean):UILoader { _dispose = value; return this; }
		
		/**
		 * PROGRESS
		 * 
		 * @param	action
		 * @param	...args  CAN BE UILOADER.PERCENT OR/AND UILOADER.PERCENTS
		 * @return
		 */
		public function progress(action:Function, ...args):UILoader {
			_progress = action;
			pArgs = (args.length>0)?args:pArgs;
			addEvent(ProgressEvent.PROGRESS);
			return this;
		}
		
		/**
		 * FILE COMPLETE
		 * 
		 * @param	action
		 * @param	...args  CAN BE UILOADER.FILE
		 * @return
		 */
		public function file(action:Function, ...args):UILoader {
			_file = action;
			fArgs = (args.length > 0)?args:fArgs;
			addEvent(Event.COMPLETE);
			return this;
		}
		
		/**
		 * COMPLETE
		 * 
		 * @param	action
		 * @param	...args CAN BE UILOADER.CONTENT OR/AND UILOADER.CONTENT_ARRAY
		 * @return
		 */
		public function complete(action:Function, ...args):UILoader {
			_complete = action;
			cArgs = (args.length>0)?args:cArgs;
			addEvent(Event.COMPLETE);
			return this;
		}
		
		private function addEvent(e:String):void {
			for (var url:String in listeners) if(!listeners[url].hasEventListener(e)) listeners[url].addEventListener(e, manageEvent );
		}
		
		private function manageEvent(e:*):void {
			var listener:*= e.currentTarget, url:String, i:int;
			switch(e.type) {
				case Event.COMPLETE :
					content[getUrl(listener)] = contentArray[contentArray.length] = current = (listener is URLLoader)?listener.data:listener.content;
					currentUrl = getUrl(listener);
					loading--;
					if (_file != null) _file.apply(null, checkArgs(fArgs, FILE));
					if (!next() && !loading) {
						for (url in loaders) if (types[url][1]) loaders[url].unload();
						if (_complete != null) _complete.apply(null, checkArgs(cArgs, CONTENT));
						clean();
						if (_dispose) destroy();
						count = 0;
					}
					break;
				case ProgressEvent.PROGRESS :
					percent=0;
					percents[getUrl(listener)] = int(e.bytesLoaded / e.bytesTotal * 100);
					for (url in percents) percent += percents[url]/count;
					_progress.apply(null, checkArgs(pArgs,PERCENT));
					break;
				default : break;
			}
		}
		
		/**
		 * START/STOP/PAUSE/NEXT
		 */
		public function start(max:int=7):UILoader { while( --max > -1 ) { if(!next()) break; } return this; }
		public function stop():UILoader { if (loaders) { for (var url:String in loaders) { loaders[url].close(); } destroy(); } return this; }
		public function pause():UILoader { paused = true; return this; }
		
		private function next():Boolean {
			if (!urls.length) return active = false;
			var req:URLRequest = urls.pop(), url:String = req.url.split('?')[0];
			if(types[url][1]) loaders[url].load(req,new LoaderContext(true, ApplicationDomain.currentDomain));
			else loaders[url].load(req);
			loading++;
			return active = true;
		}
		
		/**
		 * CLEAN
		 */
		private function clean():void {
			for (var url:String in listeners) {
				listeners[url].removeEventListener(Event.COMPLETE, manageEvent );
				if (_progress != null) listeners[url].removeEventListener(ProgressEvent.PROGRESS, manageEvent );
				delete listeners[url];
				delete loaders[url];
				delete percents[url];
			}
		}
		
		/**
		 * DISPOSE
		 */
		private function destroy():void {
			current = null;
			content = loaders = listeners = types = percents = null;
			contentArray = urls = null;
			_complete = _progress = _file = null;
		}
		
		/**
		 * UTILITIES
		 */
		private function getUrl(listener:*):String { for (var url:String in listeners){ if (listeners[url] == listener) return url; } return ''; }
		private function checkArgs(args:Array, type:String):Array {
			var a:Array = args.slice();
			for (var i:int = 0; i < a.length; i++) {
				var arg:String = a[i];
				if (arg is String) {
					if(arg.indexOf(type) != -1) a[i] = this[arg];
				}
			}
			return a; 
		}
	}
}