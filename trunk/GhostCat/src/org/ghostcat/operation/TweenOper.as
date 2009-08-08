package org.ghostcat.operation
{
	import org.ghostcat.events.TweenEvent;
	import org.ghostcat.util.TweenUtil;

	/**
	 * 与内部Tween对应的Oper
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TweenOper extends Oper
	{
		public var target:*;
		public var duration:int;
		public var params:Object;
		
		public var tween:TweenUtil;
		
		public function TweenOper(target:*,duration:int,params:Object)
		{
			super();
			this.target = target;
			this.duration = duration;
			this.params = params;
		}
		
		public override function execute() : void
		{
			super.execute();
			tween = new TweenUtil(target,duration,params);
			tween.addEventListener(TweenEvent.TWEEN_END,result);
		}
		
		public override function result(event:*=null):void
		{
			tween.removeEventListener(TweenEvent.TWEEN_END,result);
			super.result(event);
		}
	}
}