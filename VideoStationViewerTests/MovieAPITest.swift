import XCTest
import OHHTTPStubs

class MovieAPITest: XCTestCase {

	var movieAPI = MovieAPI()
	
    override func setUp() {
        super.setUp()
        let preferences: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        preferences.setObject("test.com", forKey: "HOSTNAME")
        preferences.setObject("user", forKey: "USERID")
        preferences.setObject("password", forKey: "PASSWORD")
        preferences.synchronize()
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
	

	func testGetMovieSummariesCallsCorrectUrl() {
		
		let expectation = self.expectationWithDescription("testGetMovieSummariesCallsCorrectUrl")
		
        OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
            
            let url = request.URL!
            XCTAssertEqual(url.path!, "/webapi/VideoStation/movie.cgi")
            XCTAssertEqual(url.host!, "test.com")
            XCTAssertEqual(url.port!, 5000)
            return true
            
            }, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(fileAtPath:OHPathForFile("movietitles.json", self.dynamicType)!,
                    statusCode:200, headers:["Content-Type":"application/json"])
        })
        
		self.movieAPI.getMovieTitles { (movies, total, offset,error) -> Void in
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
		
	}
    
    func testGetMovieSummariesAsksForLimitedFileds() {
        
        let expectation = self.expectationWithDescription("testGetMovieSummariesAsksForLimitedFileds")
        
        OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
            
            let url = request.URL!
            
            if let query = url.query {
                XCTAssert(query.containsString("api=SYNO.VideoStation.Movie"))
                XCTAssert(query.containsString("version=2"))
                XCTAssert(query.containsString("method=list"))
                XCTAssert(query.containsString("offset=0"))
                XCTAssert(query.containsString("limit=99999"))
                XCTAssert(query.containsString("sort_by=added"))
                XCTAssert(query.containsString("sort_direction=desc"))
                XCTAssert(query.containsString("additional=%5B%22genre%22%2C%22summary%22%5D"))
                XCTAssert(query.containsString("library_id=0"))
                
            } else {
                XCTFail()
            }
			
            return true
            
            }, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(fileAtPath:OHPathForFile("movietitles.json", self.dynamicType)!,
                    statusCode:200, headers:["Content-Type":"application/json"])
        })
        
        self.movieAPI.getMovieTitles { (movies, total, offset,error) -> Void in
			expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(500, handler: {
            error in XCTAssertNil(error, "Oh, we got timeout")
        })
        
    }
	
    func testGetMovieSummariesParsesMovies() {
        
        let expectation = self.expectationWithDescription("testGetMovieSummariesParsesMovies")
        
        OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
            
            let url = request.URL!
           
            if url.path! == "/webapi/VideoStation/movie.cgi" {
                return true
            }
            
            return false;
            
        }, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(fileAtPath:OHPathForFile("movietitles.json", self.dynamicType)!,
                statusCode:200, headers:["Content-Type":"application/json"])
        })
        
        self.movieAPI.getMovieTitles { (movies, total, offset,error) -> Void in
            XCTAssertNotNil(movies)
            XCTAssertTrue(movies!.count > 0)
            
            let movie = movies![0]
            
            XCTAssert(movie.title == "Get Santa")
            XCTAssertEqual(1099, movie.id)
            XCTAssert(movie.genre.contains("Comedy"))
            XCTAssert(movie.genre.contains("Family"))
			
			// todo check it indicates its a movie
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(500, handler: {
            error in XCTAssertNil(error, "Oh, we got timeout")
        })
    }
    
    func testGetMovieCallsCorrectUrl() {
        let expectation = self.expectationWithDescription("testGetMovieCallsCorrectUrl")
		
		
		NSLog(" **********************************")
		
        OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
            
            let url = request.URL!
            XCTAssertEqual(url.path!, "/webapi/VideoStation/movie.cgi")
            XCTAssertEqual(url.host!, "test.com")
            XCTAssertEqual(url.port!, 5000)
            return true
            
            }, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(fileAtPath:OHPathForFile("movietitles.json", self.dynamicType)!,
                    statusCode:200, headers:["Content-Type":"application/json"])
        })
        
        
        self.movieAPI.getMovie(100) { (movie, error) -> Void in
			NSLog(" ---------------------------------------")
			expectation.fulfill()
        }
		
        self.waitForExpectationsWithTimeout(500, handler: {
            error in XCTAssertNil(error, "Oh, we got timeout")
        })
    }
    
    func testGetMovieAsksForAllFields() {
        let expectation = self.expectationWithDescription("testGetMovieAsksForAllFields")
        
        OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
            
            let url = request.URL!
            
            if let query = url.query {
                XCTAssert(query.containsString("api=SYNO.VideoStation.Movie"))
                XCTAssert(query.containsString("version=2"))
                XCTAssert(query.containsString("method=getinfo"))
                XCTAssert(query.containsString("additional=%5B%22poster_mtime%22%2C%22summary%22%2C%22watched_ratio%22%2C%22collection%22%2C%22file%22%2C%22actor%22%2C%22write%22%2C%22director%22%2C%22genre%22%2C%22extra%22%5D"))
                
            } else {
                XCTFail()
            }

            return true
            
        }, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(fileAtPath:OHPathForFile("movietitles.json", self.dynamicType)!,
                    statusCode:200, headers:["Content-Type":"application/json"])
        })
        
        self.movieAPI.getMovie(100) { (movie, error) -> Void in
			expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(500, handler: {
            error in XCTAssertNil(error, "Oh, we got timeout")
        })

    }

	func testGetMovieParsesResult() {
        let expectation = self.expectationWithDescription("testGetMovieParsesResult")
        
        OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
            
            let url = request.URL!
            
            if url.path! == "/webapi/VideoStation/movie.cgi" {
                return true
            }
            
            return false;
            
            }, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
                return OHHTTPStubsResponse(fileAtPath:OHPathForFile("movie.json", self.dynamicType)!,
                    statusCode:200, headers:["Content-Type":"application/json"])
        })
        
        
        self.movieAPI.getMovie(86) { (movie, error) -> Void in
            if let movieValue = movie {
                XCTAssertEqual("12 Years a Slave", movieValue.title!)
                XCTAssert(movieValue.summary.characters.count > 0)
                XCTAssertEqual(86, movieValue.id)
                XCTAssertEqual("The extraordinary true story of Solomon Northup", movieValue.tagline)
                XCTAssertEqual(42, movieValue.fileId)
                XCTAssert(movieValue.genre.contains("Biography"))
                XCTAssert(movieValue.genre.contains("Drama"))
                XCTAssert(movieValue.genre.contains("History"))
            } else {
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(500, handler: {
            error in XCTAssertNil(error, "Oh, we got timeout")
        })
	}
	
	/*
	func testGetTVSummariesCallsCorrectUrl() {
		
		let expectation = self.expectationWithDescription("testGetTVSummariesCallsCorrectUrl")
		
		OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
			
			let url = request.URL!
			XCTAssertEqual(url.path!, "/webapi/VideoStation/tvshow.cgi")
			XCTAssertEqual(url.host!, "test.com")
			XCTAssertEqual(url.port!, 5000)
			return true
			
			}, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
				return OHHTTPStubsResponse(fileAtPath:OHPathForFile("tvshows.json", self.dynamicType)!,
					statusCode:200, headers:["Content-Type":"application/json"])
		})
		
		self.movieAPI.getTVTitles { (shows, total, offset,error) -> Void in
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
		
	}
	
	func testGetTVSummariesAsksForLimitedFileds() {
		
		let expectation = self.expectationWithDescription("testGetMovieSummariesAsksForLimitedFileds")
		
		OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
			
			let url = request.URL!
			
			if let query = url.query {
				XCTAssert(query.containsString("api=SYNO.VideoStation.TVShow"))
				XCTAssert(query.containsString("version=2"))
				XCTAssert(query.containsString("method=list"))
				XCTAssert(query.containsString("offset=0"))
				XCTAssert(query.containsString("limit=99999"))
				XCTAssert(query.containsString("sort_by=added"))
				XCTAssert(query.containsString("sort_direction=desc"))
				XCTAssert(query.containsString("additional=%5B%22summary%22%5D"))
				XCTAssert(query.containsString("library_id=0"))
				
			} else {
				XCTFail()
			}
			
			return true
			
			}, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
				return OHHTTPStubsResponse(fileAtPath:OHPathForFile("movietitles.json", self.dynamicType)!,
					statusCode:200, headers:["Content-Type":"application/json"])
		})
		
		self.movieAPI.getTVTitles { (shows, total, offset,error) -> Void in
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
		
	}
	
	func testGetTVSummariesParsesTVShow() {
		
		let expectation = self.expectationWithDescription("testGetMovieSummariesParsesMovies")
		
		OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
			
			let url = request.URL!
			
			if url.path! == "/webapi/VideoStation/tvshow.cgi" {
				return true
			}
			
			return false;
			
			}, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
				return OHHTTPStubsResponse(fileAtPath:OHPathForFile("movietitles.json", self.dynamicType)!,
					statusCode:200, headers:["Content-Type":"application/json"])
		})
		
		self.movieAPI.getTVTitles { (shows, total, offset,error) -> Void in
			XCTAssertNotNil(shows)
			XCTAssertTrue(shows!.count > 0)
			
			let show = shows![0]
			
			XCTAssert(show.title == "Get Santa")
			XCTAssertEqual(1099, show.id)
			XCTAssert(show.genre.contains("Comedy"))
			XCTAssert(show.genre.contains("Family"))
			
			// todo check it indicates its a movie
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
	}
	
	func testGetShowCallsCorrectUrl() {
		let expectation = self.expectationWithDescription("testGetMovieCallsCorrectUrl")
		
		OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
			
			let url = request.URL!
			XCTAssertEqual(url.path!, "/webapi/VideoStation/tvshow.cgi")
			XCTAssertEqual(url.host!, "test.com")
			XCTAssertEqual(url.port!, 5000)
			return true
			
			}, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
				return OHHTTPStubsResponse(fileAtPath:OHPathForFile("show.json", self.dynamicType)!,
					statusCode:200, headers:["Content-Type":"application/json"])
		})
		
		
		self.movieAPI.getTVShow(100) { (tvShow, error) -> Void in
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
	}
	
	func testGetShowAsksForAllFields() {
		let expectation = self.expectationWithDescription("testGetShowAsksForAllFields")
		
		OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
			
			let url = request.URL!
			
			if let query = url.query {
				XCTAssert(query.containsString("api=SYNO.VideoStation.TVShow"))
				XCTAssert(query.containsString("version=2"))
				XCTAssert(query.containsString("method=getinfo"))
				XCTAssert(query.containsString("additional=%5B%22poster_mtime%22%2C%22summary%22%2C%22watched_ratio%22%2C%22collection%22%2C%22file%22%2C%22actor%22%2C%22write%22%2C%22director%22%2C%22genre%22%2C%22extra%22%5D"))
				
			} else {
				XCTFail()
			}
			
			return true
			
			}, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
				return OHHTTPStubsResponse(fileAtPath:OHPathForFile("show.json", self.dynamicType)!,
					statusCode:200, headers:["Content-Type":"application/json"])
		})
		

		self.movieAPI.getTVShow(100) { (tvShow, error) -> Void in
			expectation.fulfill()
		}
		
		self.waitForExpectationsWithTimeout(500, handler: {
			error in XCTAssertNil(error, "Oh, we got timeout")
		})
		
	}
	*/
	}
