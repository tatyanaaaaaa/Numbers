//
//  MainScreenInteractor.swift
//  Numbers
//
//  Created by Tatiana Sosina on 06.07.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol MainScreenInteractorOutput: AnyObject {
  
  /// Были получены простые числа
  ///  - Parameter numbers: Простые числа
  func didRecivePrimeNumbers(numbers: [Int])
  
  /// Были получены числа фибоначчи
  ///  - Parameter numbers: Числа фибоначчи
  func didReciveFibonacci(numbers: [Int])
}

/// События которые отправляем от Presenter к Interactor
protocol MainScreenInteractorInput {
  
  /// Получить простые числа
  func getPrimeNumbers()
  
  /// Получить числа фибоначчи
  func getFibonacciNumbers()
  
  /// Добавить еще простых чисел
  ///  - Parameter numbers: Список чисел
  func getMorePrime(numbers: [Int])
  
  /// Добавить еще чисел фибоначи
  ///  - Parameter numbers: Список чисел
  func getMoreFibonacci(numbers: [Int])
}

/// Интерактор
final class MainScreenInteractor: MainScreenInteractorInput {

  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  
  // MARK: - Internal func
  
  func getPrimeNumbers() {
    let primeNumbers = createPrimeNumbers(count: Appearance().primeNumbersCount)
    output?.didRecivePrimeNumbers(numbers: primeNumbers)
  }
  
  func getFibonacciNumbers() {
    let fibonacciNumbers = createFibonacciNumbers()
    output?.didReciveFibonacci(numbers: fibonacciNumbers.map { Int($0) })
  }
  
  func getMorePrime(numbers: [Int]) {
    let primeNumbers = createPrimeNumbers(firstPrime: numbers.last,
                                          count: Appearance().primeNumbersCount + numbers.count)
    output?.didRecivePrimeNumbers(numbers: numbers + primeNumbers)
  }
  
  func getMoreFibonacci(numbers: [Int]) {
    let newNumbers = createFibonacciNumbers(firstFibonacci: numbers.last ?? .zero).map { Int($0)}
    output?.didReciveFibonacci(numbers: numbers + newNumbers)
  }
}

// MARK: - Private

private extension MainScreenInteractor {

  func createFibonacciNumbers(firstFibonacci: Int = .zero) -> UnfoldSequence<Int, (Int, Int)> {
    return sequence(state: (1, firstFibonacci), next: {
      ($0.1 <= Appearance().fibonacciNumbersCount ? $0.1 : Optional<Int>.none, $0 = ($0.1, $0.0 + $0.1)).0 })
  }
  
  func createPrimeNumbers(firstPrime: Int? = nil, count: Int) -> [Int] {
    var firstPrimeInitial = 2
    
    if let firstPrime = firstPrime {
      firstPrimeInitial = firstPrime
    }
    
    guard count >= firstPrimeInitial else {
      return []
    }
    var numbers = Array(firstPrimeInitial...count)
    var currentPrimeIndex = 0
    
    while currentPrimeIndex < numbers.count {
      let currentPrime = numbers[currentPrimeIndex]
      var numbersAfterPrime = numbers.suffix(from: currentPrimeIndex + 1)
      
      numbersAfterPrime.removeAll(where: { $0 % currentPrime == 0 })
      numbers = numbers.prefix(currentPrimeIndex + 1) + Array(numbersAfterPrime)
      currentPrimeIndex += 1
    }
    return numbers
  }
}

// MARK: - Appearance

private extension MainScreenInteractor {
  struct Appearance {
    let primeNumbersCount = 1_000
    let fibonacciNumbersCount = 1_000_000_000_000_000
  }
}
