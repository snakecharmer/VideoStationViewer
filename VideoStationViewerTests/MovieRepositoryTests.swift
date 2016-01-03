import XCTest
import CoreData

class MovieRepositoryTests: XCTestCase {
	
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
    

	func testGetMovieCallsAPIIfOnlyHasSummary() {
		
		let expectation = expectationWithDescription("testGetMovieCallsAPIIfOnlyHasSummary")
		
		// setup a movie that the import service will provide
		var movieDetail = SynologyMediaItem()
		movieDetail.id = 1
		movieDetail.title = "TEST TEST TEST"
		movieDetail.summary = "This is a summary"
		movieDetail.fileId = 99
		self.movieImportService?.movie = movieDetail
		
		// Setup a movie in the moc that is only partly populated.
		let entity =  NSEntityDescription.entityForName("Movie", inManagedObjectContext: coreDataHelper.managedObjectContext!)
		let dbMovie = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataHelper.managedObjectContext!) as! Movie
		dbMovie.id = 1
		dbMovie.title = "TEST TEST TEST"
		dbMovie.summary = "This is a summary"
		dbMovie.containsDetail = false
	
		movieRepository.getMovie(1) { (movie, error) -> Void in
			if let movieValue = movie {
				XCTAssert(movieValue.id?.integerValue == 1)
				XCTAssert(movieValue.title! == "TEST TEST TEST")
				XCTAssert(movieValue.summary! == "This is a summary")
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
	
	func testGeMovieDoesntCallAPIIfHasDetail() {
		
		let expectation = expectationWithDescription("Get Movie From DB")

		// setup a movie that the import service will provide
		var movieDetail = SynologyMediaItem()
		movieDetail.id = 1
		movieDetail.title = "TEST TEST TEST"
		movieDetail.summary = "This is a summary"
		movieDetail.fileId = 55
		self.movieImportService?.movie = movieDetail
		
		
		let entity =  NSEntityDescription.entityForName("Movie", inManagedObjectContext: coreDataHelper.managedObjectContext!)
		let dbMovie = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataHelper.managedObjectContext!) as! Movie
		
		dbMovie.id = 88
		dbMovie.title = "TEST FROM DB"
		dbMovie.summary = "Test Summary"
		dbMovie.fileId = 99
		dbMovie.containsDetail = true
		
		movieRepository.getMovie(88) { (movie, error) -> Void in
			if let movieValue = movie {
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
    
    func testGetMovieGenresOnlyReturnsGenresWithMovies() {
        self.setupModel()
        
        let genres = self.movieRepository.getMovieGenres()
        for genre in genres {
            
            for mediaItem in genre.media!  {
                let mediaMo = mediaItem as! NSManagedObject
                if let typeName = mediaMo.entity.name {
                    XCTAssertEqual("Movie", typeName)
                }
            }
            
        }
        
        
    }
    
    func testGetMovieGenresOnlyContainMovies() {
        
    }
    
    
    
    func setupModel() {
        // Create a genre, a movie and a tv show with an episode.
        let genreEntity =  NSEntityDescription.entityForName("Genre", inManagedObjectContext: self.coreDataHelper.managedObjectContext!)
        let movieEntity =  NSEntityDescription.entityForName("Movie", inManagedObjectContext: self.coreDataHelper.managedObjectContext!)
        let showEntity =  NSEntityDescription.entityForName("Show", inManagedObjectContext: self.coreDataHelper.managedObjectContext!)
        let episodeEntity =  NSEntityDescription.entityForName("Episode", inManagedObjectContext: self.coreDataHelper.managedObjectContext!)
        
        let genre = NSManagedObject(entity: genreEntity!, insertIntoManagedObjectContext: self.coreDataHelper.managedObjectContext!) as! Genre
        genre.genre = "Comedy"
        
        let movie = NSManagedObject(entity: movieEntity!, insertIntoManagedObjectContext: self.coreDataHelper.managedObjectContext!) as! Movie
        movie.id = 1
        movie.title = "Movie Title"
        movie.summary = "Movie Summary"
        
        
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
        movie.genres = NSSet(array: [genre])
        episode.genres = NSSet(array: [genre])
        
        genre.media = NSSet(array: [movie,episode])
        
    }
    
}
