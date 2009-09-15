package ghostcat.ui.controls
{
	import ghostcat.ui.UIConst;
	import ghostcat.util.ClassFactory;
	
	/**
	 * 纵向滚动条
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class GVScrollBar extends GScrollBar
	{
		[Embed(skinClass="ghostcat.skin.VScrollBarSkin")]
		private static const CursorGroupClass:Class;//这里不直接导入CursorGroup而用Embed中转只是为了正常生成ASDoc
		public static var defaultSkin:ClassFactory = new ClassFactory(CursorGroupClass);
		
		public function GVScrollBar(skin:*=null, replace:Boolean=true)
		{
			if (!skin)
				skin = defaultSkin;
			
			super(skin, replace);
			
			this.direction = UIConst.VERTICAL;
		}
	}
}