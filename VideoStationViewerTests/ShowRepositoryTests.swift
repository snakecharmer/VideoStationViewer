import XCTest
import CoreData

class ShowRepositoryTests: XCTestCase {
    
    let coreDataHelper = TestCoreDataHelper()
    var showRepository:ShowRepository?
    
    override func setUp() {
        super.setUp()
        self.showRepository = ShowRepository(moc: self.coreDataHelper.managedObjectContext!)
        self.showRepository?.movieImportService = TestMovieImportService(moc: self.coreDataHelper.managedObjectContext!)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataHelper.reset()
    }
    
    
    func setupModel() {
        // Create a genre, a movie and a tv show with an episode.
        let genreEntity =  NSEntityDescription.entityForName("Genre", inManagedObjectContext: self.coreDataHelper.managedObjectContext!)
        let showEntity =  NSEntityDescription.entityForName("Show", inManagedObjectContext: self.coreDataHelper.managedObjectContext!)
        let episodeEntity =  NSEntityDescription.entityForName("Episode", inManagedObjectContext: self.coreDataHelper.managedObjectContext!)
        
        let genre = NSManagedObject(entity: genreEntity!, insertIntoManagedObjectContext: self.coreDataHelper.managedObjectContext!) as! Genre
        genre.genre = "Comedy"
        
        let show = NSManagedObject(entity: showEntity!, insertIntoManagedObjectContext: self.coreDataHelper.managedObjectContext!) as! Show
        show.id = 2
        show.title = "Show Title"
        show.summary = "Show Summary"
        
        
        let episode = NSManagedObject(entity: episodeEntity!, insertIntoManagedObjectContext: self.coreDataHelper.managedObjectContext!) as! Episode
        episode.id = 3
        episode.title = "Episode Title"
        episode.summary = "Episode Summary"
        
        
        // Link the episode to the show and vice versa
        episode.show = show
        show.episodes = NSSet(array: [episode])
        
        // Link the episode to the genre, and vice versa
        // Link the movie to the genre, and vice versa
        episode.genres = NSSet(array: [genre])
        genre.media = NSSet(array: [episode])
        
    }
    
    func testGetShowGetsAShowFromTheDB() {
        
        let expectation = expectationWithDescription("Get show")
        
        self.setupModel()
        
        showRepository?.getShow(2, success: { (show, error) -> Void in
            if let showValue = show {
                XCTAssertEqual(2, showValue.id)
                XCTAssertEqual("Show Title", showValue.title)
                XCTAssertEqual("Show Summary", showValue.summary)
            } else {
                XCTFail()
            }
            
            expectation.fulfill()

        })
        
        waitForExpectationsWithTimeout(500, handler: {
            error in XCTAssertNil(error, "Oh, we got timeout")
        })
        
    }
    
    
}
