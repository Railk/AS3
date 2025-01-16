/**
 * PLUGIN => SWF CONTENANT UNE OU PLUSIEUR CLASSE
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 * context example :
 * 
 * 	//begin
 * 		plugin1.swf=truc.truc.Truc,truc.truc.Truc2,...,truc.truc.TrucN;
 * 		plugin1.swf=truc.truc.Truc,truc.truc.Truc2,...,truc.truc.TrucN;
 * 		plugin1.swf=truc.truc.Truc,truc.truc.Truc2,...,truc.truc.TrucN;
 * 	
 *  //end
 * 
 */

package railk.as3.ui.page
{
	import flash.utils.getDefinitionByName;
	import flash.utils.Dictionary;
	import railk.as3.pattern.singleton.Singleton;
	
	public final class Plugins
	{
		private var hashMap:Dictionary = new Dictionary(true);
		private var plugins:Dictionary = new Dictionary(true);
		private var groups:Dictionary = new Dictionary(true);
		
		public static function getInstance():Plugins{
			return Singleton.getInstance(Plugins);
		}
		
		/**
		 * YOU CANNOT INSTANTIATE DIRECTLY PLEASE USE getInstance() INSTEAD
		 */
		public function Plugins() { Singleton.assertSingle(Plugins); }
		
		/**
		 * SET THE PLUGINS CONTEXT
		 */
		public function init(context:String,loadingView:IPageLoading):void {
			if (!context || context == '') return;
			var duples:Array = context.replace(/\r|\t|\n/g, '').split(';'), length:int=duples.length-1, duple:Array, classes:Array;
			for (var i:int = 0; i < length; ++i) {
				duple = duples[i].split('=');
				classes = duple[1].split(',');
				var p:Plugin = plugins[duple[0]] = new Plugin(duple[0], monitor, loadingView);
				for (var j:int = 0; j < classes.length; j++) hashMap[classes[j]] = duple[0];
			}
		}
		
		public function initMonitor(group:String,data:Array,f:Function):void {
			groups[group] = new Group(data,f);
		}
		
		/**
		 * GET THE CLASS
		 * 
		 * @param	name
		 */
		public function getClass(group:String, name:String, complete:Function, ...params):void {
			if (hashMap[name] == undefined) {
				complete.apply(null, params);
				monitor(group,name);
			} else {
				var p:Plugin = plugins[hashMap[name]];
				if (p.state == Plugin.NO) { p.load(complete,params,name,group); }
				else if (p.state == Plugin.PROGRESS){ p.addAction(complete,params,name,group); }
				else if (p.state == Plugin.COMPLETE) {
					params[params.length] = getDefinitionByName(name) as Class; 
					complete.apply(null, params);
					monitor(group,name);
				}
			}
		}
		
		private function monitor(group:String, name:String):void {
			var g:Group = groups[group];
			var i:int=g.monitorData.length;
			while ( --i > -1 ) {
				if (g.monitorData[i].viewName == name) {
					g.monitorData.splice(i, 1);
					break;
				}
			}
			if (g.monitorData.length == 0) { g.monitorComplete.apply(); g.dispose(); delete groups[group]; }
		}
	}
}

internal class Group
{
	public var monitorData:Array;
	public var monitorComplete:Function;
	
	public function Group( monitorData:Array, monitorComplete:Function) {
		this.monitorData = monitorData;
		this.monitorComplete = monitorComplete;
	}
	
	public function dispose():void {
		monitorComplete = null;
		monitorData = null;
	}
}

import flash.utils.getDefinitionByName;
import railk.as3.ui.loader.*;
import railk.as3.TopLevel;
import railk.as3.ui.page.IPageLoading;
internal class Plugin
{
	public static const NO:String = 'UIPlugin_NO';
	public static const PROGRESS:String = 'UIPlugin_PROGRESS';
	public static const COMPLETE:String = 'UIPlugin_COMPLETE';
	
	public var file:String;
	public var monitor:Function;
	public var state:String = NO;
	public var actions:Array = [];
	public var loadingView:IPageLoading;
	
	public function Plugin(file:String,monitor:Function,loadingView:IPageLoading) {
		this.file = ((TopLevel.local)?"../":"")+"plugins/"+file;
		this.monitor = monitor;
		this.loadingView = loadingView;
	}
	
	public function load(f:Function,p:Array,n:String,g:String):void {
		state = PROGRESS;
		addAction(f,p,n,g);
		loadUI(file,true).progress(onProgress,UILoader.PERCENT).complete(onComplete).start();
	}
	
	private function onProgress(percent:Number):void {
		if(loadingView) loadingView.percent = percent;
	}
	
	private function onComplete():void {
		state = COMPLETE;
		var length:int=actions.length, action:Object, params:Array;
		for (var i:int = 0; i < length; i++) {
			action = actions[i];
			action.p[action.p.length] = getDefinitionByName(action.n) as Class;
			action.f.apply(null, action.p);
			monitor.apply(null, [action.g,action.n]);
		}
	}
	
	public function addAction(f:Function, p:Array, n:String, g:String):void { 
		actions[actions.length] = { f:f, p:p, n:n, g:g }; 
	}
}