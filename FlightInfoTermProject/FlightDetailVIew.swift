//
//  FlightDetailVIew.swift
//  FlightInfoWithAi
//
//  Created by ㅇㅇ ㅇ on 5/23/24.
//

import Foundation
import UIKit

// segment airport
final class SegmentDetailView: UIView {
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
    sv.translatesAutoresizingMaskIntoConstraints = false
    sv.axis = .horizontal
    sv.distribution = .fillProportionally
        sv.spacing = 16
return sv
    }()
    private lazy var firstLabel: UILabel = {
        let l = UILabel()
           l.translatesAutoresizingMaskIntoConstraints = false
           l.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        l.textColor = .label
        return l
    }()
    private lazy var secondLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
          l.font = UIFont.systemFont(ofSize: 16, weight: .medium)
          l.textColor = .label
        l.textAlignment = .left
        return l
    }()
    private lazy var thirdLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .label
        l.textAlignment = .right
        l.text = nil
        return l
    }()
    
    //주석처리 품
  
     var airportDetails: AirportDetails? { didSet { didUpdateAirportDetails() } }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpLayout() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(firstLabel)
        stackView.addArrangedSubview(secondLabel)
        stackView.addArrangedSubview(thirdLabel)
        setUpConstraints()
    }
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            firstLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    // 주석처리 품 // 여기 일단 아무거나 막 넣어서 테스트해보기! airport쪽
    private func didUpdateAirportDetails() {
        guard let airportDetails = airportDetails else { return }
        self.firstLabel.text = airportDetails.iataCode
        self.secondLabel.text = airportDetails.at.ISO8601Format()
        if let thirdLabelText = airportDetails.terminal { self.thirdLabel.text = "Terminal \(thirdLabelText)" }
        self.thirdLabel.isHidden = airportDetails.terminal == nil
    }
}

// segemet departure
final class SegmentView: UIView {
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    private lazy var segmentDepartureView: SegmentDetailView = {
        let view = SegmentDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var segmentArrivalView: SegmentDetailView = {
        let view = SegmentDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //주석처리 품
     var segmentDetails: /*SegmentDetails*/FlightBookingData.Segment? { didSet { didUpdateSegmentDetails() } }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpLayout() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(segmentDepartureView)
        stackView.addArrangedSubview(segmentArrivalView)
        setUpConstraints()
    }
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
    //주석처리 품
    private func didUpdateSegmentDetails() {

        guard let segmentDetails = segmentDetails else { return }
        segmentDepartureView.airportDetails = AirportDetails(iataCode:segmentDetails.departure!.iataCode, terminal:segmentDetails.departure?.terminal,at:segmentDetails.departure!.at!)
        segmentArrivalView.airportDetails = AirportDetails(iataCode:segmentDetails.arrival!.iataCode!,at:segmentDetails.arrival!.at!)

    }
}


final class FlightInformationView: UIView {
    
    
    var airportDetail_edit : AirportDetails!
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        l.textColor = .label
        l.textAlignment = .left
        return l
    }()
    private lazy var firstSegmentView: SegmentView = {
        let view = SegmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var firstLayoverLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        return l
    }()
    private lazy var secondSegmentView: SegmentView = {
        let view = SegmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var secondLayoverLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        return l
    }()
    private lazy var thirdSegmentView: SegmentView = {
        let view = SegmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var thirdLayoverLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        return l
    }()
    private lazy var fourthSegmentView: SegmentView = {
        let view = SegmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var segmentViews = [firstSegmentView, secondSegmentView, thirdSegmentView, fourthSegmentView] // segementDetails배열
    lazy var layoverViews = [firstLayoverLabel, secondLayoverLabel, thirdLayoverLabel]
    var title: String = "" { didSet { didUpdateTitle() } }
    
    //segemnts의 원소는 icn-sgn,sgn-bkk segement는 원소들을 다 합친것!
    var segments: [/*SegmentDetails*/FlightBookingData.Segment]? { didSet { didUpdateSegments() } }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpLayout() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(firstSegmentView)
        stackView.addArrangedSubview(firstLayoverLabel)
        stackView.addArrangedSubview(secondSegmentView)
        stackView.addArrangedSubview(secondLayoverLabel)
        stackView.addArrangedSubview(thirdSegmentView)
        stackView.addArrangedSubview(thirdLayoverLabel)
        stackView.addArrangedSubview(fourthSegmentView)
        setUpConstraints()
    }
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    private func didUpdateTitle() {
        titleLabel.text = title
    }
    
    private func didUpdateSegments() {
// 세그먼트는? flightDetails.itineraries[0].segements api가 제공한 데이터.여정정보 0 번째.거기의 정보들 segments는 [segementDetails] 속성
        guard let segments = segments else { return }

            //for이 pop한 것들은 icn-bkk 같은 부류
        for (index, segment) in segments.enumerated() where index < 4 {
//segement는 segments (segementDetails)의 원소들이고 이 원소들을 하나씩 끄집어냄
            segmentViews[index].segmentDetails = segment
            segmentViews[index].isHidden = false
            if index < segments.count-1 {
                let departure =  segments[index+1].departure!.at!
                let arrival = segment.arrival!.at! // 원소의  도착 시점
               /*  airportDetail_edit = AirportDetails(iataCode: segment.arrival.iataCode,terminal: nil ,at: segment.arrival.at)*/
                let difference = Calendar.current.dateComponents([.hour, .minute], from: arrival, to: departure)
                layoverViews[index].text = "layover \(difference.hour ?? 0) hrs \(difference.minute ?? 0) mins"
            } else {
                layoverViews[index].text = nil
            }

        }

        for index in 0..<(segmentViews.count-segments.count) {

            segmentViews.reversed()[index].isHidden = true
            // 아직 업데이트 안된것 hidden

        }

    }
    
    
 func convertToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: dateString)
    }
}



final class FlightDetailCell: UITableViewCell {
    
    var flightDetails: FlightBookingData.FlightDetails?
       
    static let reuseIdentifier = "FlightDetailCell"
    private lazy var noFlightsFoundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    private lazy var noFlightsFoundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No flights found."
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    private lazy var containerVerticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    
    // 뷰들의 속성을 초기화 합니다.
    private lazy var flightInformationView: FlightInformationView = {
        let view = FlightInformationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title = "🛫 Departing flight"
        return view
    }()
    private lazy var returnFlightInformationView: FlightInformationView = {
        let view = FlightInformationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.title = "🛬 Returning flight"
        return view
    }()
    private lazy var priceHorizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        return sv
    }()
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Total"
        label.textAlignment = .right
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    private lazy var paddingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    private lazy var separatorContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    // Add flight details variable
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpLayout() {
        contentView.addSubview(containerVerticalStackView)
        containerVerticalStackView.addArrangedSubview(flightInformationView)
        containerVerticalStackView.addArrangedSubview(returnFlightInformationView)
        containerVerticalStackView.addArrangedSubview(paddingView)
        containerVerticalStackView.addArrangedSubview(priceHorizontalStackView)
        
        priceHorizontalStackView.addArrangedSubview(totalLabel)
        priceHorizontalStackView.addArrangedSubview(priceLabel)
        
        containerVerticalStackView.addArrangedSubview(separatorContainerView)
        
        separatorContainerView.addSubview(separatorView)
        contentView.addSubview(noFlightsFoundView)
        noFlightsFoundView.addSubview(noFlightsFoundLabel)
        contentView.bringSubviewToFront(noFlightsFoundView)
        noFlightsFoundView.isHidden = true
        setUpConstraints()
    }
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            noFlightsFoundView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            noFlightsFoundView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
            self.contentView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: noFlightsFoundView.trailingAnchor),
            self.contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: noFlightsFoundView.bottomAnchor),
            noFlightsFoundLabel.topAnchor.constraint(equalTo: noFlightsFoundView.topAnchor),
            noFlightsFoundLabel.leadingAnchor.constraint(equalTo: noFlightsFoundView.leadingAnchor),
            noFlightsFoundView.trailingAnchor.constraint(equalTo: noFlightsFoundLabel.trailingAnchor),
            noFlightsFoundView.bottomAnchor.constraint(equalTo: noFlightsFoundLabel.bottomAnchor),
            containerVerticalStackView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            containerVerticalStackView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            self.contentView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: containerVerticalStackView.trailingAnchor, constant: 15),
            self.contentView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: containerVerticalStackView.bottomAnchor, constant: 15),
            paddingView.heightAnchor.constraint(equalToConstant: 16),
            separatorContainerView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.topAnchor.constraint(equalTo: separatorContainerView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: separatorContainerView.leadingAnchor, constant: 48),
            separatorContainerView.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 48),
            separatorContainerView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor)
        ])
    }
    // Add configure method
    
    // complete!!
    // 이것은 api에서 데이터를 전달을 성공적으로 받을때 이 함수가 호출되며 view가 초기화 됩니다. 이 함수는 flightOfferViewController의 tableViewcell을 꾸며주는 delegate 함수에서 사용됩니다.
    func configure(
        with flightDetails: FlightBookingData.FlightDetails? // 비행계획
       ) { // 해당하는 비행계획이 없을 경우 noFLightsFoundView가 나타납니다.
           guard let flightDetails = flightDetails else {
               self.noFlightsFoundView.isHidden = false
               self.isUserInteractionEnabled = false
               return
           }
           
           //비행계획이 있을떄의 경우입니다.
           self.flightDetails = flightDetails

           self.noFlightsFoundView.isHidden = true
           self.isUserInteractionEnabled = true
           flightInformationView.segments = flightDetails.itineraries[0].segments // 목적지로 가는 일정의 집합을 넣습니다. flightInformationView 설명입니다.
           
           // 왕복인 경우!  목적지에서 다시 집으로 돌아올때 일정의 집합을 넣습니다.
           if flightDetails.itineraries.count > 1 { returnFlightInformationView.segments = flightDetails.itineraries[1].segments }
           returnFlightInformationView.isHidden = flightDetails.itineraries.count < 2
           // 왕복인 경우 flightDetails.intenaries.count는 2입니다. 그래서 false가 나오고 returnFlightInformationView가 활성화됩니다.
           priceLabel.text = "\(flightDetails.price!.total!) \(flightDetails.price!.currency! )"
       }
    
    
    // 아래 함수는 항공권 검색에 쓰이는 함수가 아닙니다.
    // 추후 파이어베이스에 공유된 항공편 정보를 다시 보고 싶을때 파이어베이스에 저장된 데이터베이스를 파싱해서 뷰로 보여주는 함수입니다.

func configure(
    with flightDetails: [FlightBookingData.Itinerary]?,_ pri : String // 비행계획
   ) { // 해당하는 비행계획이 비었을때의 경우 noFLightsFoundView가 나타남
       guard let flightDetails = flightDetails else {
           self.noFlightsFoundView.isHidden = false
           self.isUserInteractionEnabled = false
           return
       }// 요청 정보가 없다면
       
       //비행계획이 있을떄의 경우
       //self.flightDetails = flightDetails

       self.noFlightsFoundView.isHidden = true
       self.isUserInteractionEnabled = true
       flightInformationView.segments = flightDetails[0].segments // 편도든 왕복이든 전부 해당됨
       
       // 왕복인 경우!   //segemnts의 원소는 icn-sgn,sgn-bkk segement는 원소들을 다 합친것! 결국 segements배열은 집->목 or 목->집에 해당하는 것
       // 아래는 목->집에 해당하는 returnFlightInfromationView.segements야
       if flightDetails.count > 1 { returnFlightInformationView.segments = flightDetails[1].segments }
       returnFlightInformationView.isHidden = flightDetails.count < 2
       // 왕복인 경우 flightDetails.intenaries.count는 2 그래서 false가 나옴
      // priceLabel.text = "\(flightDetails.price.total) \(AvailableCurrencies(from: flightDetails.price.currency).symbol )"
       priceLabel.text = "\(pri) EUR "
   }
}

// coedes above this line will present flight info search result




