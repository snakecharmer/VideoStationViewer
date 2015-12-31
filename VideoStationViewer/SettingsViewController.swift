import UIKit

class SettingsViewController: UIViewController {

	@IBOutlet weak var hostname: UITextField!
	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var password: UITextField!
	
	private let preferences = NSUserDefaults.standardUserDefaults()
	
	
	override func viewDidLoad() {
		let preferences = NSUserDefaults.standardUserDefaults()
		if let user = preferences.stringForKey("USERID") {
			self.username.text = user
		}
		if let hostname = preferences.stringForKey("HOSTNAME") {
			self.hostname.text = hostname
		}
	}
	
	
	@IBAction func save(sender: UIButton) {
	
		preferences.setObject(hostname.text, forKey: "HOSTNAME")
		preferences.setObject(username.text, forKey: "USERID")
		
		if (password.text?.characters.count > 0) {
			preferences.setObject(password.text, forKey: "PASSWORD")
		}
		
		preferences.synchronize()
		
		let loadingViewController = LoadingViewController()
		self.presentViewController(loadingViewController, animated: true, completion: nil)
	
	}
	
}
