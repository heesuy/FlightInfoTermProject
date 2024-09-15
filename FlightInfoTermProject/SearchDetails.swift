
//
//  SearchDetails.swift
//  FlightInfoWithAi
//
//  Created by ㅇㅇ ㅇ on 5/23/24.
//


import Foundation
import UIKit


final class SearchDetailsCell: UITableViewCell {
    
    
    var tableView: UITableView?
    var onSearchTapped: ((GetFlightOffersBody)->Void)? 
    static let reuseIdentifier = "SearchDetailsCell"
    private lazy var verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
   
        return sv
    }()
   
    // 첫번째 섹션은 서치 디테일즈 셀인데요 이 초기화자에서 레이아웃을 꾸며주며 시작합니다.

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUpLayout()
        // Additional functions
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //private였음
    func setUpLayout() {

        contentView.addSubview(verticalStackView)
        
        // Add additional views
        //complete
        
        // here!
        //originLocation
        verticalStackView.addArrangedSubview(originLocationStackView)
        originLocationStackView.addArrangedSubview(originLocationTitleLabel)
        originLocationStackView.addArrangedSubview(originLocationTextField)
        originLocationTextField.addSubview(originLocationTextFieldOptions)
        //아래처럼수정
        //originLocationStackView.addArrangedSubview(originLocationTextFieldOptions)
        
        
        //destination
        verticalStackView.addArrangedSubview(destinationLocationStackView)
        destinationLocationStackView.addArrangedSubview(destinationLocationTitleLabel)
        destinationLocationStackView.addArrangedSubview(destinationLocationTextField)
        destinationLocationTextField.addSubview(destinationLocationTextFieldOptions)

        
        
        
        
        // departure
        verticalStackView.addArrangedSubview(departureDateStackView)
        departureDateStackView.addArrangedSubview(departureDateTitleLabel)
        departureDateStackView.addArrangedSubview(departureDatePicker)
        
        //returnDate
        verticalStackView.addArrangedSubview(returnDateStackView)
        returnDateStackView.addArrangedSubview(returnDateTitleLabel)
        returnDateStackView.addArrangedSubview(returnDatePicker)
        returnDateStackView.addArrangedSubview(oneWayTitleLabel)
        returnDateStackView.addArrangedSubview(oneWayToggle)
        
        //adults(travelor)
        verticalStackView.addArrangedSubview(adultsStackView)
        adultsStackView.addArrangedSubview(adultsTitleLabel)
        adultsStackView.addArrangedSubview(adultsTextField)
        adultsStackView.addArrangedSubview(adultsTextFieldOptions)
        
        
        // SearchButton
        verticalStackView.addArrangedSubview(searchButton)
        
        
        setUpConstraints()
        self.searchButton.isUserInteractionEnabled=false
    }
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            verticalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.contentView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: 20),
            self.contentView.bottomAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 20),
            // Additional constraints
            //complete
            //origin
            
            originLocationStackView.heightAnchor.constraint(equalToConstant: 30),
            originLocationTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            
             originLocationTextFieldOptions.topAnchor.constraint(equalTo: originLocationTextField.topAnchor),
 
            originLocationTextFieldOptions.leadingAnchor.constraint(equalTo: originLocationTextField.leadingAnchor),
           originLocationTextField.trailingAnchor.constraint(equalTo: originLocationTextFieldOptions.trailingAnchor),
            

            originLocationTextField.bottomAnchor.constraint(equalTo: originLocationTextFieldOptions.bottomAnchor),

    
            
            
           destinationLocationStackView.heightAnchor.constraint(equalToConstant: 30),
            destinationLocationTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            destinationLocationTextFieldOptions.topAnchor.constraint(equalTo: destinationLocationTextField.topAnchor),
            destinationLocationTextFieldOptions.leadingAnchor.constraint(equalTo: destinationLocationTextField.leadingAnchor),
            destinationLocationTextField.trailingAnchor.constraint(equalTo: destinationLocationTextFieldOptions.trailingAnchor),
            destinationLocationTextField.bottomAnchor.constraint(equalTo: destinationLocationTextFieldOptions.bottomAnchor),
            
            //departure and return
           departureDateStackView.heightAnchor.constraint(equalToConstant: 30),
            departureDateTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            
            returnDateStackView.heightAnchor.constraint(equalToConstant: 30),
            returnDateTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            
            
            // adults(traveler)
            adultsStackView.heightAnchor.constraint(equalToConstant: 30),
            adultsTitleLabel.widthAnchor.constraint(equalToConstant: 125),
            adultsTextFieldOptions.topAnchor.constraint(equalTo: adultsTextField.topAnchor),
            adultsTextFieldOptions.leadingAnchor.constraint(equalTo: adultsTextField.leadingAnchor),
            adultsTextField.trailingAnchor.constraint(equalTo: adultsTextFieldOptions.trailingAnchor),
            adultsTextField.bottomAnchor.constraint(equalTo: adultsTextFieldOptions.bottomAnchor),
            
        ])
    }
    // 각 버튼은 지연초기화 되며 초기 속성을 설정합니다.
    
    // originLocation
    private lazy var originLocationStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 10
        return sv
    }()
    private lazy var originLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "From:*"
        label.numberOfLines = 1
        return label
    }()
    private lazy var originLocationTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Origin..."
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    
    
    private lazy var originLocationTextFieldOptions: UIButton = {
        let tf = UIButton(configuration: .borderless())
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.menu = UIMenu(children: AvailableLocations.allCases.map({ location in
            UIAction(title: location.rawValue, handler: { _ in
                self.originLocationTextField.text = location.rawValue
                // Handle search button
                // complete
            
                // wait next when construct api
            })
        }))
        tf.showsMenuAsPrimaryAction = true
        //tf.isHidden = false
        tf.backgroundColor  = .white
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    //destinationLocationTextField
    
    private lazy var destinationLocationStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 10
        return sv
    }()
    private lazy var destinationLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "To:*"
        label.numberOfLines = 1
        return label
    }()
    private lazy var destinationLocationTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Dest..."
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    private lazy var destinationLocationTextFieldOptions: UIButton = {
        let tf = UIButton(configuration: .borderless())
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.menu = UIMenu(children: AvailableLocations.allCases.map({ location in
            UIAction(title: location.rawValue, handler: { _ in
                self.destinationLocationTextField.text = location.rawValue
                // Handle search button
             
            })
        }))
        tf.showsMenuAsPrimaryAction = true
        tf.isUserInteractionEnabled = true
        
        //추가
        tf.isEnabled = true
        
        
        return tf
    }()
    
    
    
    // departureInfo
    private lazy var departureDateStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    private lazy var departureDateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Departure:*"
        label.numberOfLines = 1
        return label
    }()
    private lazy var departureDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .compact
        picker.minimumDate = .now
        picker.datePickerMode = .date
        picker.contentHorizontalAlignment = .leading
        return picker
    }()
    
    
    private lazy var returnDateStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    private lazy var returnDateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Return:"
        label.numberOfLines = 1
        return label
    }()
    private lazy var returnDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .automatic
        picker.minimumDate = departureDatePicker.date
        picker.datePickerMode = .date
        picker.contentHorizontalAlignment = .leading
        picker.alpha = 0
        return picker
    }()
    
    private lazy var oneWayTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "One\nway"
        label.numberOfLines = 2
        return label
    }()
    
    // 편도와 왕복을 나누는 토글 버튼 초기화입니다.
    private lazy var oneWayToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(didTapOneWayToggle(sender:)), for: .touchUpInside)
      // 아래는 추가함
        toggle.isUserInteractionEnabled = true
        return toggle
    }()
    
    
    
    
    
  
    private lazy var adultsStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    private lazy var adultsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Passengers:*"
        label.numberOfLines = 1
        return label
    }()
    private lazy var adultsTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Number of adults..."
        tf.keyboardType = .numberPad
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return tf
    }()
    private lazy var adultsTextFieldOptions: UIButton = {
        let tf = UIButton(configuration: .borderless())
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.menu = UIMenu(children: (0...10).map({ number in
            UIAction(title: "\(number)", handler: { _ in
                self.adultsTextField.text = String(number)
                // adultsTextFieldOptions 은 인원수를 입력하는 뷰이고 미자막 입력뷰입니다. 사용자가 모든 정보를 입력한 경우                 self.isSearchButtonEnabled()함수를 호출합니다.
                self.isSearchButtonEnabled()
            })
        }))
        tf.showsMenuAsPrimaryAction = true
        tf.isUserInteractionEnabled = true
        return tf
    }()
    
    // search BUtton
    private lazy var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Search", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(didTapSearchButton(sender:)), for: .touchUpInside)
        button.alpha = 0.2
        return button
    }()
    
    // 사용자가 모든 정보를 입력하면 이 함수가 호출되어서 항공편 조회 버튼의 alpha값을 변경하고 검색 버튼이 활성화 됩니다.
    private func isSearchButtonEnabled() {
        let isEnabled = originLocationTextField.text != ""&&originLocationTextField.text != "Origin..."&&originLocationTextField.text != nil && destinationLocationTextField.text != "" && destinationLocationTextField.text != nil&&destinationLocationTextField.text != "Dest..."&&adultsTextField.text != ""&&adultsTextField.text != nil&&adultsTextField.text != "0"
        switch isEnabled {
        case true:
            searchButton.alpha = 1
            searchButton.isUserInteractionEnabled = true
        case false:
            searchButton.alpha = 0.5
            searchButton.isUserInteractionEnabled = false
        }
    }
    
    
    
    
    
    // 코드로된 뷰들을 초기화할때 부르는 함수입니다.
    func configure(
        tableView: UITableView,
        onSearchTapped: ((GetFlightOffersBody)->Void)?
    ) {
        self.tableView = tableView
        self.onSearchTapped = onSearchTapped
        if let contentView = tableView.visibleCells.first?.contentView {
            for i in contentView.subviews{
                self.tableView?.bringSubviewToFront(i)
            }
        }
        print("YHS originLocationTextFieldOptions isUserInteractionEnabled: \(originLocationTextFieldOptions.isUserInteractionEnabled)")
        print("YHS originLocationTextFieldOptions isHidden: \(originLocationTextFieldOptions.isHidden)")

        print("YHS destinationLocationTextFieldOptions isUserInteractionEnabled: \(destinationLocationTextFieldOptions.isUserInteractionEnabled)")
        print("YHS destinationLocationTextFieldOptions isHidden: \(destinationLocationTextFieldOptions.isHidden)")
    }
    
    
    
    
    
    
    
    
    
    
    
    // 검색 버튼을 클릭할때 호출되는 함수입니다. 사용자가 입력한 정보를 api가 요구하는 데이터 모델에 넣습니다.
    @objc private func didTapSearchButton(sender: UIButton) {
      //  let oriDes : OriginDestination
      
        guard let originLocation = originLocationTextField.text,
              let originLocationCode = originLocation.split(separator: " - ").first?.uppercased(),
              let destinationLocation = destinationLocationTextField.text,
              let destinationLocationCode = destinationLocation.split(separator: " - ").first?.uppercased(),
              let passengers = adultsTextField.text, passengers != ""
        
              
        else { return }

        guard let travelers_toInt = Int(passengers) else{return}
       
        let departureT = departureDatePicker.date.ISO8601Format()
      
        //편도/왕복을 나누는 oneWayToggle 속성에 따라 분기합니다.
        if oneWayToggle.isOn == true{
            
           
            let oriDest = OriginDestination( id : "1", originLocationCode: originLocationCode, destinationLocationCode: destinationLocationCode, departureDateTimeRange: DateTimeRange(date: departureT))
            var origins = [oriDest]
            var getFli =  GetFlightOffersBody(travelers: travelers_toInt, originDestinations: origins)
        getFli.originDestinations.append(oriDest)
            self.onSearchTapped!(getFli)
        }
        else{
            let returnT = returnDatePicker.date.ISO8601Format()
            let oriDest = OriginDestination(id : "1", originLocationCode: originLocationCode, destinationLocationCode: destinationLocationCode, departureDateTimeRange: DateTimeRange(date: departureT),returnDateTimeRange: DateTimeRange(date: returnT))
            var origins = [oriDest]
            var getFli =  GetFlightOffersBody(travelers: travelers_toInt, originDestinations: origins)
        getFli.originDestinations.append(oriDest)
            self.onSearchTapped!(getFli)
            // GetFlightOffersBody()
        }
        
        // Handle flight search
    }
    
    @objc private func didTapOneWayToggle(sender: UIButton) {
        returnDatePicker.alpha = oneWayToggle.isOn ? 0 : 1
        returnDatePicker.isUserInteractionEnabled = !oneWayToggle.isOn
    }
    
    
    
    
  
}

