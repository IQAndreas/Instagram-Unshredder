package 
{
	import flash.display.BitmapData;
	public class Comparison 
	{
		public function Comparison(leftSlice:Slice, rightSlice:Slice)
		{
			this.leftSlice = leftSlice;
			this.rightSlice = rightSlice;
			
			
			const height:uint = leftSlice.bitmapData.height;
			const leftBMD:BitmapData = leftSlice.bitmapData;
			const rightBMD:BitmapData = rightSlice.bitmapData;
			const leftBMDX:uint = leftBMD.width - 1;
			
			var totalRedDiff:Number = 0;
			var totalGreenDiff:Number = 0;
			var totalBlueDiff:Number = 0;
			
			
			for (var y:uint = 0; y < height; y++)
			{
				var pixelLeft:uint = leftBMD.getPixel(leftBMDX, y);
				var pixelRight:uint = rightBMD.getPixel(0, y);
				
				totalRedDiff += getDiff(pixelLeft, pixelRight, RED);
				totalGreenDiff += getDiff(pixelLeft, pixelRight, GREEN);
				totalBlueDiff += getDiff(pixelLeft, pixelRight, BLUE);
			}
			
			var avgRedDiff:Number = totalRedDiff / height;
			var avgGreenDiff:Number = totalGreenDiff / height;
			var avgBlueDiff:Number = totalBlueDiff / height;
			
			this.similarity = avgRedDiff + avgBlueDiff + avgGreenDiff;
			
			//trace(avgRedDiff, avgGreenDiff, avgBlueDiff);

			//var rChange:Number = (1 - avgRedDiff/255) * height;
			//var gChange:Number = (1 - avgGreenDiff/255) * height;
			//var bChange:Number = (1 - avgBlueDiff/255) * height;
		}
		
		
		public static const ALPHA:uint = 24;
		public static const RED:uint = 16;
		public static const BLUE:uint = 8;
		public static const GREEN:uint = 0;
		
		// Returns a value between 0 and 255.
		//The larger the number, the larger the difference between values
		public function getDiff(pixel1:uint, pixel2:uint, channel:uint):uint
		{
			var c1:uint = (pixel1 >> channel & 0xFF);
			var c2:uint = (pixel2 >> channel & 0xFF);
			return (c1 > c2) ? (c1 - c2) : (c2 - c1);
		}
		
		public var leftSlice:Slice;
		public var rightSlice:Slice;
		public var similarity:Number;
	}
}
