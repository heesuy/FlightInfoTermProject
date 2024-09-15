/*
import UIKit
import Foundation
import EventKit
class SelectedSharedFlightViewController: UIViewController {
    
    var cities: [String] = []
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
        for i in self.flightDetails.first!.segments{
            print(i)
            print("\n")}
     
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
        let iataCode = flightDetails.first!.segments.first!.departure!.iataCode
        let iataCode2 = flightDetails.last!.segments.last!.departure!.iataCode
        var iataCode3: String? = ""
        print(flightDetails)
        if flightDetails.first?.segments.count == 4 {
            iataCode3 = flightDetails.first!.segments.first!.arrival!.iataCode
        }
        print(flightDetails.first!.segments.first!.departure!.iataCode)
        print(flightDetails.last!.segments.first!.departure!.iataCode)
        
        let apiKey = "FD7G9sN3ACUFmekTVEs2Vw==NwOBP9ViQoE33FIN"
        
        fetchCityNameFromIATA(iataCode: iataCode, apiKey: apiKey) { cityName in
            if let cityName = cityName {
                self.cities.append(cityName)
                print("도시 이름:", cityName)
                self.fetchCityNameFromIATA(iataCode: iataCode2, apiKey: apiKey, completion: { city in
                    if let city = city {
                        self.cities.append(city)
                        if self.flightDetails.first?.segments.count == 4 {
                            self.fetchCityNameFromIATA(iataCode: iataCode3!, apiKey: apiKey) {
                                if let city = $0 {
                                    print("도시 이름:", city)
                                    self.cities.append(city)
                                    
                                    self.cities = self.cities.filter { $0 != "" }
                                    DispatchQueue.main.async {
                                        self.performSegue(withIdentifier: "goToMap", sender: nil)
                                    }
                                } else {
                                    print("세번째 도시이름 없음 \(iataCode3!)")
                                }
                            }
                        } else {
                            self.cities = self.cities.filter { $0 != "" }
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "goToMap", sender: nil)
                            }
                        }
                    } else {
                        print("도시 이름 없음")
                    }
                })
            } else {
                print("도시 이름을 가져올 수 없습니다.")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let map = segue.destination as! MapViewController
        print(flightDetails.first!.segments.first!.departure!.iataCode)
        print(flightDetails.last!.segments.first!.departure!.iataCode)
        map.cityNames = self.cities
    }
    
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
                print("Error:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            do {
                let airports = try JSONDecoder().decode([Airport].self, from: data)
                if let city = airports.first?.city {
                    completion(city)
                } else {
                    print("City name not found in the response")
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON:", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
    
    struct Airport: Codable {
        let city: String
    }
    
}
*/
