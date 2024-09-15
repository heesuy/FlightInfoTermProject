//
//  FlightBookingData.swift
//  FlightInfoWithAi
//
//  Created by ㅇㅇ ㅇ on 5/23/24.
//

import Foundation



import Foundation

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}

struct flightForFIrebase: Codable, Hashable, DatabaseRepresentation {
    
    func getCurrentDateTime()->String{
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy년 MM월 dd일" //데이터 포멧 설정
        let str = formatter.string(from: Date()) //문자열로 바꾸기
    return str
    }
    
    
    
    
    let tag: String?
    let price: String
    let segment: [[AirportDetails]]
    let destination : String!
    let oneWay : String
    

    var representation: [String: Any] {
        var segmentsDict: [String: Any] = [:]
        
     
        for (index, segment) in segment.enumerated() {
            segmentsDict["segment\(index)"] = segment.map { $0.representation }
        }
        return [
            "price": price,
            "segments": segmentsDict,
            "tag" : tag ??  getCurrentDateTime(),
            "destination" : destination,
            "oneWay" : oneWay
            //"id" : LoginUser.getLoginUser().id as! String
        ]
    }

    static func fromDict(_ dict: [String: Any]) -> flightForFIrebase {
        let segmentsDict = dict["segments"] as! [String: [[String: Any]]]
        var segments: [[AirportDetails]] = []
        for index in 0..<segmentsDict.count {
            if let segmentData = segmentsDict["segment\(index)"] {
                segments.append(segmentData.map { AirportDetails.fromDict($0) })
            }
        }
        return flightForFIrebase(
            tag : dict["tag"] as! String, price: dict["price"] as! String,
            segment: segments, destination: dict["destination"] as! String, oneWay: dict["oneWay"] as! String
        )
    }

    func toSegment() -> [FlightBookingData.Itinerary] {
        var itineraries: [FlightBookingData.Itinerary] = []
        var segments: [FlightBookingData.Segment] = []

        //var criterion : [Int] = []
        var criterion = 0
 
            
            for i in 0..<segment.count{
                //var j = 0
                print(segment)
                let departure = FlightBookingData.Departure(segment[i][0].iataCode, segment[i][0].at)
                let arrival = FlightBookingData.Arrival(segment[i][1].iataCode, segment[i][1].at)
                segments.append(FlightBookingData.Segment(departure, arrival))
                if arrival.iataCode == self.destination{
                    itineraries.append(FlightBookingData.Itinerary(duration: "", segments: segments))
                    if(self.oneWay == "true"){ return itineraries}
                    segments = []
                    criterion += 1
                }
            }
   
        itineraries.append(FlightBookingData.Itinerary(duration: "", segments: segments))
            return itineraries
        }
}

struct AirportDetails: Codable, Hashable, DatabaseRepresentation {
    let iataCode: String
    let terminal: String?
    let at: Date

    init(iataCode: String, terminal: String? = "1", at: Date) {
        self.iataCode = iataCode
        self.terminal = terminal
        self.at = at
    }

    var representation: [String: Any] {
        return [
            "iataCode": iataCode,
            "terminal": terminal ?? NSNull(),
            "at": at.ISO8601Format()
        ]
    }

    static func fromDict(_ dict: [String: Any]) -> AirportDetails {
        return AirportDetails(
            iataCode: dict["iataCode"] as! String,
            terminal: dict["terminal"] as? String,
            at: ISO8601DateFormatter().date(from: dict["at"] as! String)!
        )
    }
}

extension Date {
    func ISO8601Format() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}




struct ErrorBody: Decodable {
let errors: [ErrorDetail]
   
}
struct ErrorDetail: Decodable {
let status: Int
let code: String
let title: String
let detail: String?
}

struct GetFlightOffersBody: Codable {
 
    var travelers :Int
    var originDestinations: [OriginDestination]
    
}

struct OriginDestination: Codable {
    var id: String?
    var originLocationCode: String
    var destinationLocationCode: String
    var departureDateTimeRange: DateTimeRange
    var returnDateTimeRange: DateTimeRange?
}

struct DateTimeRange: Codable {
    var date: String
}

class FlightBookingData : Codable {
    var getFlightOffersBody: GetFlightOffersBody?
    var flights : [FlightDetails]? // API가 보내준 정보에서 항공편의 수
    init() {
        
        self.getFlightOffersBody = nil
        self.flights = nil
    }
    init(getFlightOffersBody: GetFlightOffersBody, flights: [FlightDetails]){
        self.getFlightOffersBody = getFlightOffersBody
        self.flights = flights
        
    }
    
    
    // MARK: - FlightOfferResponse
    struct FlightOffersResponse: Codable {
        let meta: Meta
        let data: [FlightDetails]
        let dictionaries : Dictionaries?
    }
 
    // MARK: - Meta
    struct Meta: Codable {
        let count: Int?
        let links: MetaLinks?
    }
    
    // MARK: - MetaLinks
    struct MetaLinks: Codable {
        let selfLink: String?
        
        enum CodingKeys: String, CodingKey {
            case selfLink = "self"
        }
    }
    
    // MARK: - FlightDetails
    
    struct FlightDetails: Codable {
        let type: String?
        let id: String?
        let source: String?
        let instantTicketingRequired: Bool?
        let nonHomogeneous: Bool?
        let oneWay: Bool?
        let lastTicketingDate: String?
        let lastTicketingDateTime: String?
        let numberOfBookableSeats: Int?
        let itineraries: [Itinerary]
        let price: Price?
        let pricingOptions: PricingOptions?
        let validatingAirlineCodes: [String]?
        let travelerPricings: [TravelerPricing]?

        init(_ itineraries: [Itinerary],_ price:Price) {
            self.type = nil
            self.id = nil
            self.source = nil
            self.instantTicketingRequired = nil
            self.nonHomogeneous = nil
            self.oneWay = nil
            self.lastTicketingDate = nil
            self.lastTicketingDateTime = nil
            self.numberOfBookableSeats = nil
            self.itineraries = itineraries
            self.price = price
            self.pricingOptions = nil
            self.validatingAirlineCodes = nil
            self.travelerPricings = nil
        }
    }

    
    // MARK: - Itinerary
    struct Itinerary: Codable {
        let duration: String
        let segments: [Segment]
    }
    
    // MARK: - Segment
    struct Segment: Codable {
        let departure: Departure?
        let arrival: Arrival?
        let carrierCode: String?
        let number: String?
        let aircraft: Aircraft?
        let operating: Operating?
        let duration: String?
        let id: String?
        let numberOfStops: Int?
        let blacklistedInEU: Bool?
        init(_ departure : Departure, _ arriaval : Arrival){
            self.departure = departure
            self.arrival = arriaval
            self.carrierCode = nil
            self.number = nil
            self.aircraft = nil
            self.operating = nil
            self.duration = nil
            self.id = nil
            self.numberOfStops = nil
            self.blacklistedInEU = nil
            
        }
    }
    
    // MARK: - Aircraft
    struct Aircraft: Codable {
        let code: String?
    }
    
    // MARK: - Arrival
    struct Arrival: Codable {
        let iataCode: String?
        let at: Date?
        
        enum CodingKeys: String, CodingKey {
            case iataCode
            case at
        }
        init(_ iata : String, _ at : Date){
            self.iataCode = iata
            self.at = at
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            iataCode = try container.decode(String.self, forKey: .iataCode)
            let dateString = try container.decode(String.self, forKey: .at)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            guard let date = formatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(forKey: .at, in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
            at = date
        }
    }
    
    // MARK: - Departure
    struct Departure: Codable {
        let iataCode: String
        let terminal: String?
        let at: Date?
        init(_ iata : String, _ at : Date){
            self.iataCode = iata
            self.at = at
            self.terminal = nil
        }
        
        enum CodingKeys: String, CodingKey {
            case iataCode
            case terminal
            case at
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            iataCode = try container.decode(String.self, forKey: .iataCode)
            terminal = try container.decodeIfPresent(String.self, forKey: .terminal)
            let dateString = try container.decode(String.self, forKey: .at)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            guard let date = formatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(forKey: .at, in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
            at = date
        }
    }
    
    // MARK: - Operating
    struct Operating: Codable {
        let carrierCode: String?
    }
    
    
    struct Price: Codable {
        let currency: String?
        let total: String?
        let base: String?
        let fees: [Fee]?
        let grandTotal: String?

        init( total: String, base: String? = nil, fees: [Fee]? = nil, grandTotal: String? = nil) {
            self.currency = "EUR"
            self.total = total
            self.base = base
            self.fees = fees
            self.grandTotal = grandTotal
        }
    }
    // MARK: - Fee
    struct Fee: Codable {
        let amount: String?
        let type: String?
    }
    
    // MARK: - PricingOptions
    struct PricingOptions: Codable {
        let fareType: [String]?
        let includedCheckedBagsOnly: Bool?
    }
    
    // MARK: - TravelerPricing
    struct TravelerPricing: Codable {
        let travelerId: String?
        let fareOption: String?
        let travelerType: String?
        let price: TravelerPrice?
        let fareDetailsBySegment: [FareDetailsBySegment]?
    }
    
    // MARK: - FareDetailsBySegment
    struct FareDetailsBySegment: Codable {
        let segmentId: String?
        let cabin: String?
        let fareBasis: String?
        let classCode: String?
        let includedCheckedBags: IncludedCheckedBags?
        
        enum CodingKeys: String, CodingKey {
            case segmentId
            case cabin
            case fareBasis
            case classCode = "class"
            case includedCheckedBags
        }
    }
    
    // MARK: - IncludedCheckedBags
    struct IncludedCheckedBags: Codable {
        let weight: Int?
        let weightUnit: String?
    }
    
    // MARK: - TravelerPrice
    struct TravelerPrice: Codable {
        let currency: String?
        let total: String?
        let base: String?
    }
    
    struct Dictionaries : Codable {
        let locations: Locations?
        let aircraft: aircraft?
        let currencies: Currencies?
        let carriers: Carriers?
    }
    struct aircraft : Codable{
        let the320: String?
        let the321: String?
        let the330: String?
        let the332: String?
        let the333: String?
        let the350: String?
        let the359: String?
        let the737: String?
        let the738: String?
        let the772: String?
        let the773: String?
        let the781: String?
        let the787: String?
        let the789: String?
        let the7M8: String?
        let the73E: String?
        let the73M: String?
        let the32Q: String?
        let the32S: String?
        let the77W: String?
    }

    // MARK: - Carriers
    struct Carriers : Codable {
        let pr: String?
        let tw: String?
        let vz: String?
        let fm: String?
        let mu: String?
        let h1: String?
        let nx: String?
        let oz: String?
        let the7C: String?
        let sc: String?
        let br: String?
        let tg: String?
        let vj: String?
        let cx: String?
        let cz: String?
        let vn: String?
        let uo: String?
        let ke: String?
        let ca: String?
    }

    // MARK: - Currencies
    struct Currencies :Codable {
        let eur: String?
    }

    // MARK: - Locations
    struct Locations : Codable {
        let pvg: Bkk?
        let bkk: Bkk?
        let dmk: Bkk?
        let tao: Bkk?
        let hkg: Bkk?
        let dad: Bkk?
        let tpe: Bkk?
        let hgh: Bkk?
        let mnl: Bkk?
        let can: Bkk?
        let han: Bkk?
        let icn: Bkk?
        let mfm: Bkk?
        let pek: Bkk?
        let sgn: Bkk?
    }

    // MARK: - Bkk
    struct Bkk : Codable {
        let cityCode: String?
        let countryCode: String?
    }


    
}
   
