import XCTest
import CoreData

class MovieRepositoryTests: XCTestCase {
	
	//var movieImportService:MovieImportService!
	let coreDataHelper = TestCoreDataHelper()
	let movieRepository = MovieRepository.sharedInstance
	var movieImportService:TestMovieImportService?
	
    override func setUp() {
		super.setUp()
		self.movieImportService = TestMovieImportService(moc: coreDataHelper.managedObjectContext!)
        self.movieImportService?.movieAPI = TestMovieApi()
		
		movieRepository.moc = coreDataHelper.managedObjectContext
		movieRepository.movieImportService = movieImportService

    }
    
    override func tearDown() {
		super.tearDown()
		coreDataHelper.reset()
    }
    

	func testGetMovieCallsApiIfNotInDB() {
	
		let expectation = expectationWithDescription("Get Movie From API")
		
		var testMovie = SynologyMediaItem()
		testMovie.title = "TEST TEST TEST"
		testMovie.id = 1
		testMovie.fileId = 99
		self.movieImportService?.movie = testMovie
		
		movieRepository.getMovie(1) { (movie, error) -> Void in
			if let movieValue = movie {
				XCTAssert(movieValue.title == "TEST TEST TEST")
				XCTAssert(movieValue.id?.integerValue == 1)
				XCTAssert(movieValue.fileId?.integerValue == 99)
			} else {
				XCTFail()
			}
			expectation.fulfill()
		}
		
		waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
		
	}
	
	func testGetMovieReturnsLocalCopyIfInDB() {
		
		let expectation = expectationWithDescription("Get Movie From DB")

		
		let entity =  NSEntityDescription.entityForName("MovieDetail", inManagedObjectContext: coreDataHelper.managedObjectContext!)
		let movieDetail = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataHelper.managedObjectContext!) as! MovieDetail
		
		movieDetail.id = 88
		movieDetail.title = "TEST FROM DB"
		movieDetail.summary = "Test Summary"
		
		movieRepository.getMovie(88) { (movie, error) -> Void in
			if let movieValue = movie {
				XCTAssert(movieValue.title == "TEST FROM DB")
				XCTAssert(movieValue.id?.integerValue == 88)
			} else {
				XCTFail()
			}
			expectation.fulfill()
		}
		
		waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
		
		
	}
    
}
