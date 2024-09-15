//
//  ViewController.swift
//  FlightInfoWithAi
//
//  Created by ㅇㅇ ㅇ on 5/22/24.
//

import UIKit

class FlightOfferViewController: UIViewController {
    
    // 이 뷰컨트롤러는 모든 뷰가 코드로 되어 있습니다.
    var loginUser : Account!
  //  var loginView : LoginViewController!
    var selected : IndexPath?
    var tableView : UITableView?
    var flightbase : flightForFIrebase?
   // var user : Account!
    var dbManager_offer : DbFirebase?
  var flightBookingData: FlightBookingData?
    
    
    var oneWay = false // trigger
    var destination : String?
    
    
    
    
    @IBOutlet weak var tabBarr: UITabBarItem!
    
    
  var searchResultsFlights: [FlightBookingData.FlightDetails] = []
    
    var User_flightList : [flightForFIrebase]?
    
    //computed property
    // 검색이후 에러 처리부 사용자의 요청이 에러가 있어서 api에서 정보를 못가져올때 호출되는 클로져입니다.
    private lazy var onError: (String) -> Void = { [weak self] errorDescription in
        guard let self = self else { return }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "데이터를 찾을 수 없습니다. :\n\n\(errorDescription)\n\n 다시 시도해 주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                //TODO 로딩화면 구현
            }))
            self.present(alert, animated: true)
        }
    }
    // onSearchTapped는 사용자가 정보를 입력하고 항공권 검색 버튼을 클릭할때 호출되는 클로져입니다.
    
    private lazy var onSearchTapped: (GetFlightOffersBody) -> Void = { [weak self] flightOffersBody in
        guard let self = self else { return }
        print("@@@@@@YHS SEarch Button Tapped@@@@@@")
        let count = flightOffersBody.originDestinations.count
        guard count >= 1,
              flightOffersBody.travelers >= 1
        else {
            self.onMissingFieldError()
            // TODO1 로딩 화면 구현
            return
        }
        if count<=1 {self.oneWay = true}
        
        
        self.destination = flightOffersBody.originDestinations.first?.destinationLocationCode
        
        //requestTestAmadeusAPI(url: "/Users/yhs/Desktop/FreeXcode/IOS-Uikit/programs24-1/FlightInfoTermProject 2/FlightInfoTermProject/Test1.json",offer: flightOffersBody)
        
        requestAmadeusAPI(flightOffersBody: flightOffersBody)
       
        
    }
    // api에 요청하는 함수입니다.
    func requestAmadeusAPI(flightOffersBody: GetFlightOffersBody)
    {
        
        // COnstant의 getFlightsRequest 함수에 대해서는 좀 있다가 설명드리겠습니다.
    Constants.getFlightsRequest(
        for: flightOffersBody,
        completion: { flightOffers in
            print("error################# in getFlightRequest completion")
            DispatchQueue.main.async {
                print("error################# in getFlightRequest completion");
                self.flightBookingData?.flights = flightOffers
                self.flightBookingData = .init(
                    getFlightOffersBody: flightOffersBody, flights: flightOffers)
                // // TODO3 로딩 화면 구현
                
                self.homeTableView.reloadData()
            }
        }, onError: onError)}
    
    // test API
    func requestTestAmadeusAPI(url: String , offer : GetFlightOffersBody){
       
        guard let jsonString = try? String(contentsOfFile:"/Users/yhs/Desktop/FreeXcode/IOS-Uikit/programs24-1/FlightInfoTermProject 2/FlightInfoTermProject/Test1.json" ) else {
            print("YHS@@@@@@@@@JsonStringPathError@@@@@@@@@@@@@@@@@")
            return
        }
        guard let data2 = jsonString.data(using: .utf8)else{return;}
        let decoder = JSONDecoder()
        do {
            let responseBody = try decoder.decode(FlightBookingData.FlightOffersResponse.self, from:   data2)
            
            print("YHS@@@@@@@@@@\(responseBody.data.first?.numberOfBookableSeats))")
            self.flightBookingData?.flights = responseBody.data
            self.flightBookingData = .init(
                getFlightOffersBody: offer, flights: responseBody.data)
            self.searchResultsFlights = responseBody.data
            
            self.homeTableView.reloadData()
        } catch let error {
            onError(error.localizedDescription)
            print("YHS @@@@@@@@@@@@@@ \(error.localizedDescription)  $$$$$$")
        }
    }
    //레이아웃 설정입니다.
    private lazy var homeTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.keyboardDismissMode = .interactive
        tv.separatorStyle = .none
        
        tv.register(SearchDetailsCell.self, forCellReuseIdentifier: SearchDetailsCell.reuseIdentifier)
        tv.register(FlightDetailCell.self, forCellReuseIdentifier: FlightDetailCell.reuseIdentifier)
        //tv.register(UITableViewCell.self, forCellReuseIdentifier: SearchDetailsCell.reuseIdentifier)
        //   tv.register(UITableViewCell.self, forCellReuseIdentifier: FlightDetailCell.reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    
    // viewDidLoad는 레이아웃 함수를 호출합니다.
    // viewDIdAppear에서는 현재 로그인된 유저 정보를 가져옵니다.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        setUpLayout()
        self.dbManager_offer = DbFirebase(parentNotification: self.manageDatabase(dict:dbaction:))
    self.tabBarr.isEnabled = true
        tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.loginUser = LoginUser.getLoginUser()

    }
    
    
    
    
    
    // TODO4 Tab bar?
    private func setUpLayout() {
        
        view.addSubview(homeTableView)
        setUpConstraints()
    }
    //제약조건을 설정합니다.
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            homeTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            homeTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: homeTableView.trailingAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: homeTableView.bottomAnchor,constant: 20)
           
        ])
    }
    // Functions
    // Closures
    
    func manageDatabase(dict: [String: Any]?, dbaction: DbAction?){
        switch(dbaction){
        case .add : break
            
            
            
        case .modify :
             let account = Account.fromDict(dict: dict!)
            self.self.loginUser! = account
            LoginUser.loginUserReplace(self.loginUser)
            print("@@@@@YHS@@@@@@@USESR FLIGHT OFFERVIEW")
            
            
        case .delete : break
            
        default :break
        }}
    
}
extension FlightOfferViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 + (flightBookingData?.getFlightOffersBody?.originDestinations.count ?? 1) }
    // numberOfRowsInSection
    // cellForRowAt
    // didSelectRowAt
    
    // 테이블 뷰로 구성된 플라잇 오퍼뷰 컨트롤러는 첫번쨰 섹션은 항공편 검색 테이블 셀이라서 단 하나의 셀만 존재 합니다.
    // api가 보낸 정보를 보여줄 두번재 섹션은 정보의 양만큼의 테이블 뷰를 생성합니다.

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : flightBookingData?.flights!.count ?? 1
    } /*섹션이 0이면 1을 반환하여 첫 번째 섹션(검색 폼 섹션)에 하나의 행이 있음을 알림
       다른 섹션의 경우, flightBookingData 객체에서 항공편 수 만큼
       flightBookingData?.flights가 nil이면 기본값으로 1을 반환.*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
            // 테이블 뷰의 셀은 첫번째 섹션 두번째 섹션으로 각각 나뉘어서 셀을 구성합니다.
            // 먼저 첫번째입니다.
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchDetailsCell.reuseIdentifier, for: indexPath) as? SearchDetailsCell else
            { return SearchDetailsCell() }
            
         
            for content in cell.contentView.subviews{
                content.removeFromSuperview()
                
            }
            // SearchDetailsCell의 setUpLayout 함수를 통해 구현했습니다. - 먼저설명하기
            cell.setUpLayout()
            
            for content in cell.contentView.subviews{
                content.isUserInteractionEnabled = true
            }
            cell.configure(
                tableView: tableView,
                onSearchTapped: onSearchTapped
                //onSearchTapped 클로저는 앞서 설명드렸듯. 사용자가 정보를 입력하고 항공편 조회 버튼을 클릭할때 실행됩니다.
            )
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FlightDetailCell.reuseIdentifier, for: indexPath) as? FlightDetailCell else { return UITableViewCell() }
            guard let flightBookingData = flightBookingData,let flights = flightBookingData.flights else {
                print("YHS@@@@@@@@@NOthing bookingData cell")
                return UITableViewCell() }
            searchResultsFlights = flights // 검색한 모든 여행계획을 저장 [flightDetails] 여행계획 배열들
            
            let flightDetails: FlightBookingData.FlightDetails? = flights[indexPath.row]
            
            // flightBookingData?.flights 사용자가 요청한 일정과 출발지-도착지  정보에 해당하는 여행계획들의 집합
            cell.configure(
                with: flightDetails // api가 제공한 데이터들을 FlightDetailCell을 설정하기 위한 함수에 넣습니다.
            )
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section==1){
            homeTableView.cellForRow(at: indexPath)?.accessoryType = .detailDisclosureButton
            selected = indexPath
            print(searchResultsFlights[indexPath.row].price)
          //  selectedFlightInfo(indexPath: selected!)
          //  selectedFlightInfo(indexPath: selected!)
            
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    
    // 사용자가 액세서리 버튼을 클릭하여 항공편을 공유할때 입니다.
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("YHS@@@@@@ request share go to tabel view@@@@@@@@@@@@")
        
        selectedFlightInfo(indexPath: selected!)
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
     
        
    }
    
    
    
}

extension FlightOfferViewController {
    private func onMissingFieldError() {
            let alert = UIAlertController(title: "Error", message: "데이터 입력을 전부 해주세요(*).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
    
    
    // 항공편 공유를 하고싶을때 공유할 항공편을 파이어베이스에 보내는 함수입니다.
    // 파이어베이스에 보내는 데이터들은 any속성을 허용하지 않고 배열로만 이루어져 있어야 했습니다. 따라서 flightForFIrebase 타입의 구조체로 변환해야 했습니다.
    // 출발시간과 출발 공항코드 그리고 도착 공항코드 도착시간으로 나누어져 있는 기존의 정보들을 파이어베이스로 보낼때는 시간과 공항코드로 단일화합니다.
    // 파이어베이스에 보낼 항공편은 배열로 구성되는데 배열의 첫 부분이 빈 경우가 있습니다. 이를 고려했습니다.

    func uploadShareList(_ itinerary : [FlightBookingData.Itinerary] , price : String , destination : String, oneWay: Bool){
        var firebaseSegments : [[AirportDetails]] = [[]]
//        for i in 0...itinerary.count{
//            for segment in itinerary[i].segments{
//                
//            }
//        }
        for i in itinerary {
            for segment in i.segments {
                var segmentDetails: [AirportDetails] = []
                let departure = segment.departure
                let arrival = segment.arrival
  
                if let dep = departure {
                    let depDetails = AirportDetails(iataCode: dep.iataCode, at: dep.at!)
                    
                    segmentDetails.append(depDetails)
                }
                if let arr = arrival {
                    let arrDetails = AirportDetails(iataCode: arr.iataCode!, at: arr.at!)
                    segmentDetails.append(arrDetails)
                }
                if(firebaseSegments.first == []){
                    firebaseSegments.insert(segmentDetails, at: 0)
                }else{
                    firebaseSegments.append(segmentDetails)
                }
                
                if(firebaseSegments.contains([])){
                    firebaseSegments.remove(at: firebaseSegments.index(of: [])!)
                    
                }
                
                
            }
            
            
        }
        
// 사용자가 공유를 위해 액세서리 버튼을 클릭할때 showAlert함수를 호출합니다. 이 함수의 escaping 후행클로져 내용입니다.
    // 파이어베이스에 보낼 데이터를 전송하는 부분이기도 합니다.
        
        showAlert { [weak self] tag in
              guard let self = self else { return }
            self.flightbase = flightForFIrebase(tag: tag!, price: price, segment: firebaseSegments, destination: destination, oneWay: String(self.oneWay))//,id: self.loginUser.id)
            
              
              guard let user = self.loginUser else { return }
              
            sendToFirebase(user,tag!,duplicate: "tag")

          }
   
}
    
   
}

extension FlightOfferViewController{
    //  팝업창을 보여주는 함수입니다. 후행클로져를 인자로 받습니다.
    func showAlert(_ clo : @escaping (String?)->()) {
        // AlertController 생성
        var text1 : String?
        let alertController = UIAlertController(title: "공유 하기", message: "태그를 입력하세요", preferredStyle: .alert)
        
        // 텍스트 필드 추가
        alertController.addTextField { (textField) in
            textField.placeholder = "입력"
        }
        
        // 확인 액션 추가
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            if let textField = alertController.textFields?[0], let text = textField.text {
                // 텍스트 필드의 입력값 사용
                // ok버튼을 누른다면 인자로 받은 후행클로저가 실행됩니다.
                clo(text)
            }
        }
        
        // 취소 액션 추가
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // 액션을 AlertController에 추가
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // AlertController 표시
        self.present(alertController, animated: true, completion: nil)
 
    }


    
    
    func selectedFlightInfo(indexPath : IndexPath){
        guard let user = self.self.loginUser else{return}
        print("YHS@@@@@@ second request share go to tabel view@@@@@@@@@@@@")
        
        
        if indexPath.section == 1{
            
            let price = searchResultsFlights[indexPath.row].price?.total
            //var firebaseSegments : [[AirportDetails]] = [[]]
            
            // 파이어스토어에 업로드 하기위한 함수를 호출합니다.
            let itinerary =   searchResultsFlights[indexPath.row].itineraries
            
        
            uploadShareList(itinerary,price: price!,destination: self.destination!, oneWay: self.oneWay)
            
            
            
            
            
            
            
        }
        
    }

    func errorPop(_ msg : String){
        
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            DispatchQueue.main.async{
             
               }
        }))
        self.present(alert, animated: true)
    }
    
    
    
    

    func sendToFirebase(_ user: Account, _ tagg: String , duplicate : String) {
        let docRef = self.dbManager_offer?.reference_shareList.document(user.id)
        
        docRef?.getDocument { (document, error) in
            if let error = error {
                print("Error doc: \(error)")
            } else if let document = document, document.exists {
                // Document exists, check for "ok" tag
                if let data = document.data() {
                    for (key, value) in data {
                        if let fieldData = value as? [String: Any], let tag = fieldData[duplicate] as? String {
                            if tag == tagg {
                                self.errorPop("중복된 태그입니다.")
                                return
                            }
                         
                        }else
                        {print("@@@YHS@@@@@@@@@@problem in send To Firebase@@@@@")}
                    }
                }
                
                // If no "ok" tag found, update the document
                docRef?.updateData([
                    Date().ISO8601Format(): self.flightbase!.representation
                ]) { error in
                    if let error = error {
                        print("upload error: \(error)")
                    } else {
                        print("upload complete")
                        docRef?.updateData([
                            "id": user.id
                        ])
                        print(self.flightbase!.representation)
                        print(flightForFIrebase.fromDict(self.flightbase!.representation))
                        print(self.flightbase!.toSegment())
                    }
                }
            } else {
                // Document does not exist, create it
                docRef?.setData([
                    Date().ISO8601Format(): self.flightbase!.representation
                ], merge: true) { error in
                    if let error = error {
                        print("Firebase data create error: \(error)")
                    } else {
                        print("success firebase upload")
                        docRef?.updateData([
                            "id": user.id
                        ])
                        print(self.flightbase!.representation)
                        print(flightForFIrebase.fromDict(self.flightbase!.representation))
                        print(self.flightbase!.toSegment())
                    }
                }
            }
        }
    }


    
    }
    

