import UIKit
import AVKit

class MovieDetailViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var summary: UILabel!
	@IBOutlet weak var movieTitle: UILabel!
	
	let movieRepository = MovieRepository.sharedInstance
	
	var movieSummary:MovieSummary?
	var movieDetail:MovieDetail?

	var avPlayer:AVPlayer!
	var avController:AVPlayerViewController!
	
	override func viewDidLoad() {

		if let movieSummaryValue = self.movieSummary {

			self.movieTitle.text = movieSummaryValue.title
			self.summary.text = ""
			
			self.movieRepository.getMovie((movieSummaryValue.id?.integerValue)!, success: { (movie, error) -> Void in
				
				if let movieDetailValue = movie {
					
					self.movieDetail = movieDetailValue
					self.summary.text = movieDetailValue.summary
					self.setupVideo()
				
					movieDetailValue.getImage { (image, error) -> Void in
						self.imageView.image = image
					}
				
				}
			})
		}
		
		
	}
	
	
	@IBAction func showFullScreen(sender: AnyObject) {
		self.presentViewController(self.avController, animated: true, completion: {
			self.avPlayer.play()
		})
	}
	
	func setupVideo() {
		if let url = self.movieDetail?.getMovieUrl() {
			let avPlayer = AVPlayer(URL: url)
			let aViewController = AVPlayerViewController()
				
			aViewController.player = avPlayer;
				
			self.avPlayer = avPlayer
			self.avController = aViewController
		}
	}
	
}
