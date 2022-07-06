//
//  MainScreenCollectionViewCell.swift
//  Numbers
//
//  Created by Tatiana Sosina on 06.07.2022.
//

import UIKit

final class MainScreenCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Internal properties
  
  static let reuseIdentifier = MainScreenCollectionViewCell.description()
  
  // MARK: - Private properties
  
  private let primaryText = UILabel()
  
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
  
  func configureCellWith(text: String?, style: MainScreenCellStyle) {
    primaryText.text = text
    contentView.backgroundColor = style == .light ? .white : .systemGray5
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [primaryText].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      primaryText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: appearance.sectionInset.left),
      primaryText.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: appearance.sectionInset.top),
      primaryText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: -appearance.sectionInset.right),
      primaryText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                          constant: -appearance.sectionInset.bottom),
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .white
    primaryText.textAlignment = .center
  }
}

// MARK: - Appearance

private extension MainScreenCollectionViewCell {
  struct Appearance {
    let sectionInset = UIEdgeInsets(top: 4,
                                    left: 8,
                                    bottom: 4,
                                    right: 8)
  }
}
