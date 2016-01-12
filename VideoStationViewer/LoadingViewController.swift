import UIKit

class LoadingViewController: UIViewController {

	private let preferences:NSUserDefaults = NSUserDefaults.standardUserDefaults()
	let session = SessionAPI.sharedInstance
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		// If not running in test mode
		if NSProcessInfo.processInfo().environment["XCInjectBundle"] == nil {
			
			// Try to login, this will fail if no settings or no network or bad settings
			session.login { (session, error) -> Void in
				
				if (error != nil) {
					self.showError()
					return
				}
				
				let coreDataHelper = CoreDataHelper.sharedInstance
				coreDataHelper.resetContext()
				
				if let moc = coreDataHelper.managedObjectContext {
					let movieImportService = MovieImportService(moc: moc)
					movieImportService.importMovies({ (total, error) -> Void in
						
						movieImportService.importShows({ (total, error) -> Void in
							let tabBarController = TabBarViewController()
							self.presentViewController(tabBarController, animated: true, completion: nil)
						})
					
					})
					
				} else {
					self.showError()
					return
				}
				
			}
		}
		
	}
	
	// If you fail, load the tab bar controller anyway, it will see no session and wont show movies.
	func showError() {
		let alertController = UIAlertController(title: "Synology Login", message: "Error logging in to Synology NAS", preferredStyle: .Alert)
		let ok = UIAlertAction(title: "OK", style: .Default) { (action) in
			alertController.dismissViewControllerAnimated(true, completion: nil)
			let tabBarController = TabBarViewController()	
			self.presentViewController(tabBarController, animated: true, completion: nil)
		}
		alertController.addAction(ok)
		
		self.presentViewController(alertController, animated: true) {
		}
	}
	

}
 