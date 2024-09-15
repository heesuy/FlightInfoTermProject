//
//  MenuViewController.swift
//  FlightInfoWithAi
//
//  Created by ㅇㅇ ㅇ on 5/30/24.
//


/*이제는 탭바뷰컨트롤러의 첫번째 아이템 메뉴뷰 컨트롤러입니다 두번째는 친구 목록 확인 세번째는 자신의 공유 목록을 볼 수 있습니다.
 첫번째 플라잇 뷰 컨트롤러로 갑니다.
 
 */
import Foundation
import UIKit

class MenuViewController : UIViewController {
    
  //  var loginViewController : LoginViewController!
    var loginUser : Account!
    
    @IBOutlet weak var dirctShareButton: UIButton!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = LoginUser.getLoginUser() else{return}
        label.text =  "\(user.name)님 반갑습니다."
        loginUser = user
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loginUser = LoginUser.getLoginUser()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    //버튼이 세개가 있고 각각의 터치 이벤트 함수들입니다. 첫번째 버튼의 이벤트 처리는 항공권을 검색하는 flightofferview컨트롤러로 이동합니다.
    
    @IBAction func flightOfferBUtton(_ sender: UIButton) {
        
        self.tabBarController?.selectedIndex = 1
        
       
    }
    
    // 두번째는 친구 목록 확인하는 collectionView컨트롤러로 이동합니다.
    @IBAction func shareTouch(_ sender: UIButton) {
       
        self.tabBarController?.selectedIndex = 2
        
    }
    
    // 세번쨰는 자신의 공유목록 보여주는 함수입니다 공유목록을 보여주는 sharedListViewControlelr로 이동합니다.
    // 여기서는 present함수를 이용해 프레젠트 모달리 방식으로 자신의 공유목록을 보여줍니다  이것을 제외한 위의 함수들은 탭바의 선택된 뷰 컨트롤러를 인덱스를 통해 바꾸면서 화면전환이 이루어집니다.
    @IBAction func directShareTouch(_ sender: UIButton) {
        presentViewController(  "sharedList")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "MenuToDirectShare":
            let sharedLIst =   segue.destination as! SharedListController
            sharedLIst.selectedUser = self.loginUser.id
            
            
        default:
            guard let collection = segue.destination as? CollectionViewController else{
                let flightOfferView = segue.destination as! FlightOfferViewController
            //    flightOfferView.loginView = self.loginViewController
                
                return;
            }
            
            collection.FriendList_ID = LoginUser.getLoginUser()!.frendList
            self.tabBarController?.selectedViewController  = collection
        }
    }
    
    
    @IBAction func presentViewController(_ name : String) {
            // 스토리보드 객체 생성 
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
            // 스토리보드 ID를 통해 뷰 컨트롤러 인스턴스
            if let newViewController = storyboard.instantiateViewController(withIdentifier: name) as? SharedListController {
                
                // 뷰 컨트롤러를 모달로 표시
                self.present(newViewController, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
                self.tabBarController?.selectedIndex = 0

            }
        }


    override func viewWillDisappear(_ animated: Bool) {
    }
}


            
        
    
    
