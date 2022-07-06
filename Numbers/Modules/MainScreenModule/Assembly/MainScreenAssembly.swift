//
//  MainScreenAssembly.swift
//  Numbers
//
//  Created by Tatiana Sosina on 06.07.2022.
//

import UIKit

/// Сборщик `MainScreen`
final class MainScreenAssembly {
  
  /// Собирает модуль `MainScreen`
  /// - Returns: Cобранный модуль `MainScreen`
  func createModule() -> MainScreenModule {
    
    let interactor = MainScreenInteractor()
    let view = MainScreenView()
    let factory = MainScreenFactory()
    
    let presenter = MainScreenViewController(interactor: interactor, moduleView: view, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
