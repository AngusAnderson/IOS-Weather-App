import Testing
@testable import IOS_Weather_App

struct WindDirectionTests {
    @Test("Cardinal directions are mapped correctly")
    func cardinalDirectionsMapCorrectly() {
        #expect(WindDirection.from(degrees: 0) == "N")
        #expect(WindDirection.from(degrees: 90) == "E")
        #expect(WindDirection.from(degrees: 180) == "S")
        #expect(WindDirection.from(degrees: 270) == "W")
    }

    @Test("Intercardinal directions are mapped correctly")
    func intercardinalDirectionsMapCorrectly() {
        #expect(WindDirection.from(degrees: 45) == "NE")
        #expect(WindDirection.from(degrees: 135) == "SE")
        #expect(WindDirection.from(degrees: 225) == "SW")
        #expect(WindDirection.from(degrees: 315) == "NW")
    }

    @Test("Values wrap around correctly")
    func directionsWrapAroundCorrectly() {
        #expect(WindDirection.from(degrees: 359) == "N")
        #expect(WindDirection.from(degrees: 360) == "N")
        #expect(WindDirection.from(degrees: -1) == "N")
        #expect(WindDirection.from(degrees: -90) == "W")
    }

    @Test("Boundary values choose the nearest direction")
    func boundariesMapToExpectedDirections() {
        #expect(WindDirection.from(degrees: 22) == "N")
        #expect(WindDirection.from(degrees: 23) == "NE")
        #expect(WindDirection.from(degrees: 67) == "NE")
        #expect(WindDirection.from(degrees: 68) == "E")
    }
}