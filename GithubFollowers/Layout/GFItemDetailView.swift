//
//  GFItemDetailView.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/23/24.
//

import UIKit

enum ItemDetailType {
	case repos, gists, followers, following
}

class GFItemDetailView: UIView {
	let symbolImageView = UIImageView()
	let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 14)
	let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func set(type: ItemDetailType, with count: Int) {
		switch type {
		case .repos:
			symbolImageView.image = UIImage(systemName: "folder")
			titleLabel.text = "Public Repos"
		case .gists:
			symbolImageView.image = UIImage(systemName: "text.alignleft")
			titleLabel.text = "Gists"
		case .followers:
			symbolImageView.image = UIImage(systemName: "heart")
			titleLabel.text = "Followers"
		case .following:
			symbolImageView.image = UIImage(systemName: "person.2")
			titleLabel.text = "Following"
		}
		countLabel.text = String(count)
	}
	
	private func configure() {
		addSubview(symbolImageView)
		addSubview(titleLabel)
		addSubview(countLabel)
		
		symbolImageView.translatesAutoresizingMaskIntoConstraints = false
		symbolImageView.contentMode = .scaleAspectFill
		symbolImageView.tintColor = .label
		
		NSLayoutConstraint.activate([
			symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
			symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			symbolImageView.widthAnchor.constraint(equalToConstant: 20),
			symbolImageView.heightAnchor.constraint(equalToConstant: 20),
			titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
			titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			titleLabel.heightAnchor.constraint(equalToConstant: 18),
			countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
			countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			countLabel.heightAnchor.constraint(equalToConstant: 18)
		])
	}
	
}
