//
//  HostingWindowFinder.swift
//  QadhaTracker
//
//  Created by Saeed Taheri on 4/16/23.
//

import SwiftUI

struct HostingWindowFinder: UIViewRepresentable {
	var callback: (UIWindow?) -> Void

	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		view.backgroundColor = .clear
		view.isUserInteractionEnabled = false
		DispatchQueue.main.async { [weak view] in
			view?.window?.tintColor = UIColor(named: "AccentColor")
			self.callback(view?.window)
		}
		return view
	}

	func updateUIView(_ uiView: UIView, context: Context) {
	}
}
