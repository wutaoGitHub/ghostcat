package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import ghostcat.util.display.BitmapColorUtil;
	import ghostcat.util.hitTest.BitmapCollision;
	
	[SWF(frameRate="25",width="1000",height="1000")]
	public class BitmapCollisionExample extends Sprite 
	{
		[Embed(source="p5.png")]
		public var cls:Class;
		private var bitmapData:BitmapData;
		private var collision1:BitmapCollision;
		private var collision2:BitmapCollision;
		
		public var b1:Bitmap;
		public var b2:Bitmap;

		private var textField:TextField;
		
		public function BitmapCollisionExample()
		{
			bitmapData = new cls().bitmapData;
			bitmapData = BitmapColorUtil.getTransparentBitmapData(bitmapData);
			
			this.b1 = new Bitmap(bitmapData);
			this.addChild(b1);
			this.b2 = new Bitmap(bitmapData.clone());
			this.addChild(b2);
			
			collision1 = new BitmapCollision(this.b1.bitmapData);
			collision2 = new BitmapCollision(this.b2.bitmapData);
			
			addEventListener(Event.ENTER_FRAME,tickHandler);
			
			this.textField = new TextField();
			stage.addChild(this.textField);
		}
		
		private function tickHandler(e:Event):void
		{
			this.b2.x = mouseX - 200;
			this.b2.y = mouseY - 200;
			this.collision2.x = mouseX - 200;
			this.collision2.y = mouseY - 200;
			
			var t:int = getTimer();
			var b:Boolean;
			for (var i:int = 0;i < 100;i++)
				b = this.collision1.hitTestObject(this.collision2);
			this.textField.text = "100次计算记时: "+(getTimer() - t).toString();
			this.transform.colorTransform = b ? new ColorTransform(1,1,1,1,255) : new ColorTransform();
		}
		
	}
}