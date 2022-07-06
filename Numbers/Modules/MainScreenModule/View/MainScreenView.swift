//
//  MainScreenView.swift
//  Numbers
//
//  Created by Tatiana Sosina on 06.07.2022.
//

import UIKit

/// События которые отправляем из View в Presenter
protocol MainScreenViewOutput: AnyObject {
  
  /// Было выбрано простое число
  func selectedPrimeNumbers()
  
  /// Были выбраны числа фибоначчи
  func selectedFibonacciNumbers()
  
  /// Добавить еще моделек для простых чисел
  ///  - Parameter models: Список моделек для ячеек
  func morePrimeNumbers(models: [MainScreenCellModel])
  
  /// Добавить еще моделек для фибоначчи
  ///  - Parameter models: Список моделек для ячеек
  func moreFibonacciNumbers(models: [MainScreenCellModel])
}

/// События которые отправляем от Presenter ко View
protocol MainScreenViewInput: AnyObject {
  
  /// Настройка главного экрана
  ///  - Parameter models: Список моделек для ячейки
  func configureCellsWith(models: [MainScreenCellModel])
}

/// Псевдоним протокола UIView & MainScreenViewInput
typealias MainScreenViewProtocol = UIView & MainScreenViewInput

/// View для экрана
final class MainScreenView: MainScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenViewOutput?
  
  // MARK: - Private properties
  
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private let segmentedControl = UISegmentedControl()
  private lazy var collectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: collectionViewLayout)
  private var models: [MainScreenCellModel] = []
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func configureCellsWith(models: [MainScreenCellModel]) {
    self.models = models
    collectionView.reloadData()
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [collectionView, segmentedControl].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: appearance.segmantedControl),
      segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -appearance.segmantedControl),
      segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      
      collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor,
                                          constant: appearance.collectionViewInsets.top),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.collectionViewInsets.left),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.collectionViewInsets.right),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                             constant: -appearance.collectionViewInsets.bottom),
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    
    backgroundColor = appearance.backgroundColor
    collectionView.backgroundColor = appearance.backgroundColor
    
    collectionView.alwaysBounceVertical = true
    collectionView.register(MainScreenCollectionViewCell.self,
                            forCellWithReuseIdentifier: MainScreenCollectionViewCell.reuseIdentifier)
    
    collectionViewLayout.sectionInset = appearance.sectionInset
    collectionViewLayout.scrollDirection = .vertical
    collectionViewLayout.minimumInteritemSpacing = .zero
    collectionViewLayout.minimumLineSpacing = .zero
    collectionViewLayout.itemSize = CGSize(width: appearance.cellWidthConstant,
                                           height: appearance.estimatedRowHeight)
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    segmentedControl.insertSegment(withTitle: appearance.primeNumbersTitle,
                                   at: appearance.primeNumbersIndex,
                                   animated: true)
    segmentedControl.insertSegment(withTitle: appearance.fibonacciNumbersTitle,
                                   at: appearance.fibonacciNumbersIndex,
                                   animated: true)
    segmentedControl.addTarget(self,
                               action: #selector(segmentedControlAction(_:)),
                               for: .valueChanged)
    segmentedControl.selectedSegmentIndex = appearance.primeNumbersIndex
  }
  
  @objc
  private func segmentedControlAction(_ segmentedControl: UISegmentedControl) {
    let appearance = Appearance()
    
    if segmentedControl.selectedSegmentIndex == appearance.primeNumbersIndex {
      output?.selectedPrimeNumbers()
      scrollToTop()
      return
    }
    
    if segmentedControl.selectedSegmentIndex == appearance.fibonacciNumbersIndex {
      output?.selectedFibonacciNumbers()
      scrollToTop()
      return
    }
  }
  
  private func scrollToTop() {
    collectionView.scrollToItem(at: IndexPath(row: .zero,
                                              section: .zero),
                                at: .top,
                                animated: false)
  }
}

// MARK: - UICollectionViewDelegate

extension MainScreenView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let appearance = Appearance()
    if indexPath.row == models.count - 1 {
      if segmentedControl.selectedSegmentIndex == appearance.primeNumbersIndex {
        output?.morePrimeNumbers(models: models)
        return
      }
      
      if segmentedControl.selectedSegmentIndex == appearance.fibonacciNumbersIndex {
        output?.moreFibonacciNumbers(models: models)
        return
      }
    }
  }
}

// MARK: - UICollectionViewDataSource

extension MainScreenView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return models.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: MainScreenCollectionViewCell.reuseIdentifier,
      for: indexPath
    ) as? MainScreenCollectionViewCell else {
      return UICollectionViewCell()
    }
    let model = models[indexPath.row]
    cell.configureCellWith(text: model.value, style: model.style)
    return cell
  }
}

// MARK: - Appearance

private extension MainScreenView {
  struct Appearance {
    let collectionViewInsets: UIEdgeInsets = .zero
    let backgroundColor = UIColor.white
    let estimatedRowHeight: CGFloat = 64
    let segmantedControl: CGFloat = 16
    let sectionInset = UIEdgeInsets(top: .zero,
                                    left: .zero,
                                    bottom: .zero,
                                    right: .zero)
    let cellWidthConstant = UIScreen.main.bounds.width * 0.5
    let primeNumbersTitle = "Простые числа"
    let fibonacciNumbersTitle = "Числа Фибоначчи"
    let primeNumbersIndex: Int = 0
    let fibonacciNumbersIndex: Int = 1
  }
}
