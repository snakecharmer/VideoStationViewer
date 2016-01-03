import UIKit

class PosterCellBuilder {
	// MARK: Properties
	private let imageRepository = ImageAPI.sharedInstance
	private var operationQueues = [PosterCell: NSOperationQueue]()
	
	// MARK: Implementation
	
	func composeCell(cell: PosterCell, withDataItem dataItem: Movie) {
		if cell.representedDataItem == dataItem {
			return
		}
		
		// Cancel any queued operations to process images for the cell.
		let operationQueue = operationQueueForCell(cell)
		operationQueue.cancelAllOperations()
		
		cell.representedDataItem = dataItem
		cell.label.text = dataItem.title
		
		cell.imageView.alpha = 0.0
		
		/*
		Initial rendering of a jpeg image can be expensive, as is fetching it. To avoid stalling
		the main thread, we create an operation to process the `DataItem`'s
		image before updating the cell's image view.
		
		The execution block is added after the operation is created to allow
		the block to check if the operation has been cancelled.
		*/
		let processImageOperation = NSBlockOperation()
		
		processImageOperation.addExecutionBlock { [unowned processImageOperation] in
			// Ensure the operation has not been cancelled.
			guard !processImageOperation.cancelled else { return }
			
			
			self.imageRepository.getImage((dataItem.id?.integerValue)!) { (image, error) -> Void in
				
				// Store the processed image in the cache.
				NSOperationQueue.mainQueue().addOperationWithBlock {
					// Check that the cell is still showing the same `DataItem`.
					guard dataItem == cell.representedDataItem else { return }
					
					// Update the cell's `UIImageView` and then fade it into view.
					cell.imageView.image = image
					
					UIView.animateWithDuration(0.25) {
						cell.imageView.alpha = 1.0
					}
				}
				
			}
			
			
		}
		
		operationQueue.addOperation(processImageOperation)
	}
	
	// MARK: Convenience
	
	/**
	Returns the `NSOperationQueue` for a given cell. Creates and stores a new
	queue if one doesn't already exist.
	*/
	private func operationQueueForCell(cell: PosterCell) -> NSOperationQueue {
		if let queue = operationQueues[cell] {
			return queue
		}
		
		let queue = NSOperationQueue()
		operationQueues[cell] = queue
		
		return queue
	}
	
}
