//
//  MainScreenView.swift
//  Numbers
//
//  Created by Tatiana Sosina on 06.07.2022.
//

import UIKit

/// События которые отправляем из View в Presenter
protocol MainScreenViewOutput: AnyObject {
  
}

/// События которые отправляем от Presenter ко View
protocol MainScreenViewInput: AnyObject {
  
}

/// Псевдоним протокола UIView & MainScreenViewInput
typealias MainScreenViewProtocol = UIView & MainScreenViewInput

/// View для экрана
final class MainScreenView: MainScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenViewOutput?
  
  // MARK: - Private properties
  
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: collectionViewLayout)
  private var models: [String] = ["Тест", "Тест2", "Тест"]
  
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
  
  func configureCellsWith(models: [String]) {
    self.models = models
    collectionView.reloadData()
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [collectionView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor, constant: appearance.collectionViewInsets.top),
      collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: appearance.collectionViewInsets.left),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -appearance.collectionViewInsets.right),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -appearance.collectionViewInsets.bottom),
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
  }
}

// MARK: - UICollectionViewDelegate

extension MainScreenView: UICollectionViewDelegate { }

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
    cell.configureCellWith(text: model, style: .dark)
    return cell
  }
}

// MARK: - Appearance

private extension MainScreenView {
  struct Appearance {
    let collectionViewInsets: UIEdgeInsets = .zero
    let backgroundColor = UIColor.white
    let estimatedRowHeight: CGFloat = 64
    let sectionInset = UIEdgeInsets(top: .zero,
                                    left: .zero,
                                    bottom: .zero,
                                    right: .zero)
    let cellWidthConstant = UIScreen.main.bounds.width * 0.5
  }
}
