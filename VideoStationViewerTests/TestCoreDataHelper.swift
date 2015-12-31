import Foundation
import CoreData

class TestCoreDataHelper {
	
	let modelName = "Model"
	
	lazy var managedObjectModel: NSManagedObjectModel = {
		
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
		let originalModel = NSManagedObjectModel(contentsOfURL: modelURL)
		
		let testManagedObjectModel = originalModel?.copy() as! NSManagedObjectModel
		
		
		for entity in testManagedObjectModel.entities as [NSEntityDescription] {
			entity.managedObjectClassName = "VideoStationViewerTests." + entity.name!
		}
		
		return testManagedObjectModel
		
	}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		// The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		// Create the coordinator and store
		var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		
		var error: NSError? = nil
		var failureReason = "There was an error creating or loading the application's saved data."
		do {
			try coordinator!.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil);
		} catch {
			// Report any error we got.
			NSLog("Unresolved error \(error), \(error)")
			abort()
		}
		
		return coordinator
	}()
	
	lazy var managedObjectContext: NSManagedObjectContext? = {
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		let coordinator = self.persistentStoreCoordinator
		if coordinator == nil {
			return nil
		}
		var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
	}()
	
	
	func saveContext () {
		if managedObjectContext!.hasChanges {
			do {
				try managedObjectContext!.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
				abort()
			}
		}
	}
	
	func reset() {
		self.managedObjectContext?.reset()
	}
	
	
}