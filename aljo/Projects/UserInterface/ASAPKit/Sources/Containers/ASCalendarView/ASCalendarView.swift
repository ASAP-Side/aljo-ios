//
//  ASCalendarView.swift
//  ASAPKitDemo
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import RxSwift
import RxCocoa

// MARK: Reactive 확장
public extension Reactive where Base == ASCalendarView {
  var selectedDate: Observable<Date?> {
    return base.dateCollectionView.rx.itemSelected
      .map { _ in base.selectedDate?.toDate() }
  }
}

public final class ASCalendarView: UIView {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.body3)
    return label
  }()
  
  private let previousButton: UIButton = {
    var configuration = UIButton.Configuration.plain()
    configuration.image = .Icon.arrow_left.withTintColor(.black01)
    return UIButton(configuration: configuration)
  }()
  
  private let nextButton: UIButton = {
    var configuration = UIButton.Configuration.plain()
    configuration.image = .Icon.arrow_right.withTintColor(.black01)
    return UIButton(configuration: configuration)
  }()
  
  private let weekDayStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  internal let dateCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(
      CalendarCollectionViewCell.self,
      forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier
    )
    collectionView.isScrollEnabled = false
    return collectionView
  }()
  
  // MARK: Properties
  internal var selectedDate: CalendarDate?
  private var selectableDateRange: ClosedRange<Date>?
  private let calendar: Calendar = Calendar.koreanCalendar
  private var calendarDate = Date()
  private var days = [CalendarDate]() {
    didSet {
      dateCollectionView.reloadData()
    }
  }
  
  // MARK: Life Cycle
  public init(by selectableDateRange: ClosedRange<Date>? = nil) {
    self.selectableDateRange = selectableDateRange
    super.init(frame: .zero)
    
    configureCalendar()
    attachActions()
    configureUI()
  }
  
  @available(*, unavailable, message: "스토리보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Business Logic
private extension ASCalendarView {
  /// 초기 날짜를 설정합니다.
  func configureCalendar() {
    let components = calendar.dateComponents([.year, .month], from: Date())
    self.calendarDate = calendar.date(from: components) ?? Date()
    
    if let year = components.year, let month = components.month {
      updateCalendar(year: year, month: month)
    }
  }
  
  /// 기준 달을 변경하고, 변경된 달에 맞춰 일 데이터를 변경합니다.
  private func updateCalendar(year: Int, month: Int) {
    self.titleLabel.text = calendarDate.toString(format: "yyyy년 M월")
    updateDays(year: year, month: month)
  }
  
  /// 기준 달에 맞는 일 데이터를 만듭니다.
  private func updateDays(year: Int, month: Int) {
    let startOfTheWeek = startDayOfTheWeekDay()
    let totalDays = startOfTheWeek + endDate()
    
    days = (0..<totalDays).map { day in
      if day < startOfTheWeek {
        return CalendarDate.generateEmpty()
      } else {
        let realDay = (day - startOfTheWeek + 1)
        return CalendarDate.generate(
          year: year, month: month, day: realDay, with: selectableDateRange
        )
      }
    }
    updatePreviousButton()
  }
  
  /// 이번 달의 시작 날짜를 찾습니다.
  private func startDayOfTheWeekDay() -> Int {
    return calendar.component(.weekday, from: calendarDate) - 1
  }
  
  /// 끝나는 날짜를 찾아서 개수를 반환합니다.
  private func endDate() -> Int {
    return calendar.range(of: .day, in: .month, for: calendarDate)?.count ?? Int()
  }
  
  /// 선택 달을 업데이트 합니다.
  private func updateMonth(add month: Int) {
    guard let updateDate = calendar.date(byAdding: .month, value: month, to: calendarDate) else {
      return
    }
    
    calendarDate = updateDate
    let components = calendar.dateComponents([.year, .month], from: updateDate)
    guard let year = components.year, let month = components.month else { return }
    updateCalendar(year: year, month: month)
  }
}

// MARK: UICollectionView Data Source Method
extension ASCalendarView: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int { return days.count }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CalendarCollectionViewCell.identifier,
      for: indexPath
    ) as? CalendarCollectionViewCell else {
      return .init()
    }
    let date = days[indexPath.row]
    cell.configureDay(to: date)
    
    // 선택된 날짜가 있는 경우, 현재 보여줄 날짜와 같음을 통해 뷰를 구성합니다.
    if let selectedDate = selectedDate {
      cell.updateSelect(to: selectedDate == date)
    }
    return cell
  }
}

// MARK: UICollectionView Delegate FlowLayout Method
extension ASCalendarView: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = self.weekDayStackView.frame.width / 7
    return CGSize(width: width, height: width)
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat { return .zero }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat { return .zero }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let item = days[indexPath.row]
    
    // 선택된 index의 날짜가 없거나 이전 날짜인 경우 반환합니다.
    if item.isEmpty || (item.isSelectable == false) { return }
    
    let itemCounts = collectionView.numberOfItems(inSection: indexPath.section)
    
    // 전체 섹션을 돌면서 전체 셀을 업데이트 합니다.
    for row in 0...itemCounts {
      let rowIndexPath = IndexPath(row: row, section: .zero)
      
      if let cell = collectionView.cellForItem(at: rowIndexPath) as? CalendarCollectionViewCell {
        if indexPath.row == row { self.selectedDate = item }
        cell.updateSelect(to: indexPath.row == row)
      }
    }
  }
}

// MARK: Configure Button Action And View
private extension ASCalendarView {
  func attachActions() {
    let nextAction = UIAction { [weak self] _ in self?.updateMonth(add: 1) }
    let previousAction = UIAction { [weak self] _ in self?.updateMonth(add: -1) }
    
    nextButton.addAction(nextAction, for: .touchUpInside)
    previousButton.addAction(previousAction, for: .touchUpInside)
  }
  
  func updatePreviousButton() {
    let selectDate = calendar.dateComponents([.year, .month], from: calendarDate)
    
    if let lowerDate = selectableDateRange?.lowerBound {
      let lowerComponents = calendar.dateComponents([.year, .month], from: lowerDate)
      let isLessThanCurrentMonth = (selectDate.month ?? .zero <= lowerComponents.month ?? .zero)
      previousButton.isHidden = isLessThanCurrentMonth
    }
    
    if let upperDate = selectableDateRange?.upperBound {
      let upperComponents = calendar.dateComponents([.year, .month], from: upperDate)
      let isMoreThanCurrentMonth = (selectDate.month ?? .zero >= upperComponents.month ?? .zero)
      nextButton.isHidden = isMoreThanCurrentMonth
    }
  }
}

// MARK: Configure UI Method
private extension ASCalendarView {
  func configureUI() {
    configureHierarchy()
    makeConstraints()
    
    dateCollectionView.dataSource = self
    dateCollectionView.delegate = self
  }
  
  func configureWeekLabels() -> [UILabel] {
    let dayOfWeek = calendar.shortWeekdaySymbols

    return dayOfWeek.map {
      let label = UILabel()
      label.font = .pretendard(.body3)
      label.textColor = $0 == "일" ? .red500 : .black03
      label.text = $0
      label.textAlignment = .center
      return label
    }
  }
  
  func configureHierarchy() {
    configureWeekLabels().forEach { weekDayStackView.addArrangedSubview($0) }
    [
      titleLabel, previousButton, nextButton,
      weekDayStackView, dateCollectionView
    ].forEach(addSubview)
  }
  
  func makeConstraints() {
    previousButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.bottom.equalTo(titleLabel)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    
    nextButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalTo(titleLabel)
    }
    
    weekDayStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(18)
      $0.horizontalEdges.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    
    dateCollectionView.snp.makeConstraints {
      $0.top.equalTo(weekDayStackView.snp.bottom).offset(16)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}
