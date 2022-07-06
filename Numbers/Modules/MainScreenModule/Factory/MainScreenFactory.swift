//
//  MainScreenFactory.swift
//  Numbers
//
//  Created by Tatiana Sosina on 06.07.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol MainScreenFactoryOutput: AnyObject {
  
  /// Был получен список моделей для ячеек
  ///  - Parameter models: список моделей для ячеек
  func didReciveMainScreenCell(models: [MainScreenCellModel])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol MainScreenFactoryInput {
  
  /// Создать список моделей для ячейки
  ///  - Parameter numbers: Список чисел
  func createMainScreenCellModel(numbers: [Int])
  
  /// Создать список простых чисел
  ///  - Parameter models: Список моделей для ячеек
  ///  - Returns: Список простых чисел
  func createPrimeNumbersFrom(models: [MainScreenCellModel]) -> [Int]
  
  /// Создать список фибоначи чисел
  ///  - Parameter models: Список моделей для ячеек
  ///  - Returns: Список фибоначчи чисел
  func createFibonacciNumbersFrom(models: [MainScreenCellModel]) -> [Int]
}

/// Фабрика
final class MainScreenFactory: MainScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createMainScreenCellModel(numbers: [Int]) {
    var models: [MainScreenCellModel] = []
    
    numbers.enumerated().forEach { index, number in
      let style: MainScreenCellStyle = (index % 4) == 0 || (index % 4) == 3 ? .dark : .light
      models.append(MainScreenCellModel(value: "\(number)",
                                        style: style))
    }
    output?.didReciveMainScreenCell(models: models)
  }
  
  func createPrimeNumbersFrom(models: [MainScreenCellModel]) -> [Int] {
    return models.map { Int($0.value ?? "")! }
  }
  
  func createFibonacciNumbersFrom(models: [MainScreenCellModel]) -> [Int] {
    return models.map { Int($0.value ?? "")! }
  }
}
