//
//  RegisterViewController.swift
//  FlightInfoWithAi
//
//  Created by ㅇㅇ ㅇ on 5/30/24.
//

import UIKit


class RegisterViewController : UIViewController{
    var dbManager : DbFirebase?
    var isShowKey = false
    @IBOutlet weak var botCon: NSLayoutConstraint!
    @IBOutlet weak var topCon: NSLayoutConstraint!
    
    @IBOutlet weak var IdReg: UITextField!
    @IBOutlet weak var pwReg: UITextField!
    @IBOutlet weak var nameReg: UITextField!
    @IBOutlet weak var genderReg: UITextField!
    @IBOutlet weak var AgePick: UIPickerView!
    @IBOutlet weak var ImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPic))
        ImageView.addGestureRecognizer(tap)
        
        AgePick.delegate = self
        AgePick.dataSource = self
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap1)
        pwReg.isSecureTextEntry = true
        self.dbManager = DbFirebase(parentNotification: manageDatabase)
        
    }
    func manageDatabase(dict: [String: Any]?, dbaction: DbAction?){}
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main){
            Notification in
            if self.isShowKey == false{
                self.isShowKey = true
                self.topCon.constant -= 200
                self.botCon.constant -= 200
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main){
            Notification in
            if self.isShowKey == true{
                self.topCon.constant += 200
                self.botCon.constant += 200
                self.isShowKey = false
                
            }
        }}
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillHideNotification,object: nil )
    }
    
    func convertToDate1(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)
    }
    
    
    
    
    
    @IBAction func completeButton(_ sender: UIButton) {
        guard let idreg = IdReg.text, idreg.isEmpty == false else{ return }
        guard let pwreg = pwReg.text, pwreg.isEmpty == false else{ return }
        guard let namereg = nameReg.text, namereg.isEmpty == false else{ return }
        guard let genderreg = genderReg.text, genderreg.isEmpty == false else{ return }
        
        
        
        
        
        let birthPicker = 2024 - Int(AgePick.selectedRow(inComponent: 0))
        
        
        let image = ImageView.image
        let imageNamee = idreg + String(birthPicker)
        let Accouont = Account(id: idreg, password: pwreg, name: namereg, gender: genderreg, birth: String(birthPicker), imageName: imageNamee,frind: [idreg]) //idreg에서 수정
        let dict = Account.toDict(account: Accouont)
        
        if let image = image{
            self.dbManager?.uploadImage(imageName: imageNamee, image: image){
                //Todo
                self.dbManager?.saveChange(key: idreg, object: dict, action: .add)
                if let parent = self.parent as? UINavigationController{
                    parent.popToRootViewController(animated: true)}
            }
        }else{
            self.dbManager?.saveChange(key: idreg, object: dict, action: .add)
            dbManager!.reference_shareList.document(Accouont.id).updateData(["id":Accouont.id])
        }
        
     
    }
     
    
    
    
    @objc func tapPic(_sender : UITapGestureRecognizer){
        let Ipvc = UIImagePickerController()// 사진 찍을 뷰컨트롤러 생성
        Ipvc.delegate = self // 사진을 찍은 후 처리자 자격증을 CDVC에게
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //카메라를 가지고 있는 경우 사진찍을 뷰컨트롤러의 속성을 카메라로
            Ipvc.sourceType = .camera
            
        }
        else{
            // 그렇지 않은 경우 뷰컨트롤러의 속성은 앨범으로
            Ipvc.sourceType = .savedPhotosAlbum
            
        }// 기기가 카메라를 가지고 있는지 체크해주는 스태틱 함수
        
        Ipvc.sourceType = .savedPhotosAlbum
        // 디폴트 속성은 앨범!
        
        present(Ipvc, animated: true, completion: nil)
        // 뷰컨트롤러 초기화 했으면 전이!
    }
    
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
}



extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    // 반드시 UINavigationControllerDelegate도 상속받아야 한다
    
    // 사진을 찍은 경우 호출되는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // UIImage를 가져온다
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // 여기서 이미지에 대한 추가적인 작업을 한다
        ImageView.image = image // 화면에 보일 것이다.
        
        // imagePickerController을 죽인다
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 사진 캡쳐를 취소하는 경우 호출 함수
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
extension RegisterViewController : UIPickerViewDataSource,UIPickerViewDelegate{
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 80
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var a  :Int = 2024-row
        return String(a)
    }
    
}
