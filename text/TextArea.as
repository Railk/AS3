/**
 * TextArea
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 */

package railk.as3.text
{	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import railk.as3.display.UITextField;
	import railk.as3.ui.loader.*;
	
	public class TextArea extends UITextField
	{
		private var _letters:Array=[];
		private var _words:Array=[];
		private var _lines:Dictionary = new Dictionary();
		
		private var firstTag:Tag;
		private var lastTag:Tag;
		
		private var lineHeight:Number;
		private var letterSpacing:Number;
		private var justify:String;
		
		/**
		 * CONSTRUCTEUR
		 * 
		 * @param	text
		 * @param	height
		 * @param	width
		 * @param	lineHeight
		 * @param	letterSpacing
		 * @param	justify
		 */
		public function TextArea(text:String, width:Number, height:Number, lineHeight:Number = NaN, letterSpacing:Number = NaN, justify:String = 'left') {
			this.lineHeight = lineHeight;
			this.letterSpacing = letterSpacing;
			this.justify = justify;
			this.wordWrap = true;
			this.width = width;
			this.height = height;
			this.htmlText = analyse(text);
			
			(this.getImageReference('image') as Loader).alpha = .1;
			
			var walker:Tag = firstTag;
			while (walker) {
				this.setTextFormat(walker.textFormat, walker.begin, walker.end);
				walker = walker.next;
			}
		}
		
		/**
		 * ANALYSE
		 * 
		 * @param	text
		 */
		private function analyse(text:String):String {
			var style:RegExp = /style="[a-zA-Z0-9,:\-# ]{1,}"/;
			var font:RegExp = /font:[a-zA-Z0-9_-]{0,}/;
			var size:RegExp = /size:[0-9]{0,}/;
			var color:RegExp = /color:[a-zA-Z0-9#]{0,}/;
			var align:RegExp = /align:[a-zA-Z]{0,}/;
			var link:RegExp = /href="[a-zA-Z0-9-_.#:\/]{0,}"/;
			var target:RegExp = /target="[a-zA-Z_]{0,}"/;
			var img:RegExp = /src="[a-zA-Z0-9-_.#:\/]{0,}"/;
			var underlined:RegExp = /underlined:[true|false]/;
			var htmlTag:RegExp = /(<([\/@!?#]?[^\W_]+)(?:\s|(?:\s(?:[^'">\s]|'[^']*'|"[^"]*")*))*\/?>)|(<\!--[^-]*-->)/g;
			var openTag:RegExp = /<[a-zA-Z0-9]{1,}/;
			var closeTag:RegExp = /<\/[a-zA-Z0-9 ]{1,}>/;
			var singleTag:RegExp = /<[a-zA-Z0-9=",.: ]{1,}\/>/;
			var trimmed:String = text;
			
			var tags:Array = trimmed.match(htmlTag), openTags:Array=[], currentTag:String, index:int=0;
			for (var i:int = 0; i < tags.length; i++) {
				var tag:String = tags[i], format:TextFormat, attributes:Array;
				//format ?
				if (tag.search(style) != -1) {
					var s:String = tag.match(style)[0];
					format = getFormat(getStyle(s, font), getStyle(s, size), getStyle(s, color), getStyle(s, underlined), getStyle(s, align));
					tag.replace(style, '');
				}
				else format = (lastTag)?lastTag.textFormat:getFormat();
				
				//img
				if ( tag.search(img) != -1) {
					
				}
				
				//video
				
				
				//link
				if ( tag.search(link) != -1) {
					format.url = tag.match(link)[0].split('"')[1];
					format.target = (tag.match(target))?tag.match(target)[0]:'_blanc';
				}
				
				//create tag and trimm text
				if (tag.search(singleTag) != -1) {
					if (tag.search('br') != -1) {
						text = text.replace(tag, '\n');
						trimmed = trimmed.replace(tag, '\n');
					}
					else addTag( new Tag(tagName(tag.match(singleTag)[0]), trimmed.indexOf(tag, index), format));
					lastTag.end = lastTag.begin;
				}
				else if (tag.search(openTag) != -1) {
					openTags.unshift( tagName(tag.match(openTag)[0]) );
					addTag( new Tag(tagName(tag.match(openTag)[0]), trimmed.indexOf(tag, index), format));
				}
				else if (tag.search(closeTag) != -1) getTag(openTags.shift()).end = trimmed.indexOf(tag, index);
				trimmed = trimmed.replace(tag, '');
			}
			return text;
		}
		
		/**
		 * MANAGE TAG
		 */
		private function getTag(name:String):Tag {
			var walker:Tag = firstTag;
			while (walker) {
				if (walker.name == name) return walker;
				walker = walker.next;
			}
			return null;
		}
		 
		private function addTag(tag:Tag):void {
			if (!firstTag) firstTag = lastTag = tag;
			else {
				lastTag.next = tag;
				tag.prev = lastTag;
				lastTag = tag;
			}
		}
		
		private function tagName(tag:String):String { return tag.replace(/[<|\/>]{0,}/g, ''); }
		
		/**
		 * GET A NEW TEXTFORMAT FOR THE SPECIFY PART OF THE TEXT
		 * 
		 * @param	font
		 * @param	size
		 * @param	color
		 * @param	underlined
		 * @param	lineHeight
		 * @param	letterSpacing
		 * @param	justify
		 */
		private function getFormat(font:String='', size:String='', color:String='', underlined:String='',justify:String='' ):TextFormat {
			var textFormat:TextFormat = new TextFormat(	(font)?font:((lastTag)?lastTag.textFormat.font:'arial'), 
														(size)?Number(size):((lastTag)?lastTag.textFormat.size:12), 
														(color)?stringToColor(color):((lastTag)?lastTag.textFormat.color:0x000000),
														null, null,
														(underlined)?stringToBoolean(underlined):((lastTag)?lastTag.textFormat.underline:false),
														null,
														null,
														(justify)?justify:this.justify,
														null, null, null, 
														lineHeight);
			textFormat.letterSpacing = letterSpacing;
			return textFormat;
		}
		
		/**
		 * UTILITIES
		 */
		public function getLine(line:int):Line {
			var diff:int = line-(this.numLines - 1);
			if (diff > 0) for (var i:int = 0; i < diff; i++) this.appendText('\r');
			if (_lines[line] != undefined) return _lines[line];
			_lines[line] = new Line(this, line, new TextFormat('arial',12,0x000000));
			return _lines[line];
		}
		 
		private function stringToBoolean(bool:String):Boolean {
			var lookup:Object = { '1':1, 'yes':1, 'true':1, '0':0, 'no':0, 'false':0 };
			return lookup[bool];
		}
		
		private function stringToColor(color:String):uint {
			if ( color.charAt(0) == '#' ) color = color.replace(/#/, '0x');
			else if (color.substr(0, 2) != '0x') color = '0x' + color;
			return uint(color);
		}
		
		private function getStyle(s:String, r:RegExp):String { return (s.match(r))?s.match(r)[0].split(':')[1]:''; }
		
		/**
		 * GETTER/SETTER
		 */
		public function get words():Array { return _words; }
		public function get letters():Array { return _letters; }
		public function get lines():Array { 
			var a:Array = [];
			for each (var value:Object in _lines) a[a.length]=value;
			return a; 
		}
	}
}

import flash.text.TextFormat;
internal class Tag
{
	public var next:Tag;
	public var prev:Tag;

	public var name:String;
	public var begin:int;
	public var end:int;
	public var textFormat:TextFormat;
	public var attributes:Array;
	
	public function Tag(name:String, begin:int, textFormat:TextFormat, attributes:Array=null) {
		this.name = name;
		this.begin = begin;
		this.textFormat = textFormat;
		this.attributes = attributes;
	}
	
	public function toString():String { return '[TAG > name:' + name + ', begin:'+begin+', end:'+end+']'; }
}

import flash.text.TextField;
import flash.text.TextFormat;
internal class Line {
	private var textField:TextField;
	private var line:int;
	private var format:TextFormat;
	
	public function Line(textField:TextField,line:int,format:TextFormat) {
		this.textField = textField;
		this.line = line-1;
		this.format = format;
	}
	
	public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
      	textField.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
		textField.removeEventListener(type, listener, useCapture);
	}
	
	public function get text():String { return textField.getLineText(line); }
	public function set text(txt:String):void { 
		textField.replaceText( textField.getLineOffset(line),  textField.getLineOffset(line) + textField.getLineLength(line)-1, txt );
		textField.setTextFormat(format,textField.getLineOffset(line),textField.getLineOffset(line) + textField.getLineLength(line)-1);
	}
}