//
//  MainScreenFactory.swift
//  Numbers
//
//  Created by Tatiana Sosina on 06.07.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol MainScreenFactoryOutput: AnyObject {
  
}

/// Cобытия которые отправляем от Presenter к Factory
protocol MainScreenFactoryInput {
  
}

/// Фабрика
final class MainScreenFactory: MainScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenFactoryOutput?
  
  // MARK: - Private properties
  
}

// MARK: - Appearance

private extension MainScreenFactory {
  struct Appearance {
    
  }
}
