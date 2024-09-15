//
//  DbFirebase.swift
//  ch11-Firebase
//
//  Created by jmlee on 2024/05/11.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage

class DbFirebase: Database{
    
    
    
    // 데이터를 저장할 위치 설정
    var reference: CollectionReference = Firestore.firestore().collection("cities")
    
    var reference_shareList: CollectionReference = Firestore.firestore().collection("shareList")
    
    
    
    // 데이터의 변화가 생기면 알려쥐 위한 클로즈
    var parentNotification: (([String: Any]?, DbAction?) -> Void)?
    
    
    
    var existQuery: ListenerRegistration?
    // 이미 설정한 Query의 존재여부
    
    var existQuery_key: ListenerRegistration?
    
    var existQuery_remove: ListenerRegistration?
    
    var existQuery_FindFriendList  : ListenerRegistration?
    
    var existQuery_Equal : ListenerRegistration?
    
    var existQuery_shareList : ListenerRegistration?

    
    required init(parentNotification: (([String : Any]?, DbAction?) -> Void)?) {
        // 클로저를 보관
        self.parentNotification = parentNotification
    }
    
    func saveChange(key: String, object: [String: Any], action: DbAction) {
        
        print("yhs@@@@@@@@@@@ saveChange@@@@@@")
        // 이러한 key에 대하여 데이터를 add, modify, delete를 하라는 것임
        if action == .delete{
            reference.document(key)
            return
        }
        // key에 대한 데이터가 이미 있으면 overwrite, 없으면 insert
        reference.document(key).setData(object)
    }
    
    func saveChange_shareList(key: String, object: [String: Any], action: DbAction) {
        
        print("yhs@@@@@@@@@@@shareList saveChange@@@@@@")
        // 이러한 key에 대하여 데이터를 add, modify, delete를 하라는 것임
        if action == .delete{
            reference_shareList.document(key).delete()
            return
        }
        // key에 대한 데이터가 이미 있으면 overwrite, 없으면 insert
        reference_shareList.document(key).setData(object)
    }

  
    func onChangingData(querySnapshot: QuerySnapshot?, error: Error?){
        // 이것은 setQuery의 결과로 호출된다.
        // 당영히 스레드로 실행되므로 GUI를 변경하면 안된다.
        
        guard let querySnapshot = querySnapshot else{
            print("yhError@@@@@@@@@@@\(error)@@@@@@")
            return } // 이 경우는 발생하지 않음
        // setQuery의 쿼리를 만족하는 데이터가 없는 경우 count가 0이다.
        if(querySnapshot.documentChanges.count == 0){
            print("@@@@@@yhs on changeing data no@@@@")
            return
        }
        // 쿼리를 만족하는 데이터가 많은 경우 속도 문제로 한꺼번에 여러 데이터가 온다
        for documentChange in querySnapshot.documentChanges {
            
            let dict = documentChange.document.data() // 데이터를 가져옴
            var action: DbAction?
            switch(documentChange.type){  // 단순히 DbAction으로 변환
            case  .added: action = .add
            case  .modified: action = .modify
            case  .removed: action = .delete
            }
            // 부모에게 알림
            if let parentNotification = parentNotification {parentNotification(dict, action)}
        }
    }
}

extension DbFirebase{
 
    func uploadImage(imageName: String, image: UIImage, completion: @escaping () -> Void){
   
    // uiimage를 jpeg 파일에 맞게 변형, png도 가능
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { print("nothing in upload");return; }
        //guard let imageData = image.pngData() else { return }

    // 파이어베이스내에 스토리지의 레퍼런스를 만든다.
    let reference = Storage.storage().reference().child("cities").child(imageName)
    let metaData = StorageMetadata()  // 보내고자 하는 데이터에 대한 메타정보
    metaData.contentType = "image/jpeg" // 이것은 jpeg 데이터임을 표시
   
    // 여기서 업로드하여 저장한다
    reference.putData(imageData, metadata: metaData, completion: {
        data, error in
        completion()
    })
                           
  }
  func downloadImage(imageName: String, completion: @escaping (UIImage?) -> Void) {
    // completion 함수는 이미지 로딩이 다 이루어지면 알려 달라는 함수
      let reference = Storage.storage().reference().child("cities").child(imageName)
      
    
    let megaByte = Int64(10 * 1024 * 1024) // 충분히 크야한다.
    reference.getData(maxSize: megaByte) { data, error in
   
      // 스레드에 의하여 실행된다.
      completion( data != nil ? UIImage(data: data!): nil)
        print("download complete ", imageName)
    }
  }
}

// query comstum
extension DbFirebase {
    func query_reset(){
        // 모든 쿼리 배열들을 삭제합니다.
        existQuery?.remove();existQuery_key?.remove();existQuery_Equal?.remove();existQuery_remove?.remove();existQuery_FindFriendList?.remove();
    }
    
    func setQuery(from: Any, to: Any) {
        // add 따라서 쿼리는 누적될 수 있다.
        if let query = existQuery{ // 이미 퀴리가 있으면 삭제
            query.remove()
        }
        // 새로운 쿼리를 설정
        let query = reference.whereField("id", isGreaterThanOrEqualTo: from).whereField("id", isLessThanOrEqualTo: to)

        existQuery = query.addSnapshotListener(onChangingData)
    }
    
    func setQuery_equal( to: Any) {
        // add 따라서 쿼리는 누적될 수 있다.
        if let query = existQuery_Equal{ // 이미 퀴리가 있으면 삭제
            query.remove()
        }
        // 새로운 쿼리를 설정
        let query = reference.whereField("id",isEqualTo: to)

        existQuery_Equal = query.addSnapshotListener(onChangingData)
    }
    
    
    func setQuery_Remove(to: Any, which_field: String) {
        // 아래에서 볼수 있지만 퀴리는 add된다. 따라서 쿼리는 누적될 수 있다.
        if let query = existQuery_remove{ // 이미 퀴리가 있으면 삭제한다
            query.remove()
        }
        // 새로운 쿼리를 설정한다. 원하는 필드, 원하는 데이터를 적절히 설정하면 된다
        let query = reference.whereField("id", isEqualTo: to).whereField("Share_flight", isGreaterThan: 0)
        // 쿼리를 set하는 것이 아니라 add한다는 것을 알아야 한다.
        // query를 만족하는 데이터가 발생하면 onChangingData()함수를 호출하라는 것임
        existQuery_remove = query.addSnapshotListener(onChangingData)
    }
    
    func setQuery_key(from: Any, to: Any, Key:String) {
        
        
        
        // 아래에서 볼수 있지만 퀴리는 add된다. 따라서 쿼리는 누적될 수 있다.
        if let query = existQuery_key{
            // 이미 퀴리가 있으면 삭제한다
            query.remove()
        }
        // 새로운 쿼리를 설정한다. 원하는 필드, 원하는 데이터를 적절히 설정하면 된다
        let query = reference.whereField(Key, isGreaterThanOrEqualTo: from).whereField(Key, isLessThanOrEqualTo: to)
       
        // 쿼리를 set하는 것이 아니라 add한다는 것을 알아야 한다.
        // query를 만족하는 데이터가 발생하면 onChangingData()함수를 호출하라는 것임
        existQuery_key = query.addSnapshotListener(onChangingData)
    }
    
    func setQuery_FindFriendList( friendList : [String] ,key:String){
        
        if let query = existQuery_FindFriendList {
            // 이미 퀴리가 있으면 삭제한다
            query.remove()
        }
        
  
        
        
        let query =   reference.whereField("id", in: friendList)
        existQuery_FindFriendList = query.addSnapshotListener(onChangingData)
        
    }
    
    func setQuery_SharedLIst( to: Any) {
        // add 따라서 쿼리는 누적될 수 있다.
        if let query = existQuery_shareList{ // 이미 퀴리가 있으면 삭제
            query.remove()
        }
        // 새로운 쿼리를 설정
        let query = reference_shareList.whereField("id",isEqualTo: to)
        print(query)
        existQuery_shareList = query.addSnapshotListener(onChangingData)
        
    }
}
