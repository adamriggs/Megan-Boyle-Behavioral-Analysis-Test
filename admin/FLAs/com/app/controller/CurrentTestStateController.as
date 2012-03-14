﻿// com.app.controller.CurrentTestStateController// Adam Riggs//package com.app.controller {	import com.adam.events.MuleEvent;	import com.adam.utils.AppData;		import flash.display.Sprite;	import flash.events.*;	import flash.net.URLVariables;		public class CurrentTestStateController{				//vars		private var _urlVarsUpdate:URLVariables;		private var _urlVarsSelect:URLVariables;				//objects		private var appData:AppData=AppData.instance;				//const		public const NAME:String="currentTestStateController";		public const RETURNTYPE:String=NAME;		public const TABLE:String="currentTest";		public const COLUMNS:String="participant, test, phase, nextphase, component, componentstart, teststate";		public const MODEL:String="currentTestStateModel";		private const REFRESH_DATA:String="refreshData";		private const SET_DATA:String="setData";				/** Storage for the singleton instance. */		private static const _instance:CurrentTestStateController = new CurrentTestStateController(CurrentTestStateControllerLock);				public function CurrentTestStateController(lock:Class){			// Verify that the lock is the correct class reference.			if (lock != CurrentTestStateControllerLock)			{				throw new Error("Invalid CurrentTestStateController access.  Use CurrentTestStateController.instance instead.");			} else {				init();			}		}		//*****Initialization Routines				public function init():void{			debug("init()");						initVars();			initEvents();			initObjs();		}				private function initVars():void{			_urlVarsUpdate=new URLVariables();						_urlVarsSelect=new URLVariables();			_urlVarsSelect.table=TABLE;			_urlVarsSelect.columns=COLUMNS;		}				private function initEvents():void{			appData.eventManager.listen(NAME, onCurrentTestStateController);			appData.eventManager.listen("sql", onSQL);		}				private function initObjs():void{					}		//*****Core Functionality				private function refreshData():void{			appData.eventManager.dispatch("sqlProxy", {type:"selectSQL", sender:NAME, vars:_urlVarsSelect, returnType:MODEL});		}				private function setData(obj:Object):void{			debug("setData()");			_urlVarsUpdate=new URLVariables();			_urlVarsUpdate.table="currentTest";			_urlVarsUpdate.id="1";			_urlVarsUpdate.nextphase=obj.phaseData;			_urlVarsUpdate.teststate=obj.testData;			appData.sqlProxy.updateSQL(_urlVarsUpdate,RETURNTYPE+"-setData");		}		//*****Event Handlers				private function onSQL(e:MuleEvent):void{			/*debug("onSQL()");			debug("e.data.sender=="+e.data.sender);			debug("e.data.type=="+e.data.type);*/			switch(e.data.type){								case RETURNTYPE:									break;								case RETURNTYPE+"-setData":					debug("e.data.result=="+e.data.result);				break;							}		}				private function onCurrentTestStateController(e:MuleEvent):void{			/*debug("onCurrentTestStateController()");			debug("e.data.sender=="+e.data.sender);			debug("e.data.type=="+e.data.type);*/			switch(e.data.type){								case REFRESH_DATA:					refreshData();				break;								case SET_DATA:					setData(e.data);				break;								default:					debug("onCurrentTestStateController()");					debug("*type not found");					debug("e.data.sender=="+e.data.sender);					debug("e.data.type=="+e.data.type);				break;							}		}				//*****Gets and Sets				public static function get instance():CurrentTestStateController{return _instance;}		//*****Utility Functions				//**debug		private function debug(str:String):void{			appData.debug(NAME,str);		}				}//end class}//end packageclass CurrentTestStateControllerLock{}