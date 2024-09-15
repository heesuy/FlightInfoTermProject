import UIKit
import EventKit
class SelectedSharedFlightViewController: UIViewController {
    
    
    // 선택된 공유게시글 즉 항공정보를 보여줄 컨트롤입니다.
    var cities: [String] = []
    var citiesIATA : [String] = []
    var flightDetails: [FlightBookingData.Itinerary]!
    var price: String!
    
    
    private lazy var summaryTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.separatorStyle = .none
        tv.register(FlightDetailCell.self, forCellReuseIdentifier: FlightDetailCell.reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .systemBackground
        return footerView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your selection"
        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setUpLayout() {
        self.view.addSubview(summaryTableView)
        self.view.addSubview(footerView)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            summaryTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            summaryTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: summaryTableView.trailingAnchor),
            footerView.topAnchor.constraint(equalTo: summaryTableView.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60),
            footerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)
        ])
    }
}

extension SelectedSharedFlightViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let flightDetails = flightDetails,
              let cell = tableView.dequeueReusableCell(withIdentifier: FlightDetailCell.reuseIdentifier, for: indexPath) as? FlightDetailCell
        else { return UITableViewCell() }
        cell.configure(with: self.flightDetails, self.price)
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 테이블 뷰가 선택되면 도시 이름을 찾습니다.
        // 도시 이름 배열들을 맵뷰에 보낼거고 배열의 첫번째와 두번째가 각각 출발지와 목적지입니다.
        findCityName()
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let map = segue.destination as! MapViewController
        print(flightDetails.first!.segments.first!.departure!.iataCode)
        print(flightDetails.last!.segments.first!.departure!.iataCode)
        map.cityNames = self.cities
    }
    
  
    struct Airport: Codable {
        let city: String
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
            storeAtCalendar()
      
        }
    

    
    // 도시이름을 찾기 위해선 항공편 정보를 꺼내와야합니다.
    // 항공편 정보에 저장된 IATA코드(공항코드)를 가져오는 함수입니다.
    
    func findCityName(){
        let iataCode = flightDetails.first!.segments.first!.departure!.iataCode
        var iataCode2 : String?
        print(flightDetails.last?.segments)
        print("count is ")
        print(flightDetails.last?.segments.count)
        
        if((flightDetails.last?.segments.count)!%2 == 0){
            var mid = flightDetails.last!.segments.count/2
            iataCode2 = flightDetails.last!.segments[mid-1].arrival!.iataCode!}
        for i in flightDetails{
            var cnt = 0
            var cnt2 = 0
            for j in i.segments {
                
                var arrival = j.arrival!.iataCode
                var departure = j.departure!.iataCode
                print("@@@\(i.segments.count)")
                citiesIATA.append(departure)
                citiesIATA.append(departure)
                
                print("select tableView")
                print(departure)
                print(arrival)
            }
            
            // 도시 이름을 알려줄 공항정보 즉 IATA코드를 가져올때 순서가 변동되는 경우가 있습니다.
            // 순서가 바뀌면 목적지와 출발지도 바뀌므로 이를 막아줘야합니다.
            if((flightDetails.count>1)&&(cnt==0)){
               
                if(cnt2 == 0){
                    print("flightDetails[0]")
                    // 데이터 구조상 flightDetails[0].segments는 목적지를 나타내게 되어있습니다.
                    //flightDetails[0].segments를 citiesIATA배열의 두번째에 강제로 넣기위해 swap과 insert를 이용합니다.
                    print(flightDetails[0].segments.last!.arrival!.iataCode)
                            var a = flightDetails[0].segments.last!.arrival!.iataCode
                    if(citiesIATA.contains(a!)){
                        print(i.segments.last!.arrival!.iataCode)
                        citiesIATA.swapAt(citiesIATA.firstIndex(of: a!)!,1)}
                    else{
                        
                        if(citiesIATA.count>1){
                            citiesIATA.insert(a!,at:1)}
                        
                    }}
                cnt2 += 1
            }
            cnt += 1

            
            
        }
        
        
    
        print("this is \(citiesIATA)")
        self.citiesIATA = self.removeDuplicate(citiesIATA)

        print("@@@@\(iataCode2)")

        var iataCode3: String? = ""
        print(flightDetails)
     
        
        
        print(flightDetails.first!.segments.first!.departure!.iataCode)
        print(flightDetails.last!.segments.first!.departure!.iataCode)
        
        // IATA정보들이 다 모이면 IATA정보를 통해 도시 이름을 찾아오는 함수를 호출합니다.
        requestForFindCityName()
    
        
    }
    
    // api에 iata코드를 통해 도시 이름을 가져오는 함수입니다. 후행클로져를 사용했습니다.
    func requestForFindCityName(){
        let apiKey = "FD7G9sN3ACUFmekTVEs2Vw==NwOBP9ViQoE33FIN"
        
        // 왕복인 경우 편도인 경우를 구분하였습니다. 편도인 경우 도시이름은 2개가 최대입니다.
        fetchCityNameFromIATA(iataCode: citiesIATA[0], apiKey: apiKey) { [self] cityName in
            if let cityName = cityName {
                print("도시  \(self.citiesIATA)\n")

                self.cities.append(cityName)
                print("도시 이름:", cityName)
                self.fetchCityNameFromIATA(iataCode: citiesIATA[1], apiKey: apiKey, completion: { city in
                    if let city = city {
                        self.cities.append(city)
                        
                        //경유인 경우입니다. 3번째 인덱스부터 IATA배열의 마지막 인덱스까지 반복하여서 병렬 쓰레드에 넣어  api에 도시이름을 가져옵니다.
                        if self.citiesIATA.count >= 3 {
                            let concurrentQueue = DispatchQueue(label: "forIATA", attributes: .concurrent)
                            
                            
                            
                            for i in 2..<self.citiesIATA.count {
                                concurrentQueue.async {
                                    self.fetchCityNameFromIATA(iataCode: citiesIATA[i], apiKey: apiKey, completion: { city in
                                        guard let city = city else {
                                            print("도시가져오기 실패 \(i) 번째 \(self.citiesIATA[i])")
                                            return
                                        }
                                        print("도시  \(i) 번째 \(self.citiesIATA[i])")
                                        self.cities.append(city)
                                        self.cities = self.cities.filter { $0 != "" }
                                        if(i == self.citiesIATA.count-1){
                                            print("도시 집합 최종 \(self.cities)")
                                                  print("도시 집합 최종IATA \(self.citiesIATA)")
                                            // 마지막 도시에 대한 요청 이후에 perform Segue를 하는데 이 경우 마지막 도시에 대한 이름의 결과를 가져오기 전에 이동합니다. 그래서 Thread.sleep으로  2초정도 잠재웁니다.
                                            DispatchQueue.main.async {
                                                Thread.sleep(forTimeInterval: 2)
                                                self.performSegue(withIdentifier: "goToMap", sender: nil)
                                            }
                                        }
                                    })
                                }
                                
                            }
                        }
                        else {
                            self.cities = self.cities.filter { $0 != "" }
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "goToMap", sender: nil)
                            }
                        }
                    } else {
                        print("두번째 도시 이름 없음")
                    }
                })
            } else {
                print("도시 이름을 가져올 수 없음.")
            }
        }
    }
    // api에 직접적으로 http 요청을 하는 함수입니다. 뒤에 escaping 후행클로져가 있습니다
    func fetchCityNameFromIATA(iataCode: String, apiKey: String, completion: @escaping (String?) -> Void) {
        let apiUrl = "https://api.api-ninjas.com/v1/airports"
        
        var components = URLComponents(string: apiUrl)!
        components.queryItems = [
            URLQueryItem(name: "iata", value: iataCode)
        ]
        
        var request = URLRequest(url: components.url!)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error:", error?.localizedDescription ?? "error in ninja")
                completion(nil)
                return
            }
            
            do {
                let airports = try JSONDecoder().decode([Airport].self, from: data)
                if let city = airports.first?.city {
                    completion(city)
                } else {
                    print("can't find city name ")
                    completion(nil)
                }
            } catch {
                print("ErrorJson:", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }

    // 달력에 저장하는 함수입니다.
    func storeAtCalendar(){
        
        print("storeAtcalendar")
        guard let flightDetails = flightDetails else { return }
        let iataCode = flightDetails.first!.segments.first!
        let iataCode2 = flightDetails[0].segments.last!
        
        
        print("segement last")
        print(flightDetails[0].segments.last!)
        
      
       // let selectedFlight = flightDetails[indexPath.row]
        
       
        let eventTitle = "여정 \(iataCode.departure!.iataCode) to \(iataCode2.arrival!.iataCode!)"
        
        
        // 이벤트의 시작과 종료 시간
        let eventStartDate = iataCode.departure!.at!
        let eventEndDate = flightDetails.last!.segments.last!.arrival!.at
        
        // 캘린더 이벤트 객체를 생성
        let eventStore = EKEventStore()
        
        // 캘린더 접근 권한 요청
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && error == nil {
                let event = EKEvent(eventStore: eventStore)
                event.title = eventTitle
                event.startDate = eventStartDate
                event.endDate = eventEndDate
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                               try eventStore.save(event, span: .thisEvent, commit: true)
                           } catch {
                               print("Error in calendar : \(error.localizedDescription)")
                           }
                DispatchQueue.main.async{  let alert = UIAlertController(title: "알림", message: eventTitle + " 일정이 추가됨", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: true)
                }
                       } else {
                           print("캘린더 접근 권한이 거부")
                       }
             
            }
        
    }
    
    
     func removeDuplicate (_ array: [String]) -> [String] {
         var removedArray = [String]()
         for i in array {
             if removedArray.contains(i) == false {
                 removedArray.append(i)
             }
         }
         print(removedArray)
         return removedArray
     }
    }
    
    
    
    
   
