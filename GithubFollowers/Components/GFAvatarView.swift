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
		let key = NSString(string: url)
		if let image = cache.object(forKey: key) {
			self.image = image
			return
		}
				
		guard let url = URL(string: url) else { return }
		
		let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			guard let self = self else { return }
			if error != nil { return }
			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
			guard let data = data else { return }
			
			guard let image = UIImage(data: data) else { return }
			self.cache.setObject(image, forKey: key)
			
			DispatchQueue.main.async { self.image = image }
		}
		task.resume()
	}

	private func configure() {
		layer.cornerRadius = 10
		clipsToBounds = true
		image = .avatarPlaceholder
		translatesAutoresizingMaskIntoConstraints = false
	}
	
}
