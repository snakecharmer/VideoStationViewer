import UIKit

class PosterStrip: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
	// MARK: Properties
	
	static let reuseIdentifier = "CollectionViewContainerCell"
	var genre = ""
	
	@IBOutlet var collectionView: UICollectionView!
	
	private var dataItems = [MovieSummary]()
	private let cellBuilder = PosterCellBuilder()
	
	override var preferredFocusedView: UIView? {
		return collectionView
	}
	
	// MARK: Configuration
	
	func configureWithGenre(genre:Genre) {
		
		self.genre = genre.genre!;
		self.dataItems = [MovieSummary]()
		self.collectionView!.reloadData()
		
		let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
		self.dataItems = genre.movies?.sortedArrayUsingDescriptors([descriptor]) as! [MovieSummary]!
		self.collectionView!.reloadData()

	}
	
	// MARK: UICollectionViewDataSource
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataItems.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCellWithReuseIdentifier(PosterCell.reuseIdentifier, forIndexPath: indexPath)
	}
	
	// MARK: UICollectionViewDelegate
	
	func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		guard let cell = cell as? PosterCell else { fatalError("Expected to display a DataItemCollectionViewCell") }
		let item = dataItems[indexPath.row]
		
		// Configure the cell.
		cellBuilder.composeCell(cell, withDataItem: item)
	}
	
}

