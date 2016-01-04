import UIKit
import AVKit

class MovieDetailViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var summary: UILabel!
	@IBOutlet weak var movieTitle: UILabel!
	
	let movieRepository = MovieRepository.sharedInstance
	
	var movie:Movie? {
		didSet {
			if self.isViewLoaded() {
				self.layout()
			}
		}
	}

	var avPlayer:AVPlayer!
	var avController:AVPlayerViewController!
	
	override func viewDidLoad() {
		if self.movie != nil {
			layout()
		}
	}
	
	func layout() {
		if let movieValue = self.movie {
			
			self.movieTitle.text = movieValue.title
			self.summary.text = movieValue.summary
			self.setupVideo()
			
			movieValue.getImage { (image, error) -> Void in
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
		if let url = self.movie?.getMovieUrl() {
			let avPlayer = AVPlayer(URL: url)
			let aViewController = AVPlayerViewController()
				
			aViewController.player = avPlayer;
				
			self.avPlayer = avPlayer
			self.avController = aViewController
		}
	}
	
}
