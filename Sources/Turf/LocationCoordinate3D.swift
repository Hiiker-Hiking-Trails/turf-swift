//
//  LocationCoordinate3D.swift
//  Turf
//
//  Created by Paul Finlay on 29/01/2022.
//

import Foundation
#if canImport(CoreLocation)
import CoreLocation
#endif

#if canImport(CoreLocation)

/**
 A geographic coordinate with its components measured in degrees.
 */
public struct LocationCoordinate3D {
    /**
     The latitude in degrees.
     */
    public var latitude: LocationDegrees
    
    /**
     The longitude in degrees.
     */
    public var longitude: LocationDegrees
    
    /**
     The altitude in double.
     */
    public var altitude: Double
    
    /**
     Creates a degree-based geographic coordinate.
     */
    public init(latitude: LocationDegrees, longitude: LocationDegrees, altitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
}
#endif

extension LocationCoordinate3D {
    /**
        Returns a normalized coordinate, wrapped to -180 and 180 degrees latitude
     */
    var normalized: LocationCoordinate3D {
        return .init(
            latitude: latitude,
            longitude: longitude.wrap(min: -180, max: 180),
            altitude: altitude
        )
    }
}

struct LocationCoordinate3DCodable: Codable {
    var latitude: LocationDegrees
    var longitude: LocationDegrees
    var altitude: Double
    var decodedCoordinates: LocationCoordinate3D {
        return LocationCoordinate3D(latitude: latitude, longitude: longitude, altitude: altitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        longitude = try container.decode(LocationDegrees.self)
        latitude = try container.decode(LocationDegrees.self)
        altitude = try container.decode(Double.self)
    }
    
    init(_ coordinate: LocationCoordinate3D) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        altitude = coordinate.altitude
    }
}

extension LocationCoordinate3D {
    var codableCoordinates: LocationCoordinate3DCodable {
        return LocationCoordinate3DCodable(self)
    }
}

extension Array where Element == LocationCoordinate3DCodable {
    var decodedCoordinates: [LocationCoordinate3D] {
        return map { $0.decodedCoordinates }
    }
}

extension Array where Element == [LocationCoordinate3DCodable] {
    var decodedCoordinates: [[LocationCoordinate3D]] {
        return map { $0.decodedCoordinates }
    }
}

extension Array where Element == [[LocationCoordinate3DCodable]] {
    var decodedCoordinates: [[[LocationCoordinate3D]]] {
        return map { $0.decodedCoordinates }
    }
}

extension Array where Element == LocationCoordinate3D {
    var codableCoordinates: [LocationCoordinate3DCodable] {
        return map { $0.codableCoordinates }
    }
}

extension Array where Element == [LocationCoordinate3D] {
    var codableCoordinates: [[LocationCoordinate3DCodable]] {
        return map { $0.codableCoordinates }
    }
}

extension Array where Element == [[LocationCoordinate3D]] {
    var codableCoordinates: [[[LocationCoordinate3DCodable]]] {
        return map { $0.codableCoordinates }
    }
}

extension LocationCoordinate3D: Equatable {
    
    /// Instantiates a LocationCoordinate3D from a RadianCoordinate2D
    public init(_ radianCoordinate: RadianCoordinate2D) {
        self.init(latitude: radianCoordinate.latitude.toDegrees(), longitude: radianCoordinate.longitude.toDegrees(), altitude: 0)
    }
    
    public static func ==(lhs: LocationCoordinate3D, rhs: LocationCoordinate3D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    /**
     Returns the direction from the receiver to the given coordinate.
     
     This method is equivalent to the [turf-bearing](https://turfjs.org/docs/#bearing) package of Turf.js ([source code](https://github.com/Turfjs/turf/tree/master/packages/turf-bearing/)).
     */
    public func direction(to coordinate: LocationCoordinate3D) -> LocationDirection {
        return RadianCoordinate2D(self).direction(to: RadianCoordinate2D(coordinate)).converted(to: .degrees).value
    }
    
    /// Returns a coordinate a certain Haversine distance away in the given direction.
    public func coordinate(at distance: LocationDistance, facing direction: LocationDirection) -> LocationCoordinate3D {
        let angle = Measurement(value: direction, unit: UnitAngle.degrees)
        return coordinate(at: distance, facing: angle)
    }

    /**
     Returns a coordinate a certain Haversine distance away in the given direction.
     
     This method is equivalent to the [turf-destination](https://turfjs.org/docs/#destination) package of Turf.js ([source code](https://github.com/Turfjs/turf/tree/master/packages/turf-destination/)).
     */
    public func coordinate(at distance: LocationDistance, facing direction: Measurement<UnitAngle>) -> LocationCoordinate3D {
        let radianCoordinate = RadianCoordinate2D(self).coordinate(at: distance / metersPerRadian, facing: direction)
        return LocationCoordinate3D(radianCoordinate)
    }
    
    /**
     Returns the Haversine distance between two coordinates measured in degrees.
     
     This method is equivalent to the [turf-distance](https://turfjs.org/docs/#distance) package of Turf.js ([source code](https://github.com/Turfjs/turf/tree/master/packages/turf-distance/)).
     */
    public func distance(to coordinate: LocationCoordinate3D) -> LocationDistance {
        return RadianCoordinate2D(self).distance(to: RadianCoordinate2D(coordinate)) * metersPerRadian
    }
}

