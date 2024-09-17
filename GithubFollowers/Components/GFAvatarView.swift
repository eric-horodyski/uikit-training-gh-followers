//
//  GFAvatarView.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/19/24.
//

import UIKit

class GFAvatarView: UIImageView {
	let cache = NetworkManager.shared.cache
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func downloadImage(from url: String) {
		Task { image = await NetworkManager.shared.downloadImage(from: url) ?? .avatarPlaceholder }
	}
	
	private func configure() {
		layer.cornerRadius = 10
		clipsToBounds = true
		image = .avatarPlaceholder
		translatesAutoresizingMaskIntoConstraints = false
	}
	
}
