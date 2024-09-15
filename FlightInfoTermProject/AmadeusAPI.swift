//
//  AmadeusAPI.swift
//  FlightInfoWithAi
//
//  Created by ㅇㅇ ㅇ on 5/22/24.
//
import SwiftyJSON
import Foundation
struct AuthResponse: Codable {
    let type: String
    let username: String
    let applicationName: String
    let clientID: String
    let tokenType: String
    let accessToken: String
    let expiresIn: Int
    let state: String
    let scope: String?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case username = "username"
        case applicationName = "application_name"
        case clientID = "client_id"
        case tokenType = "token_type"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case state = "state"
        case scope = "scope"
    }
}






final class Constants {
    static let clientId = "0tKltcEDOu5xLFQ00zv1SGkRq1zao78j"
    static let clientSecret = "b0H3i2M45thXfYoB"
    static let authUrl = "https://test.api.amadeus.com/v1/security/oauth2/token"
    static var bookedFlights: [FlightBookingData.FlightDetails] = []
    
    //?origin=PAR&maxPrice=200
    static let GET_URL = "https://test.api.amadeus.com/v2/shopping/flight-offers"
       static let baseUrlV1 = "https://test.api.amadeus.com/v1"
       static let baseUrlV2 = "https://test.api.amadeus.com/v2"
       static let flightOffersUrl = "/shopping/flight-offers"
       static let flightOrderUrl = "/booking/flight-orders" 
   // static let Content_Type =  "application/x-www-form-urlencoded"
    
    // 첫번쨰 단계 인증을 요청
    static func getAuthRequest(onError: ((String)->Void)?, completion: @escaping (String)->()) {
        guard let url = URL(string: self.authUrl) else { return }
        let parameters = "grant_type=client_credentials&client_id=\(clientId)&client_secret=\(clientSecret)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.httpBody = parameters.data(using: .utf8)
        let session = URLSession(configuration: .default)
        let task  = session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                onError?(error.localizedDescription)
                print(error.localizedDescription)
                return
            }
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        print("########## getAuthRequest Invalid response")    // HTTPURLResponse로 변환 안되며 에러 처리
                                return
                            }

                            guard (200...299).contains(httpResponse.statusCode) else {
                                print("#########getAuthRequest Invalid response not 200~299")  // 상태코드가 성공이 아닐 경우 에러 처리
                                return
                            }
           
            guard let responseData = data else { print("########ResponseData is empty#######"); return }
//            let response = Response(response: httpResponse, data: responseData)
//            response.data
            let decoder = JSONDecoder()
            do { // AuthResponse
                let authResponse = try decoder.decode(AuthResponse.self ,from: responseData)
                completion("\(authResponse.tokenType) \(authResponse.accessToken)")
            } catch let error {
                onError?(error.localizedDescription)
                print("error#################")
            }
        })
        task.resume()
    }

     
    // ?originLocationCode=ICN&destinationLocationCode=BKK&departureDate=2024-06-02&returnDate=2024-06-20&adults=2&nonStop=false&max=250
    
    //https://test.api.amadeus.com/v2/shopping/flight-offers?originLocationCode=SYD&destinationLocationCode=BKK&departureDate=2024-06-02&returnDate=2024-07-02&adults=2&nonStop=false&max=250
    
    static func getFlightsRequest(
        for getFlightOffersBody: GetFlightOffersBody,

        completion: @escaping ([FlightBookingData.FlightDetails]) -> (),// 뷰컨트롤러 onsearchTapped에서 flightOffers 가 들어감
        onError: ((String)->Void)? // 이함수에선 flightOffersResponse로 디코드 할것이야. 디코드 한 결과물은 responseBody야 그것의 data와 flightOffers가 맞아야해
    ) {
        print("YHS################# in getFlightRequest request will be start")

        let GetOrigin : String = GET_URL+"?originLocationCode="+(getFlightOffersBody.originDestinations.first?.originLocationCode ?? "YHS get flight request$$$$$$$$$$$$ Error at origin")+"&"
       let GetDest : String = GetOrigin + "destinationLocationCode=" + (getFlightOffersBody.originDestinations.first?.destinationLocationCode ?? "YHS get flight reqest $$$$$$$$$$$$$ Error at destina")+"&"
        let GetDep : String = GetDest + "departureDate=" + (getFlightOffersBody.originDestinations.first?.departureDateTimeRange.date.prefix(10) ?? "YHS get flight reqest $$$$$$$$$$$$$ Error at departureDate") + "&"
        
        let GetTravel : String!
        if getFlightOffersBody.originDestinations.first?.returnDateTimeRange != nil{
            let GetRet : String = GetDep + "returnDate=" + (getFlightOffersBody.originDestinations.first?.returnDateTimeRange?.date.prefix(10) ?? "YHS get flight reqest $$$$$$$$$$$$$ Error at return Date") + "&"
            GetTravel = GetRet + "adults="+(String(getFlightOffersBody.travelers) ?? "YHS get flight reqest $$$$$$$$$$$$$ Error at return Date")
            
            
        }else{
            GetTravel = GetDep + "adults="+(String(getFlightOffersBody.travelers) ?? "YHS get flight reqest $$$$$$$$$$$$$ Error at Travel")}
        
        print(GetTravel)
        print("YHS################# in getFlightRequest first get Auth Request")

        Constants.getAuthRequest(onError: onError) { token in
            guard let url = URL(string: GetTravel!/*수정*/) else {
                onError?("YHS @@@@@@@@@@@ The URL could not be found.")
                return
            } //auth를 먼저 사용! 그 후에 데이터 보냄
             // getFlightOffersBody는 사용자가 입력한 데이터
            
                var request = URLRequest(url: url)
                //request.httpMethod = "GET"
               // request.addValue("GET", forHTTPHeaderField: "X-HTTP-Method-Override")
               // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue(token, forHTTPHeaderField: "Authorization")
               // request.httpBody = jsonData
                // 클로저는 웹에서 데이터를 가져왔을때
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                   
                    print("YHS################# in getFlightRequestAuth server Auth rsponde come")

                    if let error = error {
                        onError?(error.localizedDescription)
                        return
                    }
                    print("YHS################# in getFlightRequestAuth server Auth rsponde come")
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode)
                    else {
                        print("YHS################# in getFlightRequestAuth server Auth rsponde get error")
                        
                    let responseJson = JSON(data!)
                    print(responseJson.description)
                        print("responseJson: \(responseJson.count)") //4
                        if let data = data, let jsonResponse = try? JSONDecoder().decode(ErrorBody.self, from: data) {
                            
                            onError?("\(jsonResponse.errors[0].title), \(jsonResponse.errors[0].detail ?? "")") }
                        return
                    }
                    print("YHS################# in getFlightRequest responce codde 200~299")
                    guard let responseData = data else { return }
                    let decoder = JSONDecoder()
                    do {  print("YHS################# in getFlightRequest JSONDATA will be decoded")
                        let responseBody = try decoder.decode(FlightBookingData.FlightOffersResponse.self, from: responseData)
                        
                        completion(responseBody.data)
                        print("YHS################# getFlightRequest idata inserted completion")
                    } catch let error {
                        onError?(error.localizedDescription)
                    }
                }
                task.resume()
            
        }
    }
    
    
  
}
