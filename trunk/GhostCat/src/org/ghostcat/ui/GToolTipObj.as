package org.ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.ghostcat.core.ClassFactory;
	import org.ghostcat.display.GBase;
	import org.ghostcat.skin.code.ToolTipSkin;
	import org.ghostcat.util.Util;

	/**
	 * 提示类
	 * 
	 * 使用时候需要在参数里设置一个用来显示提示的默认ToolTipClass，诸如GToolTipObj(new GText(skin))
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GToolTipObj extends GBase
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(ToolTipSkin);
		/**
		 * 延迟显示的毫秒数 
		 */		
		public var delay:int = 500;
		
		/**
		 * 连续显示间隔的毫秒数 
		 */		
		public var cooldown:int = 250;
		
		/**
		 *  限定触发提示的类型，避免与其他框架冲突
		 */
		public var onlyWithClasses:Array;
		/**
		 * ToolTip目标
		 */		
		public var target:DisplayObject;
		
		/**
		 * 默认ToolTipClass
		 */		
		public var defaultObj:GBase;
		
		private var toolTipObjs:Object;//已注册的ToolTipObj集合
		
		private var delayTimer:Timer;//延迟显示计时器
		
		private var delayCooldown:Timer;//连续显示计时器
		
		private static var _instance:GToolTipObj;
		
		public function GToolTipObj(obj:GBase=null)
		{
			if (!obj)
				obj = defaultSkin.newInstance();
				
			super(obj,true);
			
			this.acceptContentPosition = false;
			
			if (!_instance)
				_instance = this;
			
			defaultObj = obj;
		}
		
		public static function get instance():GToolTipObj
		{
			return _instance;
		}
		
		public function get obj():GBase
		{
			return content as GBase;
		}
		
		/**
		 * 注册一个ToolTipObj
		 * 
		 * @param name	名称
		 * @param v	对象
		 * 
		 */		
		public function registerToolTipObj(name:String,v:GBase):void
		{
			toolTipObjs[name] = v;
		}
		
		/**
		 * 设置内容
		 * @return 
		 * 
		 */		
		public override function get data():*
		{
			return obj.data;
		}

		public override function set data(v:*):void
		{
			obj.data = v;
		}

		protected override function init() : void
		{
			super.init();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			this.x = parent.mouseX;
			this.y = parent.mouseY;
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			target = findToolTipTarget(event.target as DisplayObject);
			
			if (target){
				delayShow(delay);
			}else{
				hide();
			}
		}
		
		private function findToolTipTarget(displayObj : DisplayObject) : DisplayObject
		{
			var currentTarget:DisplayObject = displayObj;
			
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				if (currentTarget["toolTip"] && (onlyWithClasses == null || Util.isIn(cursor,onlyWithClasses)))
					return currentTarget;
				currentTarget = currentTarget.parent;
			}
			return null;
		}

		
		/**
		 * 延迟显示
		 * @param t	时间
		 * 
		 */		
		public function delayShow(t:int):void
		{
			if (delayCooldown){
				delayCooldown.delay = 0;
				t = 0;
			}
			
			if (delayTimer){
				delayTimer.delay = t;
			}else{
				delayTimer = new Timer(t,1);
				delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,show);
			}
		}
		
		private function show(event:TimerEvent):void
		{
			delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,show);
			delayTimer = null;
			
			var obj:* = target["toolTipObj"];
			if (obj is String){
				obj = toolTipObjs[obj];
			}
			if (!(obj is GBase))
				obj = defaultObj;
			setContent(obj);
			
			data = target["toolTip"];
		}
		
		/**
		 * 隐藏提示 
		 * 
		 */		
		public function hide():void
		{
			setContent(null);
			
			if (delayCooldown){
				delayCooldown.delay = cooldown;
			}else{
				delayCooldown = new Timer(cooldown,1);
				delayCooldown.addEventListener(TimerEvent.TIMER_COMPLETE,removeCooldown);
			}
		}
		
		private function removeCooldown(event:TimerEvent):void
		{
			delayCooldown.removeEventListener(TimerEvent.TIMER_COMPLETE,show);
			delayCooldown = null;
		}
		
		
		public override function destory() : void
		{
			super.destory();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
		}
	}
}
