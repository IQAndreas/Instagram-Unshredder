package 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;

	public class Slice
	{
		public static function fromPizza(pizza:Pizza, id:uint):Slice
		{
			var bitmapData:BitmapData = pizza.bitmapData;
			var slice:Slice = new Slice(pizza.sliceWidth, bitmapData.height);
			slice.bitmapData.copyPixels(bitmapData, new Rectangle(pizza.sliceWidth * id, 0, pizza.sliceWidth, bitmapData.height), new Point(0, 0));
			return slice;
		}
		
		public static function fromMerge(leftSlice:Slice, rightSlice:Slice):Slice
		{
			var slice:Slice = new Slice(leftSlice.bitmapData.width + rightSlice.bitmapData.width, leftSlice.bitmapData.height);
			slice.bitmapData.copyPixels(leftSlice.bitmapData, leftSlice.bitmapData.rect, new Point(0, 0));
			slice.bitmapData.copyPixels(rightSlice.bitmapData, rightSlice.bitmapData.rect, new Point(leftSlice.bitmapData.width, 0));
			
			return slice;
		}
		
		public function Slice(width:uint, height:uint)
		{
			this.bitmapData = new BitmapData(width, height, true, 0x00000000);
		}
		
		public var bitmapData:BitmapData;
	}
}
