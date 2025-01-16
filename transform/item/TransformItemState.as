package railk.as3.transform.item {
	
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	
    public class TransformItemState {
		
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public var rotation:Number;
		public var color:uint;
		public var text:String;
		public var format:TextFormat;
		public var _group:String;
		
		public function TransformItemState(item:*, group = '')
		{
			this.x = item.x;
			this.y = item.y;
			this.scaleX = item.scaleX;
			this.scaleY = item.scaleY;
			this.rotation = item.rotation;
			this._group = group;
			
			if ( getType(item) == 'text' )
			{
				this.color = item.getTextFormat().color;
				this.text = item.text;
				this.format = item.getTextFormat();
				this.width = item.textWidth;
				this.height = item.textHeight;
			}
			else 
			{
				this.color = item.transform.colorTransform.color;
				this.width = item.width;
				this.height = item.height;
			}
		}
		
		public function apply(item:*):void
		{
			item.x = this.x;
			item.y = this.y;
			item.scaleX = this.scaleX ;
			item.scaleY = this.scaleY;
			item.rotation = this.rotation;
			item.width = this.width;
			item.height = this.height;
			
			if ( getType(item) == 'text' )
			{
				item.text = this.text;
				item.setTextFormat(this.format);
				
			}

		}
		
		public function getType(item:*):String
		{
			if ( item is TextField ) return 'text';
			return 'other';
		}
		
		public function get group():String { return this._group; }
	}
}