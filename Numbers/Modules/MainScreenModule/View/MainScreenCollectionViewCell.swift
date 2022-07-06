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
    contentView.backgroundColor = style == .light ? .white : .gray
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    [primaryText].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      primaryText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      primaryText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .white
  }
}
