package
{
	import flash.display.Sprite;
	
	import ghostcat.display.viewport.Tile45;
	import ghostcat.events.RepeatEvent;
	import ghostcat.manager.DragManager;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.CursorSprite;
	import ghostcat.util.Util;

	/**
	 * 这个类生成了一个100000 x 100000的重复区域，但Repeater类的实际体积其实只有屏幕大小，因此并不消耗资源
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class Tile45Example extends Sprite
	{
		public var repeater:Tile45
		public function Tile45Example()
		{
			RootManager.register(this,1,1);
			repeater = new Tile45(TestRepeater45);
			repeater.width = 100000;
			repeater.height = 100000;
			repeater.addEventListener(RepeatEvent.ADD_REPEAT_ITEM,addRepeatItemHandler);
			repeater.cursor = CursorSprite.CURSOR_DRAG;
			
			addChild(repeater);
			addChild(new CursorSprite())
			
			DragManager.register(repeater);
			
		}
		private function addRepeatItemHandler(event:RepeatEvent):void
		{
			(event.repeatObj as TestRepeater45).point.text = event.repeatPos.toString();
		}
	}
}