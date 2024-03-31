import Foundation
import Combine
import Observation
import SwiftUI

@Observable
final class KeyValueStore {
  private let userDefaults: UserDefaults

  var sortType: SortType {
    didSet {
      if sortType != oldValue {
        save(sortType)
      }
    }
  }

  private let cloudStorage: CloudStorage

  @ObservationIgnored private var cancellables: Set<AnyCancellable> = []

  init(
    userDefaults: UserDefaults = UserDefaults(suiteName: appGroupIdentifier) ?? .standard,
    cloudStorage: CloudStorage = NSUbiquitousKeyValueStore.default
  ) {
    self.userDefaults = userDefaults
    self.cloudStorage = cloudStorage

    if let sortStr = userDefaults.string(forKey: UserDefaultsKey.sortType.value) {
      sortType = SortType(rawValue: sortStr) ?? .default
    } else {
      sortType = .default
    }

    initialSyncWithCloudStorage()

    cloudStorage
      .publisher(for: UserDefaultsKey.sortType.value)
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .sink { [weak self] newValue in
        if let newValue {
          self?.sortType = SortType(rawValue: newValue) ?? .default
        }
      }
      .store(in: &cancellables)
  }

  private func save(_ sortType: SortType?) {
    guard let value = sortType?.rawValue else {
      return
    }

    let now = Date()

    userDefaults.set(value, forKey: UserDefaultsKey.sortType.value)
    userDefaults.set(now, forKey: UserDefaultsKey.keyValueStoreTimestamp.value)

    cloudStorage.set(value, forKey: UserDefaultsKey.sortType.value)
    cloudStorage.set(now, forKey: UserDefaultsKey.keyValueStoreTimestamp.value)
    cloudStorage.synchronize()
  }

  private func initialSyncWithCloudStorage() {
    let cloudTimestamp: Date = cloudStorage.value(
      for: UserDefaultsKey.keyValueStoreTimestamp.value
    ) ?? .distantPast

    let localTimestamp: Date = userDefaults
      .value(
        forKey: UserDefaultsKey.sortType.value
      ) as? Date ?? .distantPast

    if
      let cloudData: String = cloudStorage
        .value(for: UserDefaultsKey.sortType.value),
      !cloudData.isEmpty,
      cloudTimestamp >= localTimestamp {
      // Update UserDefaults with the cloud value and timestamp
      userDefaults.set(cloudData, forKey: UserDefaultsKey.sortType.value)
      userDefaults.set(cloudTimestamp, forKey: UserDefaultsKey.keyValueStoreTimestamp.value)

      sortType = SortType(rawValue: cloudData) ?? .default
    } else if let localData: String = userDefaults
      .string(forKey: UserDefaultsKey.sortType.value), localTimestamp > cloudTimestamp {
      // Update cloud storage with the local value and timestamp
      cloudStorage.set(localData, forKey: UserDefaultsKey.sortType.value)
      cloudStorage.set(localTimestamp, forKey: UserDefaultsKey.keyValueStoreTimestamp.value)
      cloudStorage.synchronize()
    }
  }
}
