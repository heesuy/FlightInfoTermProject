/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A representation of a single landmark.
*/

import Foundation
import SwiftUI
import CoreLocation

struct Account: Hashable, Codable, Identifiable {
    var id: String
    var passWord: String
    var name : String
    var gender : String
    var birth : String
    var imageName : String
    var flight : [flightForFIrebase]?
    var frendList : [String] = []

    init(id: String, password: String, name: String, gender: String, birth: String,imageName : String) {
        self.id = id
        self.name = name
        self.passWord = password
        self.gender = gender
        self.birth = birth
        self.imageName = imageName
      
    }
    init(id: String, password: String, name: String, gender: String, birth: String,imageName : String, /*fly :[flightForFIrebase]? = nil ,*/ frind : [String]) {
        self.id = id
        self.name = name
        self.passWord = password
        self.gender = gender
        self.birth = birth
        self.imageName = imageName
        self.frendList = frind
    //    self.flight = fly
    }

    func uiImage(size: CGSize? = nil) -> UIImage?{
        //let image = UIImage(named: imageName)!
        guard let image = UIImage(named: imageName) else { return nil }

        guard let size = size else{ return image}
        
        // context를 획득 (사이즈, 투명도, scale 입력)
        // scale의 값이 0이면 현재 화면 기준으로 scale을 잡고, sclae의 값이 1이면 self(이미지) 크기 기준으로 설정
        UIGraphicsBeginImageContext(size)

        // 이미지를 context에 그린다.
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // 그려진 이미지 가져오기
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
        
        // context 종료
        UIGraphicsEndImageContext()
        return resizedImage
    }

    var image: Image {
        Image(imageName)
    }
}
/*
extension Account{
    static func toDict(account: Account) -> [String: Any]{
        var dict = [String: Any]()
        var dict_flight = [String : Any]()
        
        dict["id"] = account.id
        dict["passWord"] = account.passWord
        dict["name"] = account.name
        dict["gender"] = account.gender
        dict["birth"] = account.birth
        dict["imageName"] = account.imageName
        
        dict["datatime"] = Date().timeIntervalSince1970
       
                
        dict["fly"]=dict_flight
        dict["friend"] = account.frendList
        return dict
    }
    
    static func fromDict(dict: [String: Any]) -> Account{
        
        let id = dict["id"] as! String
        let name = dict["name"] as! String
        let passWord = dict["passWord"]as! String
     let gender = dict["gender"]  as! String
        let birth = dict["birth"] as! String
        let imageName = dict["imageName"] as! String
        let fly = dict["fly"] as! [flightForFIrebase]
        let FriendList = dict["friend"] as! [String]

        return Account(id: id, password : passWord, name: name, gender: gender, birth: birth , imageName: imageName, fly: fly,frind : FriendList)
    }
}

*/
/*
extension Account {
    static func toDict(account: Account) -> [String: Any] {
        var dict = [String: Any]()
        dict["id"] = account.id
        dict["passWord"] = account.passWord
        dict["name"] = account.name
        dict["gender"] = account.gender
        dict["birth"] = account.birth
        dict["imageName"] = account.imageName
        dict["datatime"] = Date().timeIntervalSince1970
        
        if let flights = account.flight {
            dict["flight"] = flights.map { $0.toDict() }
        } else {
            dict["flight"] = NSNull()
        }
        
        dict["friend"] = account.frendList
        return dict
    }

    static func fromDict(dict: [String: Any]) -> Account {
        let id = dict["id"] as! String
        let name = dict["name"] as! String
        let passWord = dict["passWord"] as! String
        let gender = dict["gender"] as! String
        let birth = dict["birth"] as! String
        let imageName = dict["imageName"] as! String
        let flightDicts = dict["flight"] as? [[String: Any]]
        let flights = flightDicts?.map { flightForFIrebase.fromDict($0) }
        let friendList = dict["friend"] as! [String]

        return Account(id: id, password: passWord, name: name, gender: gender, birth: birth, imageName: imageName, fly: flights ?? [], frind: friendList)
    }
}
1차수정
*/
//2차수정

extension Account{
    
    
    //    static func onlyFlight(_ flight :[flightForFIrebase])->[String:Any]{
    //        var dict = [String: Any]()
    //
    //        dict["flight"] = flight.map { $0.toDict() }
    //    return dict
    // }
    
    
    
    static func toDict(account: Account) -> [String: Any] {
        var dict = [String: Any]()
        dict["id"] = account.id
        dict["passWord"] = account.passWord
        dict["name"] = account.name
        dict["gender"] = account.gender
        dict["birth"] = account.birth
        dict["imageName"] = account.imageName
        dict["datatime"] = Date().timeIntervalSince1970
        
//        if let flights = account.flight {
//            dict["flight"] = flights.map { $0.toDict() }
//        } else {
//            dict["flight"] = NSNull()
//        }
        
        dict["friend"] = account.frendList
        return dict
    }
    
    static func fromDict(dict: [String: Any]) -> Account {
        let id = dict["id"] as! String
        let name = dict["name"] as! String
        let passWord = dict["passWord"] as! String
        let gender = dict["gender"] as! String
        let birth = dict["birth"] as! String
        let imageName = dict["imageName"] as! String
        let friendList = dict["friend"] as! [String]
        print(friendList)
    //    let flightDicts = dict["flight"] as? [[String: Any]]
//        if(flightDicts?.isEmpty==false){
//            
//            print("@@@@@@@YHS flightDicts.count\(flightDicts?.count)")
//            let flights  = flightDicts?.map {
//                print("@@YHS value count\($0.count)@@@@@values@@\($0.values)@@@@@@")
//                flightForFIrebase.fromDict($0) }
//            print(flights)
//            
//            return Account(id: id, password: passWord, name: name, gender: gender, birth: birth, imageName: imageName, fly: flights as? [flightForFIrebase] ?? [flightForFIrebase](), frind: friendList)
//        }
        
        
        return Account(id: id, password: passWord, name: name, gender: gender, birth: birth, imageName: imageName,frind: friendList)
    }
    
}
