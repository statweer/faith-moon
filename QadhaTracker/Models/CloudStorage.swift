//
//  CloudStorage.swift
//  QadhaTracker
//
//  Created by Saeed Taheri on 4/18/23.
//  Copyright © 2023 Saeed Tatweer IT Services Est. All rights reserved.
//

import Foundation
import Combine

protocol CloudStorage {
	func object(forKey key: String) -> Any?
	func set(_ value: Any?, forKey key: String)

	@discardableResult
	func synchronize() -> Bool
	func publisher(for key: String) -> AnyPublisher<String?, Never>
}

extension CloudStorage {
	func value<T>(for key: String) -> T? {
		object(forKey: key) as? T
	}
}

extension NSUbiquitousKeyValueStore: CloudStorage {
	func publisher(for key: String) -> AnyPublisher<String?, Never> {
		NotificationCenter.default.publisher(
			for: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
			object: self
		)
		.compactMap { notification in
			guard let userInfo = notification.userInfo else { return nil }
			return userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String]
		}
		.filter { (changedKeys: [String]) in
			changedKeys.contains(key)
		}
		.map { _ in
			self.value(for: key)
		}
		.eraseToAnyPublisher()
	}
}
