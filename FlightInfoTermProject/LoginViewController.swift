//
//  LoginViewController.swift
//  FlightInfoWithAi
//
//  Created by ㅇㅇ ㅇ on 5/26/24.
//
import Firebase
import FirebaseFirestore
import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginText: UITextField!
    
    @IBOutlet weak var pwButton: UIButton!
    
    
    @IBOutlet weak var pwText: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var titleLab: UILabel!
    var dbmanager : DbFirebase!
    var User : Account?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbmanager = DbFirebase(parentNotification: manageDatabase(dict:dbaction:))
        
        pwText.isSecureTextEntry = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
    @IBAction func loginButtonTouched(_ sender: UIButton) {
        
        var pw = pwText.text
        var identifier = loginText.text
        print(pw)
        print(identifier)
        print(pw?.isEmpty==false&&identifier?.isEmpty==false)
        if( pw?.isEmpty==false&&identifier?.isEmpty==false){
            guard let identifier = identifier else{return}
            print(identifier)
            
            dbmanager.reference.document(identifier).getDocument{
                document,error in
                guard error == nil else{print(error);return;}
                guard let data = document!.data()
                else{
                    self.errorPop("ID/PW가 틀립니다. 다시 시도해 주세요.")
                    return }
                self.classifier(data)
            }

  
        }
    }
    
    
    
    
    @IBAction func RegButtonTouched(_ sender: UIButton) {
        performSegue(withIdentifier:"goToReg", sender: nil)
    }
    
    
    
    
    
    @IBAction func secureButtonTouched(_ sender: Any) {
        if(pwText.isSecureTextEntry){
            pwText.isSecureTextEntry=false}
        else{pwText.isSecureTextEntry=true}
    }

    
    
    func manageDatabase(dict: [String: Any]?, dbaction: DbAction?){
       guard let dict = dict else{return;}
        self.classifier(dict)}



    


    func classifier(_ data : [String:Any]) {
        
        let account = Account.fromDict(dict: data)
        self.User = account
        let classifier1 = account.id.contains(self.loginText!.text!)
        let classifier2 = account.passWord.contains(self.pwText!.text!)
        let classifier3 = account.id.count==self.loginText!.text!.count
        let classifier4 = account.passWord.count==self.pwText!.text!.count
        
        print(self.loginText!.text!)
        print(classifier1)
        print(classifier2)
        if classifier1 == true,classifier2==true,classifier3==true,classifier4==true {
            self.User = account
            
            //정보가 일치하고 로그인이 성공하면 파이어베이스에서 받아온 accout 객체를 싱글톤 static 객체 속성으로 가지고 있는 LoginUser클래스에 저장합니다.
            LoginUser.loginUserReplace(self.User!)
            print(self.pwText.text==account.id&&self.loginText.text==account.passWord)
                  performSegue(withIdentifier: "goToFlight", sender: self.User!)
         
        }
        else{
            
           errorPop("ID/PW가 틀립니다. 다시 시도해 주세요.")
            return
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
                guard let tab = segue.destination as? UITabBarController else{
                    Swift.print("YHS login segue error@@@@@@@");
                    return; }
                print(tab.selectedIndex)
                print(tab.selectedViewController)
                makeUpTabBar(tab: tab)
                return}
    // segue 실행후 메이크업 탭바 함수를 실행합니다.
    
    func makeUpTabBar(tab : UITabBarController){
        
        // 탭바뷰컨트롤러를 코드로 설정하는 함수입니다.
        let menu = storyboard!.instantiateViewController(withIdentifier: "MenuView") as! MenuViewController
        let flightOffer = storyboard!.instantiateViewController(withIdentifier: "FlightOfferView") as! FlightOfferViewController
        let collection = storyboard?.instantiateViewController(identifier: "CollectionView") as! CollectionViewController
        // 스토리 보드에서 메뉴뷰컨트롤러 flightofferview컨트롤러 컬렉션뷰컨트롤러를 실체화 시킵니다.
        
        let nav_menu = UINavigationController(rootViewController: menu)
        let nav_flight = UINavigationController(rootViewController: flightOffer)
        let nav_collection = UINavigationController(rootViewController: collection)
        // 각각의 컨트롤들을 받아줄 네비게이션 컨트롤러를 생성합니다.
    //    menu.loginViewController = self
        //tab.selectedViewController = menu
        
        makeUpTabBarItem(control: nav_menu, title: "menu", imageSystemName: "list.bullet.clipboard", selectedImageSystemName: "filemenu.and.cursorarrow.rtl")
        makeUpTabBarItem(control: flightOffer, title: "Book", imageSystemName: "airplane.departure", selectedImageSystemName: "airplane.arrival")
        makeUpTabBarItem(control: collection, title: "message", imageSystemName: "person.2", selectedImageSystemName: "person.2.fill")
        // 네비게이션 컨트롤러들을 꾸며줍니다. 탭바 아이템의 아이콘을 꾸미는 것입니다.


        
        tab.setViewControllers([nav_menu,nav_flight,nav_collection], animated: true)
        // 설정이 완료된 네비게이션 컨트롤러들을 탭바컨트롤러의 하위 뷰컨트롤러에 넣습니다.
        
        print(tab.selectedViewController)

        return;}
    
    
    func makeUpTabBarItem(control : UIViewController,title : String, imageSystemName:String, selectedImageSystemName:String){
        control.tabBarItem.title = title
        control.tabBarItem.image = UIImage(systemName: imageSystemName)
        control.tabBarItem.selectedImage = UIImage(systemName: selectedImageSystemName)
        
    }
    
    
    
    func errorPop(_ msg : String){
        
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            DispatchQueue.main.async{
                self.pwText.text = ""
                self.loginText.text = ""}
        }))
        self.present(alert, animated: true)
    }
}


