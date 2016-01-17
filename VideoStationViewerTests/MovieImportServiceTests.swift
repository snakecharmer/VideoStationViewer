import XCTest
import CoreData

class MovieImportServiceTests: XCTestCase {

	var movieImportService:MovieImportService!
	let coreDataHelper = TestCoreDataHelper()
	
	override func setUp() {
		super.setUp()
		movieImportService = MovieImportService(moc: self.coreDataHelper.managedObjectContext!)
		movieImportService.movieAPI = TestMovieAPI() // mock movie api
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
		coreDataHelper.reset()
	}

	// MARK - Movies
	
    func testImportMoviesImportsAllMovies() {
        
        let expectation = self.expectationWithDescription("Get many movies")
        self.movieImportService.importMovies { (total, error) -> Void in
            
            let fetchRequest = NSFetchRequest(entityName: "Movie")
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            fetchRequest.sortDescriptors = [descriptor]
            
            do {
                
                let results = try self.coreDataHelper.managedObjectContext!.executeFetchRequest(fetchRequest) as![Movie]
                XCTAssertEqual(results.count, 2)
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            XCTAssert(total > 0);
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(500, handler: {
            error in XCTAssertNil(error, "Oh, we got timeout")
        })
        
    }
    
	func testImportMoviesImportsMovieSummarys() {

		let expectation = self.expectationWithDescription("Get many movies")
		self.movieImportService.importMovies { (total, error) -> Void in
			
			let fetchRequest = NSFetchRequest(entityName: "Movie")
            fetchRequest.predicate = NSPredicate(format: "id == %d", 1)
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            fetchRequest.sortDescriptors = [descriptor]
			
			do {
				let results = try self.coreDataHelper.managedObjectContext!.executeFetchRequest(fetchRequest) as![Movie]
				XCTAssertEqual(results.count, 1)
				XCTAssertEqual(results[0].title!, "Test Title 1")
                XCTAssertEqual(results[0].summary!, "Test Summary 1")
				XCTAssertEqual(results[0].id, 1)
				
			} catch let error as NSError {
				print("Could not fetch \(error), \(error.userInfo)")
			}
			
			XCTAssert(total > 0);
			expectation.fulfill()
		}

		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
		
	}
	
	func testImportMoviesImportsGenres() {
		
		let expectation = self.expectationWithDescription("Get many movies")
		
		self.movieImportService.importMovies { (total, error) -> Void in
			
			let fetchRequest = NSFetchRequest(entityName: "Genre")
			
			do {
				let genres = try self.coreDataHelper.managedObjectContext!.executeFetchRequest(fetchRequest) as![Genre]
				XCTAssertEqual(genres.count,3)
			} catch let error as NSError {
				print("Could not fetch \(error), \(error.userInfo)")
			}
			
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
			
	}
	
	func testImportMoviesJoinsMoviesToGenres() {
		
		let expectation = self.expectationWithDescription("Get many movies")
		
		self.movieImportService.importMovies { (total, error) -> Void in
			
			do {
				let fetchRequest = NSFetchRequest(entityName: "Genre")
				fetchRequest.predicate = NSPredicate(format: "genre == %@", "Drama")
				
				let results = try self.coreDataHelper.managedObjectContext!.executeFetchRequest(fetchRequest) as![Genre]
				let movies = results[0].media
                let moviesArray = movies?.allObjects as! [Movie]
				
				XCTAssertEqual(moviesArray.count, 1)
                XCTAssertEqual(moviesArray[0].title, "Test Title 1")
				
			} catch {
				XCTFail()
			}

			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
			
		
	}
	
	func testImportMoviesJoinsGenresToMovies() {
		
		let expectation = self.expectationWithDescription("Get many movies")
		
		self.movieImportService.importMovies { (total, error) -> Void in
			
			do {
				let fetchRequest = NSFetchRequest(entityName: "Movie")
				fetchRequest.predicate = NSPredicate(format: "id == 1")
				
				let results = try self.coreDataHelper.managedObjectContext!.executeFetchRequest(fetchRequest) as![Movie]
				let movieSummary = results[0] as Movie
				
				let descriptor: NSSortDescriptor = NSSortDescriptor(key: "genre", ascending: true)
				let genres = movieSummary.genres?.sortedArrayUsingDescriptors([descriptor]) as! [Genre]
				
				XCTAssertEqual(genres.count, 2)
				let genre = genres[0].genre!
				XCTAssertEqual(genre, "Comedy")
				
			} catch {
				XCTFail()
			}
			
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
		
	}

	func testImportMovieImportsMovieDetails() {
		
		let expectation = expectationWithDescription("Get Movie From API")
		
		// Create a fake movie api and populate it with a fake movie.
		
		let movieApi = TestMovieAPI()
		movieImportService.movieAPI = movieApi
		
		// simulate item from API call that lists geres
		var testMovie = SynologyMediaItem()
		testMovie.title = "TEST TEST TEST"
		testMovie.id = 1
		testMovie.fileId = 99
		testMovie.genre = ["Comedy"]
		testMovie.summary = "Test Summary"
		movieApi.movie = testMovie
		
		// setup genres in moc
		let genreEntity =  NSEntityDescription.entityForName("Genre", inManagedObjectContext: coreDataHelper.managedObjectContext!)
		let comedyGenre = NSManagedObject(entity: genreEntity!, insertIntoManagedObjectContext: coreDataHelper.managedObjectContext!) as! Genre
		comedyGenre.genre = "Comedy"
		
		
		// Call repository
		movieImportService.importMovieDetails(1) { (movie, error) -> Void in
			
			// Test that is has genre objets with correct values
			if let movieValue = movie {
			
				XCTAssertEqual(movieValue.title, "TEST TEST TEST")
				XCTAssertEqual(movieValue.id, 1)
				XCTAssertEqual(movieValue.fileId, 99)
				XCTAssertEqual(movieValue.summary, "Test Summary")
				XCTAssertEqual(true, movieValue.isContainsDetail)
				expectation.fulfill()
			
			} else {
				XCTFail()
			}

		}

		waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
	}
	
	func testImportMovieJoinsGenresToMovies() {
		
		let expectation = expectationWithDescription("Get Movie From API")
		
		let movieApi = TestMovieAPI()
		movieImportService.movieAPI = movieApi
		
		// simulate item from API call that lists geres
		var testMovie = SynologyMediaItem()
		testMovie.title = "TEST TEST TEST"
		testMovie.id = 1
		testMovie.fileId = 99
		testMovie.genre = ["Comedy"]
		movieApi.movie = testMovie
		
		// setup genres in moc
		let genreEntity =  NSEntityDescription.entityForName("Genre", inManagedObjectContext: coreDataHelper.managedObjectContext!)
		let comedyGenre = NSManagedObject(entity: genreEntity!, insertIntoManagedObjectContext: coreDataHelper.managedObjectContext!) as! Genre
		comedyGenre.genre = "Comedy"
		
		
		
		// Call repository
		movieImportService.importMovieDetails(1) { (movie, error) -> Void in
			
			// Test that is has genre objets with correct values
			if let movieValue = movie {
				
				let genres = movieValue.genres
				if let genreValues = genres {
					XCTAssert(genreValues.count == 1)
					let genre = genreValues.allObjects[0] as! Genre
					XCTAssert(genre.genre == "Comedy")
				} else {
					XCTFail()
				}
				
				expectation.fulfill()
				
			} else {
				XCTFail()
			}
			
		}
		
		waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
	}
	
	func testImportShowsGetsAllShows() {
		let expectation = self.expectationWithDescription("Get shows")
		self.movieImportService.importShows { (total, error) -> Void in
			
			let fetchRequest = NSFetchRequest(entityName: "Show")
			
			do {
				
				let results = try self.coreDataHelper.managedObjectContext!.executeFetchRequest(fetchRequest) as![Show]
				XCTAssertEqual(results.count, 2)
				
			} catch let error as NSError {
				print("Could not fetch \(error), \(error.userInfo)")
			}
			
			XCTAssert(total > 0);
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
	}
	
	func testImportShowsParsesAllShowFields() {
		let expectation = self.expectationWithDescription("Get show fields")
		self.movieImportService.importShows { (total, error) -> Void in
			
			let fetchRequest = NSFetchRequest(entityName: "Show")
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            fetchRequest.sortDescriptors = [descriptor]
			
			do {
				
				let results = try self.coreDataHelper.managedObjectContext!.executeFetchRequest(fetchRequest) as![Show]
				let show = results[0]
				XCTAssertEqual("Test Title 1", show.title)
				XCTAssertEqual("Test Summary 1", show.summary)
				XCTAssertEqual(1, show.id)
				
			} catch let error as NSError {
				print("Could not fetch \(error), \(error.userInfo)")
			}
			
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
	}

	func testImportShowLinksToEpisodeAndBack() {
		let expectation = self.expectationWithDescription("Get show fields")
		self.movieImportService.importShows { (total, error) -> Void in
			
			let fetchRequest = NSFetchRequest(entityName: "Show")
            let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            fetchRequest.sortDescriptors = [descriptor]
			
			do {
				
				let results = try self.coreDataHelper.managedObjectContext!.executeFetchRequest(fetchRequest) as![Show]
				let show = results[0]
				if let episodes = show.episodes {
					XCTAssertEqual(3, episodes.count)	//show has 3 episodes
					
					let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
					let episodesArray = episodes.sortedArrayUsingDescriptors([descriptor]) as! [Episode]
					let episode = episodesArray[0]
					
					// Episode is linked back to show
					XCTAssertEqual(show, episode.show)
				} else {
					XCTFail()
				}
				
			} catch let error as NSError {
				print("Could not fetch \(error), \(error.userInfo)")
			}
			
			
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
	}
	
	func testImportShowGetsEpisodeDetails() {
		let expectation = self.expectationWithDescription("Get episode fields")
		self.movieImportService.importShows { (total, error) -> Void in
			
			let fetchRequest = NSFetchRequest(entityName: "Show")
			
			do {
				
				let results = try self.coreDataHelper.managedObjectContext!.executeFetchRequest(fetchRequest) as![Show]
				let show = results[0]
				if let episodes = show.episodes {
					let descriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
					let episodesArray = episodes.sortedArrayUsingDescriptors([descriptor]) as! [Episode]
					let episode = episodesArray[0]

					// episode fields populated
					XCTAssertEqual(1, episode.id!)
					XCTAssertEqual("Tagline 1", episode.title!)
					XCTAssertEqual("Test Summary 1", episode.summary!)
                    XCTAssertEqual(1, episode.season)
                    XCTAssertEqual(2, episode.episode)

				} else {
					XCTFail()
				}
				
			} catch let error as NSError {
				print("Could not fetch \(error), \(error.userInfo)")
			}
			

			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
	}
	

	
	// Test that importing a show marks the episisode as partly populated.
	
	// Test that when you get a episode the episode in the show is updated to the full version

	


}
