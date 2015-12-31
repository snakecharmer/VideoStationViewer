import XCTest

class ImageAPITests: XCTestCase {
	
	
	var imageAPI = ImageAPI()
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
		// Clear cache()
		
	}
	
	func testRequestingANewImageCallsTheAPI() {
		
	}

	func testRequestingAnImageRecentlyCachedInMemoryReturnsInMemoryResult() {
		
	}
	
	func testRequestingAnImageInDiskCacheReturnsDiskCacheCopy() {
		
	}
	
	func testRequestingANewImageNotCachedStoresImageOnDisk() {
		
	}
	
	func testRequestingANewImageNotCachedStoresImageInMemory() {
		
	}

/*	func testPoster() {
        create mock image response and test it's params (like movie api)
	}
*/
}