import XCTest
import OHHTTPStubs

class SessionTests: XCTestCase {

    var session = SessionAPI()


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
    
    func testLoginReturnsSession() {

        let expectation = expectationWithDescription("GET login")
        
        OHHTTPStubs.stubRequestsPassingTest({ (request: NSURLRequest) -> Bool in
            
            let url = request.URL!
            if let pathComponents = url.pathComponents {
                if pathComponents.contains("auth.cgi") {
                    return true
                }
            }
            
            return false
            
        }, withStubResponse: { (request: NSURLRequest) -> OHHTTPStubsResponse in
            
            let obj = [
                "data": [
                    "sid": "1234"
                ]
            ]
            
            return OHHTTPStubsResponse(JSONObject: obj, statusCode:200, headers:nil)
        })
        
        session.login { (session, error) -> Void in
            if let sessionValue = session {
                XCTAssert(sessionValue == "1234")
            } else {
                XCTFail()
            }
            
            expectation.fulfill()

        }


        waitForExpectationsWithTimeout(500, handler: {
            error in XCTAssertNil(error, "Oh, we got timeout")
        })
    }

    
    // test bad login
    
    
}