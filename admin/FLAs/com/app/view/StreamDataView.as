﻿// com.app.view.StreamDataView// Adam Riggs//package com.app.view {	import com.adam.events.MuleEvent;	import com.adam.utils.AppData;		import fl.controls.DataGrid;		import flash.display.Sprite;	import flash.events.*;		public class StreamDataView extends DataGridView {				/*//vars		private var col1,col2,col3:String;				//objects		private var appData:AppData=AppData.instance;		private var dg:DataGrid;				//const		public const NAME:String="baselineDataView";		public const RETURNTYPE:String=NAME;*/				public function StreamDataView(){						//super();			init();		}		//*****Initialization Routines				public function init():void{			debug("init()");			NAME="streamDataView";			RETURNTYPE=NAME;			titleTxt.text="Stream Data";		}				/*private function initVars():void{			col1="col1";			col2="col2";			col3="col3";		}				private function initEvents():void{			appData.eventManager.listen(NAME, onStreamDataView);			appData.eventManager.listen("sql", onSQL);		}				private function initObjs():void{			dg=new DataGrid();			dg.y=appData.panelDgY;			addChild(dg);						dg.columns=new Array(col1, col2, col3);			dg.height=550;			dg.width=400;		}*/		//*****Core Functionality				/*public function update(arr:Array):void{			debug("update()");			debug("arr.length=="+arr.length);						var condition:String="";			var component:String="";						dg.removeAll();			for(var i:uint=0;i<arr.length;i++){				appData.listObject(arr[i]);				debug("*****");								if(condition!=arr[i].phase || component!=arr[i].component){					condition=arr[i].phase;					component=arr[i].component;					dg.addItem({});					dg.addItem({col1:"Condition", col2:condition});					dg.addItem({col1:"Component", col2:component});					dg.addItem({});				}				dg.addItem({col1:(i+1).toString(),col2:arr[i].clicks,col3:arr[i].consumption});			}		}*/				//*****Event Handlers				/*private function onSQL(e:MuleEvent):void{			debug("onSQL()");			debug("e.data.sender=="+e.data.sender);			debug("e.data.type=="+e.data.type);			switch(e.data.type){								case RETURNTYPE:									break;							}		}				private function onStreamDataView(e:MuleEvent):void{			debug("onStreamDataView()");			debug("e.data.sender=="+e.data.sender);			debug("e.data.type=="+e.data.type);			switch(e.data.type){																default:					debug("onStreamDataView()");					debug("*type not found");					debug("e.data.sender=="+e.data.sender);					debug("e.data.type=="+e.data.type);				break;							}		}*/				//*****Gets and Sets						//*****Utility Functions				//**visibility		/*public function show():void{			this.visible = true;		}				public function hide():void{			this.visible = false;		}*/				//**debug		private function debug(str:String):void{			appData.debug(NAME,str);		}				}//end class}//end package