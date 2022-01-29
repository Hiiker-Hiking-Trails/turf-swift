import XCTest
#if !os(Linux)
import CoreLocation
#endif
import Turf

class LocationCoordinate3DTests: XCTestCase {
        
    func testCreateCoordinate() {
        let data = try! Fixture.geojsonData(from: "featurecollection-3d")!
        let abc3d = LocationCoordinate3DCodable.init(from: coords)
        
    }
}

