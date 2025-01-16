/**
 * Layout
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.utils.Dictionary;
	import railk.as3.ui.div.DivState;
	
	public class Layout implements ILayout
	{
		public var name:String;
		public var pack:String;
		private var _viewsDict:Dictionary=new Dictionary(true);
		private var _views:Array=[];
		
		/**
		 * CONSTRUCTEUR
		 */
		public function Layout( pack:String, name:String, body:XML ) {
			this.pack = pack;
			this.name = name;
			construct(body);
		}
			
		private function construct(xml:XML, container:LayoutView=null, master:LayoutView=null):void {
			for (var i:int = 0; i < xml.children().length(); i++) {
				var d:XML = xml.children()[i];
				if (d.name() != 'div') continue;
				master = _views[_views.length] = _viewsDict[d.@id.toString()] = new LayoutView(container, master, A('id', d), d.@id, A('float', d), A('align', d), A('margins', d), A('position', d), A('x', d), A('y', d), A('style', d), A('background', d), D(d), A('constraint', d), A('visible',d) );
				if ( d.children().length() > 0 ) construct( d, master );
			}
		}		
		
		/**
		 * MANAGE VIEWS
		 */
		public function getView(name:String):ILayoutView { return (_viewsDict[name])?_viewsDict[name]:null; }
		public function removeView(name:String):void {
			for (var i:int = 0; i < _views.length; i++) if (_views[i].id == name) _views.splice(i,1); 
			delete _viewsDict[name]; 
		}
		
		/**
		 * UTILITIES
		 */
		private var attributes:Object =  { float:'none', align:'none', margins:null, position:'relative', x:0, y:0, constraint:'none', visible:false, style:'', background:'' };
		private function A( name:String, xml:XML ):* {
			var i:int;
			for (i=0; i < xml.@*.length(); ++i){
				if (name == xml.@*[i].name()) {
					if (name == 'margins') {
						var a:Array = (xml.@ * [i].toString()).split(','), value:Number = Number(a[0]);
						return (a.length==1)?new DivState(0,0,null,null,value,value,value,value):new DivState(0,0,null,null,(a[0]?Number(a[0]):0),(a[0]?Number(a[1]):0),(a[0]?Number(a[2]):0),(a[0]?Number(a[3]):0));
					}
					if(name == 'id') return pack+'.'+C(xml.@*[i]);
					if (name == 'visible') return (xml.@*[i] == 'true'?true:false);
					return xml.@*[i];
				}
			}	
			return attributes[name];
		}
		private function C( value:String ):String { return value.charAt().toUpperCase()+value.substring(1);  }
		private function D(xml:XML):XML {
			var result:XML = new XML('<data></data>')
			for (var i:int; i < xml.children().length(); i++ ) if (xml.children()[i].name() != 'div') result.appendChild(xml.children()[i]);
			return (result.children().length() == 0)?null:result;
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function get viewsDict():Dictionary { return _viewsDict; }
		public function get views():Array { return _views; }
	}
}