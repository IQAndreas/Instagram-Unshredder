package 
{
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Main extends Sprite
	{
		public function Main()
		{
			if (stage) { this.init(); }
			else { this.addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		[Embed(source="../assets/after_shred.png")]
		private static var AfterShredBMP:Class;
		private var AfterShredBMD:BitmapData = Bitmap(new AfterShredBMP()).bitmapData;
		
		[Embed(source="../assets/before_shred.png")]
		private static var BeforeShredBMP:Class;
		private var BeforeShredBMD:BitmapData = Bitmap(new BeforeShredBMP()).bitmapData;
		
		private function init():void
		{
			var bmd:BitmapData = AfterShredBMD;
			
			const width:uint = bmd.width;
			const height:uint = bmd.height;
			
			var cmp:BitmapData = new BitmapData(width, height);
			
			var rLine:Shape = new Shape();
			this.addChild(rLine);
			var r:Graphics = rLine.graphics;
			r.lineStyle(0, 0xFF0000);
			r.moveTo(0, height);
			
			var gLine:Shape = new Shape();
			this.addChild(gLine);
			var g:Graphics = gLine.graphics;
			g.lineStyle(0, 0x00FF00);
			g.moveTo(0, height);
			
			var bLine:Shape = new Shape();
			this.addChild(bLine);
			var b:Graphics = bLine.graphics;
			b.lineStyle(0, 0x0000FF);
			b.moveTo(0, height);
			
			for (var sourceX:uint = 0; sourceX < (width - 1); sourceX++)
			{
				var totalRedDiff:Number = 0;
				var totalGreenDiff:Number = 0;
				var totalBlueDiff:Number = 0;
				
				for (var sourceY:uint = 0; sourceY < (height); sourceY++)
				{
					var pixelLeft:uint = bmd.getPixel(sourceX, sourceY);
					var pixelRight:uint = bmd.getPixel(sourceX + 1, sourceY);
					
					totalRedDiff += getDiff(pixelLeft, pixelRight, RED);
					totalGreenDiff += getDiff(pixelLeft, pixelRight, GREEN);
					totalBlueDiff += getDiff(pixelLeft, pixelRight, BLUE);
					
					//var averageDiff:Number = (redDiff + greenDiff + blueDiff)/3;
					//cmp.setPixel(sourceX, sourceY, makeGray(1-averageDiff/255));
				}
				
				var avgRedDiff:Number = totalRedDiff / height;
				var avgGreenDiff:Number = totalGreenDiff / height;
				var avgBlueDiff:Number = totalBlueDiff / height;
				
				//trace(avgRedDiff, avgGreenDiff, avgBlueDiff);

				var rChange:Number = (1 - avgRedDiff/255) * height;
				var gChange:Number = (1 - avgGreenDiff/255) * height;
				var bChange:Number = (1 - avgBlueDiff/255) * height;
						
				//r.lineTo(sourceX, (avgRedDiff/255) * height);
				//g.lineTo(sourceX, (avgGreenDiff/255) * height);
				//b.lineTo(sourceX, (avgBlueDiff/255) * height);
				
				cmp.setPixel(sourceX, int(rChange), 0xFF0000);
				cmp.setPixel(sourceX, int(gChange), 0x00FF00);
				cmp.setPixel(sourceX, int(bChange), 0x0000FF);
				
			}
			
			var bmp:Bitmap = new Bitmap(cmp);
			this.addChild(bmp);
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
		
		public function makeGray(Brightness:Number, Alpha:Number=1.0):uint
		{
			var tone:uint = (Brightness * 255) & 0xFF;
			return (((Alpha>1)?Alpha:(Alpha * 255)) & 0xFF) << 24 | tone << 16 | tone << 8 | tone;
		}
		
		
	}
}
