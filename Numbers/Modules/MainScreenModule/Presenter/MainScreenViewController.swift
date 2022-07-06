//
//  MainScreenViewController.swift
//  Numbers
//
//  Created by Tatiana Sosina on 06.07.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol MainScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol MainScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: MainScreenModuleOutput? { get set }
}

/// Готовый модуль `MainScreenModule`
typealias MainScreenModule = UIViewController & MainScreenModuleInput

/// Презентер
final class MainScreenViewController: MainScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MainScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MainScreenInteractorInput
  private let moduleView: MainScreenViewProtocol
  private let factory: MainScreenFactoryInput
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(interactor: MainScreenInteractorInput,
       moduleView: MainScreenViewProtocol,
       factory: MainScreenFactoryInput) {
    self.interactor = interactor
    self.moduleView = moduleView
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let appearance = Appearance()
    title = appearance.title
    interactor.getPrimeNumbers()
  }
}

// MARK: - MainScreenViewOutput

extension MainScreenViewController: MainScreenViewOutput {
  func morePrimeNumbers(models: [MainScreenCellModel]) {
    let primeNumbers = factory.createPrimeNumbersFrom(models: models)
    interactor.getMorePrime(numbers: primeNumbers)
  }
  
  func moreFibonacciNumbers(models: [MainScreenCellModel]) {
    let fibonacciNumbers = factory.createFibonacciNumbersFrom(models: models)
    interactor.getMoreFibonacci(numbers: fibonacciNumbers)
  }
  
  func selectedPrimeNumbers() {
    interactor.getPrimeNumbers()
  }
  
  func selectedFibonacciNumbers() {
    interactor.getFibonacciNumbers()
  }
}

// MARK: - MainScreenInteractorOutput

extension MainScreenViewController: MainScreenInteractorOutput {
  func didRecivePrimeNumbers(numbers: [Int]) {
    factory.createMainScreenCellModel(numbers: numbers)
  }
  
  func didReciveFibonacci(numbers: [Int]) {
    factory.createMainScreenCellModel(numbers: numbers)
  }
}

// MARK: - MainScreenFactoryOutput

extension MainScreenViewController: MainScreenFactoryOutput {
  func didReciveMainScreenCell(models: [MainScreenCellModel]) {
    moduleView.configureCellsWith(models: models)
  }
}

// MARK: - Appearance

private extension MainScreenViewController {
  struct Appearance {
    let title = "Генератор"
  }
}
