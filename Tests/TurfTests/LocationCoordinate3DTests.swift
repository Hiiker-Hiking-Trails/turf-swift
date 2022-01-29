import XCTest
#if !os(Linux)
import CoreLocation
#endif
import Turf

class LocationCoordinate3DTests: XCTestCase {
        
    func testCreateCoordinate() {
        let data2 = try! Fixture.geojsonData(from: "featurecollection-3d")
        let geojson = try! JSONDecoder().decode(GeoJSONObject.self, from: data)
        guard case let .featureCollection(featureCollection) = geojson else { return XCTFail() }
        let feature = featureCollection.features.first
        
        guard case let .lineString(lineString) = lineStringFeature.geometry else {
            XCTFail()
            return
        }
    }
}

