//
//  LoginUser.swift
//  FlightInfoWithAi
//
//  Created by ㅇㅇ ㅇ on 6/4/24.
//

import Foundation
import UIKit

class LoginUser : NSObject {
    static private var loginUser : Account?
    
   
    
    static var isLoginUser: Bool{
        if self.loginUser != nil{
            printLoginUser()
            return true
        }else{return false}

    }
    static func loginUserReplace(_ loginUser: Account){
        self.loginUser = loginUser
    }
    static func logoutUser(){
        loginUser = nil
    }
    static func getLoginUser() -> Account?{
        return self.loginUser
    }
    static func printLoginUser() {
        print("@@@@YHS@@@@@@ LoginUser :\(loginUser)@@@@@@@")
    }
    
    
    
    
}
//class PopUp : NSObject{
//    
//    static func errorPop(_ msg : String, a : (Any) ->()){
//     
//            
//            let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                DispatchQueue.main.async{
//                    self.pwText.text = ""
//                    self.loginText.text = ""}
//            }))
//
//        
//    }
//}
