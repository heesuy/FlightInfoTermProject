
//  edit by hsyang on 2024/05/28

import UIKit

class CollectionViewController: UIViewController,UIGestureRecognizerDelegate{

    @IBOutlet weak var actressCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
   // var flightoffer : FlightOfferViewController?
   // var user : Account!
    var db : DbFirebase?
    var friends : [Account] = []
    var selectedFriend :Account?
 //   var loginView : LoginViewController!
    var FriendList_ID : [String]?
    // perform Segue 할떄 반드시 이것을 넘겨줘야해!
    
    var loginUser : Account!
    var selectedIndex : Int?
    
    @IBOutlet weak var collectionViewCell: UICollectionViewCell!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var addTF: UITextField!
    
    @IBOutlet weak var butt: UIButton!
    


    //  var actresses: [Actress] = ch09_TableViewCollectionView.load("actressData.json")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(butt)
        // Do any additional setup after loading the view.
        actressCollectionView.dataSource = self
        actressCollectionView.delegate = self
        let layout = actressCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.estimatedItemSize = .zero
        db = DbFirebase(parentNotification: manageDatabase_Collection(dict:dbaction:))
        // 가존의 쿼리를 리셋합니다. 간혹가다 다른 뷰 컨트롤러에 쿼리가 있는경우 그 뷰컨트롤러로 이동하는 경우가 있었습니다. 쿼리 리셋 함수는 간단히 다음처러 되어 있습니다.(클릭)
        db!.query_reset()
        tabBarController?.tabBar.isHidden = false
        self.tabBarItem.isEnabled = true

        
        // 사용자 정보를 가져옵니다.
        self.loginUser = LoginUser.getLoginUser()

        // 먼저 사용자 아이디를 쿼리로 설정합니다.
        
        db?.setQuery_equal(to: self.loginUser.id)

       
        // 뷰컨트롤러의 친구 목록 초기화 합니다.
      
        self.FriendList_ID =  self.loginUser.frendList.filter{$0 != self.loginUser!.id}.filter{$0 != ""}
        if FriendList_ID!.isEmpty==false {
            db?.setQuery_FindFriendList(friendList: FriendList_ID!, key: "id")}


        if (self.friends.isEmpty) {
            //????
            print("friends is empty")
            print(self.loginUser!.frendList.filter({self.loginUser!.id != $0}))
            //db?.setQuery_FindFriendList(friendList: self.loginUser!.frendList.filter({self.loginUser!.id != $0}), key: "id")
            // ad friend에도 추가함
            // userfrendLIst는 id의 조합, 따라서 이 쿼리를 실행하면 id를 조회해서 acount 객체들을 가져옴
            // 존재 안하는 id를 조회도 하는지?? 쿼리에서
            
            
       
        }

        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        // 다른 뷰 컨트롤러에서 로그인 유저를 업데이트 할 경우 다시 한번 로그인 유저를 가져옵니다.
        self.loginUser = LoginUser.getLoginUser()
        print("YHS@@@@@@@\(self.loginUser)@@@@@@")
        actressCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "hsyang1")
        
        // 메뉴에서 로그인유저 자신의 공유리스트를 확인할때 프레젠트 모달리로 뷰컨트롤러가 생성됨을 설명드렸습니다. 그 경우 이상하게도 이 컬렉션 뷰 컨트롤러가 프레젠트 모달리 뒤에서 초기화 됩니다.
        // 그래서 이 컬렉션 뷰 컨트롤러가 현재 화면의 맨 앞에서 보이는 뷰 컨트롤러가 아닐때는 쿼리를 리셋해서 혹시라도 뷰컨트롤러가 의도치않게 전환되는 것을 방지합니다.
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController as? SharedListController {
            db?.query_reset()
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        db?.setQuery_equal(to: self.loginUser.id)

    }
    
    func manageDatabase_Collection(dict: [String: Any]?, dbaction: DbAction?){
            let account = Account.fromDict(dict: dict!)
        
          if dbaction == .add{
              
              if self.classifier(account){
                  print(account)
                  // 친구 추가 했을때 그리고 쿼리가 설정되었을때 로그인유저의 계정 정보가 옵니다.
                  // 로그인 유저의 친구리스트를 컬렉션뷰의 친구 리스트 배열에 넣습니다.
                  self.self.loginUser! = account//Account.fromDict(dict: dict!)
                  LoginUser.loginUserReplace(self.loginUser)
                  self.FriendList_ID = account.frendList
                  self.actressCollectionView.isUserInteractionEnabled = true;
                  self.actressCollectionView.reloadData()
                  return;
                  }
              else{
                  // 자신의 계정이 아닌 친구의 계정이라면 여기로 옴
                  print(account)
                  self.actressCollectionView.isUserInteractionEnabled = true;
                  if friends.contains(account)==false{
                      friends.append(account)}

                  self.actressCollectionView.reloadData()

                  print("YHS@@@@@@Success append collection")
                      //return
              }
             
          }
          if dbaction == .modify{
              // 로그인 유저의 친구목록에서 수정이 일어난 경우입니다.
              // 이경우 친구들의 id를 저장한 배열을 쿼리로 설정합니다.

              if self.classifier(account){
                  LoginUser.loginUserReplace(account)
                  self.loginUser = LoginUser.getLoginUser()
                  if(self.loginUser.frendList.isEmpty){"you don't hav friend in modify";return;}
                      db?.setQuery_FindFriendList(friendList: self.loginUser!.frendList.filter{$0 != self.loginUser!.id}.filter{$0 != ""}, key: "id")//}
                  print("YHS@@@ modify success in collection")
              }else{ print("YHS@@@ modify fail in collection")}
              self.actressCollectionView.reloadData() // tableView의 내용을 업데이트한다

              return
           
          }
          if dbaction == .delete{
              // 친구 목록을 삭제할때 입니다.
              if self.classifier(account){
                  db?.setQuery_FindFriendList(friendList: self.loginUser!.frendList.filter{$0 != self.loginUser!.id}.filter{$0 != ""}, key: "id")
                  print("YHS@@@ delete success in collection")
              }else{ print("YHS@@@ delete fail in collection")}
         
          }

        self.actressCollectionView.reloadData() // tableView의 내용을 업데이트한다
    
         
     

        
        
    }
    
    
    // 친구를 추가할떄 입니다.
    @IBAction func friedAdd(_ sender: UIButton) {
        guard let tf = addTF.text else{self.makeAlertDialog(title: "알림", message: "아이디를 입력하세요.",false);return;}
      
        if let frindList = self.FriendList_ID {

            self.FriendList_ID!.append(tf)
        }else
        {self.FriendList_ID = [tf]}
            
 
        self.FriendList_ID = self.FriendList_ID!.filter{$0 != self.loginUser!.id}.filter{$0 != ""}
        // 친구 목록과 친구 id 목록에 중복이 있다면 제거를 합니다.
        self.FriendList_ID = self.removeDuplicate(self.FriendList_ID!)
        self.friends = self.removeDuplicate(self.friends)
        self.loginUser?.frendList = self.FriendList_ID!
        LoginUser.loginUserReplace(self.loginUser!)


        db?.saveChange(key: self.loginUser!.id, object: Account.toDict(account: self.loginUser!), action: .modify)
     
        
        }
        
    
    
}

extension CollectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(friends.isEmpty){
            self.actressCollectionView.isUserInteractionEnabled = false;
        }
        if(self.loginUser?.frendList == nil){return 1}
        else {return self.loginUser!.frendList.count
            //return self.friends.count
        }
    //    return actresses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       self.friends = self.removeDuplicate(self.friends)
        self.FriendList_ID = self.removeDuplicate(self.FriendList_ID!)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hsyang1", for: indexPath)
        
        // cell을 생성할때 롱프레스 리코그나이져와 탭제스쳐 리코그 나이져를 부착합니다.
        //이 경우 제스쳐 리코그 나이져들은 add 속성이고 셀은 재사용되기에 혹시 모를 중복의 문제를 회피하기 위해 제스쳐 리코그나이져 속성에 nill을 부여합니다.
        cell.gestureRecognizers = nil
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(cellLongTapped))
        longTap.minimumPressDuration = 3
         
        tap.cancelsTouchesInView = false
        longTap.cancelsTouchesInView = false
        tap.delegate = self
        longTap.delegate = self
        
        // 셀을 원으로 그립니다.
        cell.layer.cornerRadius = min(cell.bounds.width, cell.bounds.height) / 2
        cell.layer.masksToBounds = true
        cell.layer.borderWidth  = 0.001
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        
        cell.addGestureRecognizer(tap)
        cell.addGestureRecognizer(longTap)
        
        for v in cell.contentView.subviews{
            v.removeFromSuperview()
        }
        
     //   let actress = actresses[indexPath.row]

        let outer = UIStackView()
        let nameLabel = UILabel()
        let imageView = UIImageView()
      //  let radius = cell.layer.cornerRadius
        if (self.friends.isEmpty==false&&self.friends.count == self.FriendList_ID!.count){
            
            let friends = self.friends[indexPath.row]
           
            self.db?.downloadImage(imageName: friends.imageName, completion: { image in
                
                //imageView.image = image! //image?.resized(to: CGSize(width: 200, height: 100))
                
                imageView.layer.cornerRadius = min(cell.bounds.width, cell.bounds.height) / 2
                imageView.layer.borderWidth = 0.1
                //imageView.layer.opacity = 0.01
                imageView.image = image?.resized(to: CGSize(width: 100, height: 100))
                imageView.layer.cornerRadius = min(imageView.bounds.width, imageView.bounds.height) / 2
                imageView.clipsToBounds = true
                
                cell.setNeedsLayout() //
            })
                    
            nameLabel.text = friends.name
            nameLabel.textAlignment = .center
        }
        else{print("@@@@@@@@@@@@@@you don't have friend@@@@@@@@@@")
            nameLabel.text = "친구를 추가하세요"
            nameLabel.textAlignment = .center
        }
        
        cell.contentView.addSubview(outer)
        outer.translatesAutoresizingMaskIntoConstraints = false
        
        outer.addArrangedSubview(nameLabel)
        outer.addArrangedSubview(imageView)
        outer.axis = .vertical
        NSLayoutConstraint.activate([
            outer.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            outer.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            outer.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            outer.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        
        ])
        return cell
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
           return true
       }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(friends.isEmpty){
            self.actressCollectionView.isUserInteractionEnabled = false;
        }else{
            selectedIndex=indexPath.item
            if(friends.endIndex>=indexPath.item){
                
                selectedFriend = friends[indexPath.item]}
        }}
    
    
    func makeAlertDialog(title: String, message: String, _ isAlert : Bool = true) {
        
        //가운데에서 출력되는 Dialog.
        let alert = isAlert ? UIAlertController(title: title, message: message, preferredStyle: .alert)
        // actionSheet : 밑에서 올라오는 Dialog. 3개 이상을 선택할 경우 사용
        : UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        // destructive : title 글씨가 빨갛게 변함
        // cancel : 글자 진하게
        // defaule : X
        let alertDeleteBtn = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            print("[SUCCESS] Dialog Cancel Button Click!")
        }
        let alertSuccessBtn = UIAlertAction(title: "OK", style: .default) { (action) in
            print("[SUCCESS] Dialog Success Button Click!")
        }
        
        // Dialog에 버튼 추가
        if(isAlert) {
            alert.addAction(alertDeleteBtn)
            alert.addAction(alertSuccessBtn)
        }
        else {
            alert.addAction(alertSuccessBtn)
            alert.addAction(alertDeleteBtn)
        }
        //        print("alert button count : ", alert.actions.count)
        
        // 화면에 출력
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func classifier(_ account:Account) ->Bool{
        
        //   let account = Account.fromDict(dict: data)
        
        let classifier1 = account.id.contains(self.self.loginUser!.id)
        let classifier2 = account.passWord.contains(self.self.loginUser!.passWord)
        let classifier3 = account.id.count==self.self.loginUser!.id.count
        let classifier4 = account.passWord.count==self.self.loginUser!.passWord.count
        
        
        print(classifier1)
        print(classifier2)
        return( classifier1 == true&&classifier2==true&&classifier3==true&&classifier4==true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.db?.query_reset()
      
    }
    



// 친구를 보여주는 셀에서 그 셀이 터치되며 친구의 공유 게시물을 보여주는 컨트롤러로 이동합니다.
    // 롱터치되면 친구목록에서 삭제됩니다.
    @objc func cellTapped(sender : UIGestureRecognizer){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
          
            self.performSegue(withIdentifier: "friendListToSharedList", sender: self.selectedFriend)
        }
    }
    @objc func cellLongTapped(sender: UIGestureRecognizer) {
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 2)
            guard let selectedIndex = self.selectedIndex, selectedIndex < self.friends.count, selectedIndex < self.FriendList_ID?.count ?? 0 else {
                print("Invalid selectedIndex: \(String(describing: self.selectedIndex))")
                return
            }
            
            print("selectedIndex ===   \(selectedIndex)       \(self.friends.count)")
            
            if(self.friends.contains(self.selectedFriend!)){
                self.friends.remove(at: self.friends.firstIndex(of: self.selectedFriend!)!)
                let index = self.FriendList_ID!.firstIndex(of:self.selectedFriend!.id)
                self.FriendList_ID?.remove(at: index!)
                
                self.FriendList_ID = self.FriendList_ID!.filter { $0 != self.loginUser!.id }.filter { $0 != "" }
                
                self.loginUser.frendList = self.FriendList_ID!
                
                LoginUser.loginUserReplace(self.loginUser!)
                
                    self.db!.saveChange(key: self.loginUser!.id, object: Account.toDict(account: self.loginUser!), action: .modify)
                    }
            else{
                print(self.friends.contains(self.selectedFriend!))
            }
                self.actressCollectionView.reloadData()// 컬렉션 뷰를 업데이트
                return
            }
        }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
           let share = segue.destination as! SharedListController
        print("prepare selectedIndex ===   \(self.selectedIndex)       \(self.friends.count)")

        share.selectedUser = friends[selectedIndex!].id
            db?.query_reset()
        
    }
    
    
    // 컬렉션뷰 부터는 빠르게 하다보니 코드가 복잡해져서 친구 목록 배열에 중복되는 경우가 많았습니다. 코드 중간중간 틈틈히 중복을 제거하는 함수를 이용했습니다.
    func removeDuplicate<T: Hashable>(_ array: [T]) -> [T] {
        var removedArray = [T]()
        for element in array {
            if !removedArray.contains(element) {
                removedArray.append(element)
            }
        }
        print(removedArray)
        return removedArray
    }
    
    
}
    
    
  
    

