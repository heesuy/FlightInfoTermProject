//
//  MasterDetail.swift
//  ch11-2071503-yangHeesu-CityFirebase
//
//  Created by ㅇㅇ ㅇ on 5/11/24.
//

import UIKit

class SharedListController: UIViewController {
    
    @IBOutlet weak var shareTableView: UITableView!
  
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userPostCount: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var selectedUser : String!
    var dbFireBase : DbFirebase!

    var indexpath : Int?
    

    var sharedDate : [String] = []
    var Dict : [String:Any]?
    var tag : [String] = []
    
    var sharedData : [String:Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
      //  let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(customBackButtonTapped))
          makeUpTable(shareTableView)

      //    backButton.tintColor = .systemBlue

         // self.navigationItem.leftBarButtonItem = backButton
      //  self.parent?.navigationController?.navigationItem.leftBarButtonItem = backButton
        
        dbFireBase = DbFirebase(parentNotification: manageDatabase)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        print(select)
        //쿼리 설정 종료 필수
        
        //속성으로 가지고 있는 selectedUser 는는 컬렉션뷰에서 사용자가 선택한 친구를 의미합니다.
        // 선택된 유저가 초기화 되지 않은 경우라면 로그인 유저 즉 사용자가 자신의 공유 게시글을 볼떄입니다. 그 경우 loginUser를 가져옵니다.
        if(selectedUser == nil){
            selectedUser = LoginUser.getLoginUser()!.id}
        dbFireBase.query_reset()
        print(selectedUser)
        dbFireBase.setQuery_equal(to: selectedUser)
        dbFireBase.setQuery_SharedLIst(to: selectedUser!)
        shareTableView.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        dbFireBase.query_reset()
        sharedDate = []
       
    }
    
    func makeUpTable(_ a: UITableView){
        
        a.register(UITableViewCell.self, forCellReuseIdentifier: "hsyang22")
        a.rowHeight = UITableView.automaticDimension
        a.estimatedRowHeight = 300
        a.dataSource = self
        a.delegate = self
        a.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
    }
    
    func manageDatabase(dict: [String:Any]?,DbAction:DbAction?){
        //let city = City.fromDict(dict: dict!)
        //dict?.keys.map{sharedDate?.append($0)}
        if(DbAction == .modify){
            
            shareTableView.reloadData()
            //return;
            print("modify data \(dict)")
        }
        
        // 이 컨트롤에서 쿼리 콜백함수가 호출될때는 selectedUser의 프로필 사진이 변경될 경우나 selectdUser의 공유 리스트가 변경될때입니다. 각 두가지 경우 파이어스토어에서 오는 데이터의 key값들이 다르기에 key값들로 분류했습니다.
        // 첫번째 dict!.keys.contains("passWord")==false는 selectedUSer의 공유리스트가 변경되거나 공유리스트 쿼리를 처음 설정할때 입니다.
        if(dict!.keys.contains("passWord")==false ){
            self.Dict = dict
            
            let dict1 = dict?.filter{$0.self.key != "id"}.filter{$0.self.key != "tag"}.filter{self.sharedDate.contains($0.key)==false}
            //dict!.filter{$0.self.key == "tag"}.forEach{tag?.append($0.value as! String)}
            dict1?.forEach{sharedDate.append($0)
               
                var a = $1.self as! [String:Any]
                print(a)
                tag.append( a["tag"] as! String)
                print(tag)
            }
           
            // 공유 리스트의 날짜와 공유 항목들이 비어있는 경우가 있는데 그것들을 방지합니다.
            self.sharedDate = sharedDate.filter{$0.isEmpty==false}
           
                self.sharedDate = self.removeDuplicate(sharedDate)
         
                self.tag = self.removeDuplicate(tag)
                shareTableView.reloadData()}
            
        
        else{
            
            // selectedUser의 프로필을 꾸며줍니다.
            let account=Account.fromDict(dict: dict!)
            self.dbFireBase.downloadImage(imageName: account.imageName, completion: { image in
                
                //imageView.image = image! //image?.resized(to: CGSize(width: 200, height: 100))
             
                self.userNameLabel.text = account.name
                self.userNameLabel.textAlignment = .left
                self.userNameLabel.textColor = .systemGray
                self.userNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                
                self.userPostCount.text = "\(self.sharedDate.count) 개의 게시물"
                self.userPostCount.textAlignment = .left
                self.userPostCount.textColor = .systemGray
                self.userPostCount.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                
                self.userImage.image = image!.resized(to: self.userImage.frame.size)
                self.userImage.clipsToBounds = true
                //self.userImage.setNeedsDisplay() //
            })
            
            
            
            
        }
        

       
        
        
    }
    
    @IBAction func editingTableRow(_ sender: UIBarButtonItem) {
        if(selectedUser == LoginUser.getLoginUser()!.id){
            if shareTableView.isEditing == true{
                shareTableView.isEditing = false
                sender.title = "Edit"
            }else{
                shareTableView.isEditing = true
                sender.title = "Done"
            }
        }
        
    }
    
    
    //  사용자가 클릭을 한 공유리스트를 SelectedSharedFlightViewController 로 전달합니다.
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if let indexpath = sender as? IndexPath{
        let des = segue.destination as! SelectedSharedFlightViewController

         var a = self.Dict![self.sharedDate[indexpath.row]] as! [String:Any]
         var b = flightForFIrebase.fromDict(a)
         des.price = b.price
         des.flightDetails = b.toSegment()
      
      
           }
        
    }
}






extension SharedListController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count : Int!
        
        if (sharedDate.isEmpty){
        count = 1
        }else{
            count = sharedDate.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hsyang")!
        // 재사용일 경우 가져오겠다는 조건으로 만든 cell
        
        for v in cell.contentView.subviews{
            v.removeFromSuperview()
        }
        
        
        // 공유 리스트의 셀들을 꾸며주는 함수입니다.
        if(sharedDate.isEmpty==false){
            print("@@@@@@tag@@@@@@@ \(tag)")
            cell.textLabel?.text = tag[indexPath.row]
            let data = sharedDate[indexPath.row].split(separator: "T")
            let time = " \(data[1].filter{$0 != "Z"})"
            cell.detailTextLabel?.text  = "     \(data[0])   \(time) "
            cell.detailTextLabel!.textAlignment = .center
            cell.detailTextLabel!.textColor = .systemGray
            cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            
            cell.textLabel?.textAlignment = .center
            cell.textLabel!.textColor = .systemGray
            cell.textLabel!.font = UIFont.systemFont(ofSize: 25, weight: .semibold)

            cell.accessoryType = .none
            
            
        }
            return cell
        
    }
    
    
    

    
}

extension SharedListController: UITableViewDelegate{
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 아래는 로그인 유저가 자신의 공유리스트를 보는 경우만 삭제되게 했습니다.
        if(selectedUser == LoginUser.getLoginUser()!.id){
            
            if editingStyle == .delete{
                
                
                self.Dict = self.Dict!.filter{ $0.self.key != sharedDate[indexPath.row]}
                
                sharedDate.remove(at: indexPath.row)
               
                tag.remove(at: indexPath.row)
                
                dbFireBase.saveChange_shareList(key: selectedUser!, object: self.Dict!, action: .modify)
            }}
        else{
            let alert = UIAlertController(title: "Error", message: "자신의 게시글만 삭제 가능합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                
            }))
            self.present(alert, animated: true)
            
        }
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let docRef = self.dbFireBase.reference_shareList.document(selectedUser)
        docRef.getDocument{ doc , error in
            guard let doc = doc else {print("nodoc");return;}
            if  let error = error {print(error);return;}else{
                let shareData = doc.data()?.filter{$0.self.key == self.sharedDate[indexPath.row]
                    
                }

                
                if let share = shareData{
                    self.sharedData = share
                    DispatchQueue.main.async{
                        self.performSegue(withIdentifier: "sharedListToSelect", sender: indexPath)}
                }
                else{print("cannot find in table View")}
            }
            
        }}
        
        
        

        
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


   


