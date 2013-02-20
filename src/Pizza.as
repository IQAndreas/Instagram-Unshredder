package 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class Pizza 
	{
		public function Pizza(bitmapData:BitmapData, sliceWidth:uint) 
		{
			this.bitmapData = bitmapData;
			this.sliceWidth = sliceWidth;
			
			numSlices = int(bitmapData.width / sliceWidth);
			slices = new Vector.<Slice>();
			
			for (var i:int = 0; i < numSlices; i++)
			{
				slices.push(Slice.fromPizza(this, i));
			}
			
			this.generateComparisons();
			
			
		}
		
		public var bitmapData:BitmapData;
		public var sliceWidth:uint;
		public var numSlices:uint;
		public var slices:Vector.<Slice>;
		
		private function generateComparisons():Vector.<Comparison>
		{
			var comparisons:Vector.<Comparison> = new Vector.<Comparison>();
			
			for each (var leftSlice:Slice in slices)
			{
				for each (var rightSlice:Slice in slices)
				{
					if (leftSlice != rightSlice)
					{
						comparisons.push(new Comparison(leftSlice, rightSlice));
					}
				}
			}
			
			return comparisons;
		}
		
		public function mergeMostSimilar():void
		{
			if (slices.length <= 1) { return; } 
			
			var smallestDifference:Number = Number.MAX_VALUE;
			var smallest:Comparison;
			
			var comparisons:Vector.<Comparison> = this.generateComparisons();
			
			for each (var c:Comparison in comparisons)
			{
				if (c.similarity < smallestDifference)
				{
					smallest = c;
					smallestDifference = c.similarity;
				}
			}
			
			var newSlice:Slice = Slice.fromMerge(smallest.leftSlice, smallest.rightSlice);
			removeFromVector(smallest.leftSlice, slices);
			removeFromVector(smallest.rightSlice, slices);
			slices.push(newSlice);
			
			// Just make new comparisons for now...
			
			if (slices.length == 1)
			{
				trace("DONE!");
			}
		}
		
		private function removeFromVector(item:*, vector:*):void
		{
			var index:int = vector.indexOf(item);
			if (index >= 0) { vector.splice(index, 1); }
		}
		
		// Make sure container is emptied first, (if you want it to be emptied that is)
		public function fillContainer(container:DisplayObjectContainer, paddingX:Number = 8):void
		{
			var currentX:Number = 0;
			for each (var slice:Slice in slices)
			{
				//Don't clone, just add. I'm being lazy but efficient here
				// (even though I am creating a new Bitmap every time)
				var bmp:Bitmap = new Bitmap(slice.bitmapData);
				bmp.x = currentX;
				currentX += bmp.width + paddingX;
				container.addChild(bmp);
			}
		}
		
		public function generatePicture():BitmapData
		{
			var bmd:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
			
			var currentX:uint = 0;
			for each (var slice:Slice in slices)
			{
				bmd.copyPixels(slice.bitmapData, slice.bitmapData.rect, new Point(currentX, 0));
				currentX += slice.bitmapData.width;
			}
			
			return bmd;
		}
		
		
	}
}
