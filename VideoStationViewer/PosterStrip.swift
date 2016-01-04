import UIKit

class PosterStrip: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
	// MARK: Properties
	
	static let reuseIdentifier = "CollectionViewContainerCell"
	var mediaItems = [MediaItem]()
	
	@IBOutlet var collectionView: UICollectionView!
	
	private let cellBuilder = PosterCellBuilder()
	
	override var preferredFocusedView: UIView? {
		return collectionView
	}
	
	// MARK: Configuration
	
	func configureWithMediaItems(mediaItems:[MediaItem]) {
		self.mediaItems = mediaItems;
		self.collectionView!.reloadData()
	}
	
	// MARK: UICollectionViewDataSource
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return mediaItems.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCellWithReuseIdentifier(PosterCell.reuseIdentifier, forIndexPath: indexPath)
	}
	
	// MARK: UICollectionViewDelegate
	
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		guard let cell = cell as? PosterCell else { fatalError("Expected to display a DataItemCollectionViewCell") }
		let item = mediaItems[indexPath.row]
		
		// Configure the cell.
		cellBuilder.composeCell(cell, withDataItem: item)
	}
	
}

