import UIKit

class TabBarViewController: UITabBarController {

	var moviePosterCollectionViewController:PosterCollectionViewController!
	var tvPosterCollectionViewController:PosterCollectionViewController!
	var searchViewController:UIViewController!
	var settingsViewController:SettingsViewController!

	let sessionAPI = SessionAPI.sharedInstance
	
    override func viewDidLoad() {
        super.viewDidLoad()
		resetView()
    }
	
	// Call this on initial startup and when settings are changed
	// If the user has a valid session, show the movies, otherwise just show settings
	func resetView() {
		let listDetailStoryboard = UIStoryboard(name: "Movies", bundle: NSBundle.mainBundle())
		let settingsStoryboard = UIStoryboard(name: "Settings", bundle: NSBundle.mainBundle())
		
		if let _ = self.sessionAPI.getSid() {
			
			moviePosterCollectionViewController = listDetailStoryboard.instantiateViewControllerWithIdentifier("PosterCollection") as! PosterCollectionViewController
			moviePosterCollectionViewController.entityRepository = MovieRepository.sharedInstance
			moviePosterCollectionViewController.setTitleAndType("Movies", type: "Movie")
			
			tvPosterCollectionViewController = listDetailStoryboard.instantiateViewControllerWithIdentifier("PosterCollection") as! PosterCollectionViewController
			tvPosterCollectionViewController.entityRepository = EpisodeRepository.sharedInstance
			tvPosterCollectionViewController.setTitleAndType("TV Programmes", type: "Episode")

			settingsViewController = settingsStoryboard.instantiateViewControllerWithIdentifier("Settings") as! SettingsViewController
			self.setViewControllers([moviePosterCollectionViewController, tvPosterCollectionViewController, settingsViewController], animated: true)
			
		} else {
			settingsViewController = settingsStoryboard.instantiateViewControllerWithIdentifier("Settings") as! SettingsViewController
			self.setViewControllers([settingsViewController], animated: true)
		}
		

	}
	
	

	

}
