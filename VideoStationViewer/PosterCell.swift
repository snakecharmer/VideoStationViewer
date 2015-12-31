
import UIKit

class PosterCell: UICollectionViewCell {
	// MARK: Properties
	
	static let reuseIdentifier = "PosterCell"
	
	@IBOutlet weak var label: UILabel!
	
	@IBOutlet weak var imageView: UIImageView!
	
	var representedDataItem: MovieSummary?
	
	// MARK: Initialization
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		// These properties are also exposed in Interface Builder.
		imageView.adjustsImageWhenAncestorFocused = true
		imageView.clipsToBounds = false
	}
	

}
