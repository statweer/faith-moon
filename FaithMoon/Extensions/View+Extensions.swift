//
//  View+Extensions.swift
//  FaithMoon
//
//  Created by Saeed Taheri on 4/16/23.
//

import SwiftUI

extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

extension View {
  func preferredImpactSensoryFeedback(trigger: some Equatable) -> some View {
    #if os(iOS) || os(watchOS)
    sensoryFeedback(.impact, trigger: trigger)
    #else
    self
    #endif
  }

  func preferredImpactSensoryFeedback<T: Equatable>(
    trigger: T,
    condition: @escaping (T, T) -> Bool
  ) -> some View {
    #if os(iOS) || os(watchOS)
    sensoryFeedback(.impact, trigger: trigger, condition: condition)
    #else
    self
    #endif
  }

  func preferredLevelChangeSensoryFeedback(trigger: some Equatable) -> some View {
    #if os(iOS) || os(watchOS)
    sensoryFeedback(.levelChange, trigger: trigger)
    #else
    self
    #endif
  }

  func preferredSelectionSensoryFeedback(trigger: some Equatable) -> some View {
    #if os(iOS) || os(watchOS)
    sensoryFeedback(.selection, trigger: trigger)
    #else
    self
    #endif
  }

  func preferredSuccessSensoryFeedback(trigger: some Equatable) -> some View {
    #if os(iOS) || os(watchOS)
    sensoryFeedback(.success, trigger: trigger)
    #else
    self
    #endif
  }

  func preferredSuccessSensoryFeedback<T: Equatable>(
    trigger: T,
    condition: @escaping (T, T) -> Bool
  ) -> some View {
    #if os(iOS) || os(watchOS)
    sensoryFeedback(.success, trigger: trigger, condition: condition)
    #else
    self
    #endif
  }

  func preferredErrorSensoryFeedback(trigger: some Equatable) -> some View {
    #if os(iOS) || os(watchOS)
    sensoryFeedback(.error, trigger: trigger)
    #else
    self
    #endif
  }
}

extension View {
  /// Applies the given transform if the given condition evaluates to `true`.
  /// - Parameters:
  ///   - condition: The condition to evaluate.
  ///   - transform: The transform to apply to the source `View`.
  /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
  @ViewBuilder
  func `if`(_ condition: @autoclosure () -> Bool, transform: (Self) -> some View) -> some View {
    if condition() {
      transform(self)
    } else {
      self
    }
  }
}
