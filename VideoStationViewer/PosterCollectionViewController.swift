import UIKit

class PosterCollectionViewController: UICollectionViewController {
	// MARK: Properties
	
	private static let minimumEdgePadding = CGFloat(90.0)
	private var movieRepository:MovieRepository!
	private var genres = [Genre]()
	private var listType = "Movie"
	
	// MARK: UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let coreDataHelper = CoreDataHelper.sharedInstance
		self.movieRepository = MovieRepository(moc: coreDataHelper.managedObjectContext!)
		
		// Make sure their is sufficient padding above and below the content.
		guard let collectionView = collectionView, layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
		
		collectionView.contentInset.top = PosterCollectionViewController.minimumEdgePadding - layout.sectionInset.top
		collectionView.contentInset.bottom = PosterCollectionViewController.minimumEdgePadding - layout.sectionInset.bottom
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		// Get a list of genres and then reload the collection, which in turn will load the media items for each genre
		self.genres = movieRepository!.getGenres(self.listType)
		self.collectionView!.reloadData()
	}
	
	// MARK: UICollectionViewDataSource
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return genres.count
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// Each section contains a single `CollectionViewContainerCell`.
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		// Dequeue a cell from the collection view.
		return collectionView.dequeueReusableCellWithReuseIdentifier(PosterStrip.reuseIdentifier, forIndexPath: indexPath)
	}
	
	// MARK: UICollectionViewDelegate
	
	override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		//print("Poster Collection: will display cell \(indexPath)")
		guard let cell = cell as? PosterStrip else { fatalError("Expected to display a `CollectionViewContainerCell`.") }
		let genre = genres[indexPath.section].genre
		
		movieRepository.getEntitySummariesForGenre(genre!, entityType: listType) { (mediaItems, error) -> Void in
			cell.configureWithMediaItems(mediaItems!)
		}

	}
	
	override func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		/*
		Return `false` because we don't want this `collectionView`'s cells to
		become focused. Instead the `UICollectionView` contained in the cell
		should become focused.
		*/
		return false
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		let cell = sender as! PosterCell
		let controller = segue.destinationViewController as! MovieDetailViewController
		controller.movie = nil
		
		movieRepository.getMovie((cell.representedDataItem?.id?.integerValue)!) { (movie, error) -> Void in
			controller.movie = movie
		}
		
	}
	
	// Todo find a way to display a section title

	internal func setTitleAndType(title:String, type:String) {
		self.title = title
		self.listType = type
	}
	
	override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

		switch kind {
			case UICollectionElementKindSectionHeader:
				let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "PosterHeaderView", forIndexPath: indexPath) as! PosterHeaderCollectionReusableView
				headerView.title.text = genres[indexPath.section].genre
				return headerView
			default:
				assert(false, "Unexpected element kind")
		}
	}

}
