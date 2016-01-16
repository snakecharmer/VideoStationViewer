import UIKit
import AVKit

class MovieDetailViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var summary: UILabel!
	@IBOutlet weak var movieTitle: UILabel!
	
	let movieRepository = MovieRepository.sharedInstance
	
	var mediaItem:MediaItem? {
		didSet {
			if self.isViewLoaded() {
				self.layout()
			}
		}
	}

	var avPlayer:AVPlayer!
	var avController:AVPlayerViewController!
	
	override func viewDidLoad() {
		if self.mediaItem != nil {
			layout()
		}
	}
	
	func layout() {
		if let mediaItemValue = self.mediaItem {
			
			self.movieTitle.text = mediaItemValue.title
			self.summary.text = mediaItemValue.summary
			self.setupVideo()
			
			mediaItemValue.getImage { (image, error) -> Void in
				self.imageView.image = image
			}
		}
	}
	
	@IBAction func showFullScreen(sender: AnyObject) {
		self.presentViewController(self.avController, animated: true, completion: {
			self.avPlayer.play()
		})
	}
	
	func setupVideo() {
		if let url = self.mediaItem?.getMovieUrl() {
			let avPlayer = AVPlayer(URL: url)
			let aViewController = AVPlayerViewController()
				
			aViewController.player = avPlayer;
				
			self.avPlayer = avPlayer
			self.avController = aViewController
		}
	}
	
}
