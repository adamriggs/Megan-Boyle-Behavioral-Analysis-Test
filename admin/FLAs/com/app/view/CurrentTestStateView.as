﻿// com.app.view.CurrentTestStateView// Adam Riggs//package com.app.view {	import com.adam.events.MuleEvent;	import com.adam.utils.AppData;	import com.app.model.Model;		import fl.controls.ComboBox;	import fl.data.DataProvider;		import flash.display.Sprite;	import flash.events.*;	import flash.net.URLVariables;	import flash.text.TextField;	import flash.utils.Timer;	import flash.display.MovieClip;		public class CurrentTestStateView extends Sprite {				//vars		private var phaseArray,componentArray,testArray:Array;		private var _dataObj:Object;		private var _dataInterval:Number;		private var _firstUpdate:Boolean;				//objects		private var appData:AppData=AppData.instance;		private var model:Model;		private var dataTimer:Timer;				//display objects		public var participantTxt,teststateTxt,phaseTxt,nextphaseTxt,componentTxt,componentStartTxt,testStartTxt:TextField;		public var phaseCmb,testCmb:ComboBox;		public var refreshBtn,setBtn:MovieClip;		public var startDataBtn, stopDataBtn:MovieClip;		public var dataTxt:TextField;				//const		public const NAME:String="currentTestStateView";		public const RETURNTYPE:String=NAME;		public const CONTROLLER:String="currentTestStateController";		private const UPDATE:String="update";						public function CurrentTestStateView(){						init();		}		//*****Initialization Routines				public function init():void{			debug("init()");						initVars();			initEvents();			initObjs();			initTxt();			initBtn();			initCmb();			initTimer();		}				private function initVars():void{						//local instances of other vars			_dataInterval=appData.model.dataTimerInterval;						//vars			phaseArray=new Array({label:"wait",data:"wait"},{label:"shaping",data:"shaping"},{label:"baseline",data:"baseline"},{label:"contrast",data:"contrast"});			testArray=new Array({label:"login",data:"login"},{label:"go",data:"go"},{label:"end",data:"end"});						_dataObj=new Object();			_firstUpdate=true;		}				private function initEvents():void{			appData.eventManager.listen(NAME, onCurrentTestStateView);			appData.eventManager.listen("sql", onSQL);		}				private function initObjs():void{					}				private function initTxt():void{			clearTxt();		}				private function initBtn():void{			//refreshBtn			refreshBtn.titleTxt.text="Refresh Values";			appData.makeHoverButton(refreshBtn, this);						setBtn.titleTxt.text="Set Values";			appData.makeHoverButton(setBtn, this);						startDataBtn.titleTxt.text="Start Data";			appData.makeHoverButton(startDataBtn, this);			startDataBtn.scaleX=.75;			startDataBtn.scaleY=.75;						stopDataBtn.titleTxt.text="Stop Data";			appData.makeHoverButton(stopDataBtn, this);			stopDataBtn.scaleX=.75;			stopDataBtn.scaleY=.75;		}				private function initCmb():void{			phaseCmb.dataProvider=new DataProvider(phaseArray);			testCmb.dataProvider=new DataProvider(testArray);		}				private function initTimer():void{			dataTimer=new Timer(_dataInterval);			dataTimer.addEventListener(TimerEvent.TIMER,onDataTimer);		}		//*****Core Functionality				public function startData():void{			//debug("startData()");			dataTimer.start();			dataTxt.text="started";		}				public function stopData():void{			dataTimer.stop();			dataTimer.reset();			dataTxt.text="stopped";		}				private function clearTxt():void{			participantTxt.text="";			phaseTxt.text="";			componentTxt.text="";			componentStartTxt.text="";			testStartTxt.text="";		}				private function setTxt():void{			//debug("setTxt()");			//appData.listObject(_dataObj);			participantTxt.text=_dataObj.participant.toString();			teststateTxt.text=_dataObj.teststate.toString();			phaseTxt.text=_dataObj.phase.toString();			nextphaseTxt.text=_dataObj.nextphase.toString();			componentTxt.text=_dataObj.component.toString();			componentStartTxt.text=appData.toLocalTime(_dataObj.componentstart);			debug("_dataObj.componentstart.toString()=="+_dataObj.componentstart.toString());			//testStartTxt.text=_dataObj.;		}				public function setCmb(cmb:ComboBox, val:String):void{			for(var i:uint=0;i<phaseArray.length;i++){				//var tmp:String=;				if(cmb.getItemAt(i).data.toString()==val){					cmb.selectedItem=cmb.getItemAt(i);					break;				} else {					for(var item in cmb.getItemAt(i)){						//trace(item + "==" + cmb.getItemAt(i)[item]);					}				}			}		}				private function update(obj:Object):void{			debug("update()");			//appData.listObject(obj);			_dataObj=obj;			setTxt();			if(_firstUpdate){				setCmb(phaseCmb,_dataObj.nextphase);				setCmb(testCmb,_dataObj.teststate);				_firstUpdate=false;			}		}				private function refreshData():void{			debug("refreshData()");			appData.eventManager.dispatch(CONTROLLER, {type:"refreshData", sender:NAME});		}				private function setData():void{			debug("setData()");						var phaseData:String=phaseCmb.selectedItem.data.toString();			var testData:String=testCmb.selectedItem.data.toString();						appData.eventManager.dispatch(CONTROLLER, {type:"setData", sender:NAME, phaseData:phaseData, testData:testData});		}				//*****Event Handlers				private function onDataTimer(e:TimerEvent):void{			//debug("onDataTimer()");			refreshData();		}				private function onSQL(e:MuleEvent):void{			/*debug("onSQL()");			debug("e.data.sender=="+e.data.sender);			debug("e.data.type=="+e.data.type);*/			switch(e.data.type){								case RETURNTYPE:									break;							}		}				private function onCurrentTestStateView(e:MuleEvent):void{			/*debug("onCurrentTestStateView()");			debug("e.data.sender=="+e.data.sender);			debug("e.data.type=="+e.data.type);*/			switch(e.data.type){								case UPDATE:					update(e.data.dataObj);				break;								default:					debug("onCurrentTestStateView()");					debug("*type not found");					debug("e.data.sender=="+e.data.sender);					debug("e.data.type=="+e.data.type);				break;							}		}				private function onCmbChange(e:Event):void{			//debug("ComboBox(e.target).selectedItem.data=="+ComboBox(e.target).selectedItem.data); 			//debug("ComboBox(e.target).name=="+ComboBox(e.target).name);			appData.eventManager.dispatch(CONTROLLER, {type:ComboBox(e.target).name, sender:"currentTestStateView", selectedItem:ComboBox(e.target).selectedItem.data});					}				public function onClick(e:MouseEvent):void{			switch(e.currentTarget){								case refreshBtn:					refreshData();				break;								case setBtn:					setData();				break;								case startDataBtn:					startData();				break;								case stopDataBtn:					stopData();				break;							}		}				//*****Gets and Sets				public function get dataObj():Object{return _dataObj;}		//*****Utility Functions				//**visibility		public function show():void{			this.visible = true;		}				public function hide():void{			this.visible = false;		}				//**debug		private function debug(str:String):void{			//appData.debug(NAME,str);		}				}//end class}//end package