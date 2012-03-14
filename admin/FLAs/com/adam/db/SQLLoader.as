// com.app.SQLLoader
// Adam Riggs
//
package com.adam.db {
	//import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.events.*;
	
	//import gs.TweenMax;
	
	import com.adam.utils.AppData;
	import com.adam.events.MuleEvent;
	
	public class SQLLoader {
		
		private var appData:AppData=AppData.instance;
		
		private var _url:String;
		private var _vars:URLVariables;
		private var _type:String;
		private var _error:Boolean;
		private var _success:Boolean;
		private var _working:Boolean;
		private var _errorMsg:String;
		
		private var urlLoader:URLLoader;
		private var urlRequest:URLRequest;
		
		public function SQLLoader(u:String,v:URLVariables,t:String){
			_url=u;
			_vars=v;
			_type=t;
			init();
		}
		
//*****Initialization Routines
		
		public function init(){
			//this.visible = false;
			trace("SQLLoader() init");
			
			initURLLoader();
			initURLRequest();
			initState();
			beginLoad();
		}
		
		private function initURLLoader():void{
			urlLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		private function initURLRequest():void{
			urlRequest=new URLRequest(_url);
			urlRequest.method=URLRequestMethod.POST;
			urlRequest.data=_vars;
		}
		
		private function initState():void{
			_error=false;
			_success=false;
			_working=false;
			_errorMsg="";
		}
		
//*****Core Functionality
		
		public function beginLoad():void{
			//initiate the loading process
			urlLoader.load(urlRequest);
			_working=true;
		}
		
		
//*****Event Handlers
		
		private function onComplete(e:Event):void{
			//if the loading completes successfully
			_error=false;
			_success=true;
			_working=false;
			//trace("SQLLoader - query complete:response==\n"+e.currentTarget.data);
			appData.eventManager.dispatch("sql", {type:_type, result:e.currentTarget.data});
		}
		
		private function onError(e:IOErrorEvent):void{
			//if there's an error when loading
			_errorMsg=e.text;
			
			_error=true;
			_success=false;
			_working=false;
		}
		
//*****Gets and Sets
		
		public function get url():String{return _url;}
		public function set url(value:String):void{_url=value;}
		
		public function get vars():URLVariables{return _vars;}
		public function set vars(value:URLVariables):void{_vars=value;}
		
		public function get type():String{return _type;}
		public function set type(value:String):void{_type=value;}
		
		public function get error():Boolean{return _error};
		public function get working():Boolean{return _working};
		public function get success():Boolean{return _success};
		public function get errorMsg():String{return _errorMsg};
		
		
	}
}