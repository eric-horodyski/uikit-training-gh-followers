//
//  FavoriteCell.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 9/4/24.
//

import UIKit

class FavoriteCell: UITableViewCell {
	static let reuseID = "FavoriteCell"
	
	let avatarImageView = GFAvatarView(frame: .zero)
	let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func set(favorite: Follower) {
		usernameLabel.text = favorite.login
		avatarImageView.downloadImage(from: favorite.avatarUrl)
	}
	
	private func configure() {
		addSubviews(avatarImageView, usernameLabel)
		accessoryType = .disclosureIndicator
		
		let padding: CGFloat = 12
		NSLayoutConstraint.activate([
			avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
			avatarImageView.widthAnchor.constraint(equalToConstant: 60),
			avatarImageView.heightAnchor.constraint(equalToConstant: 60),
			usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: padding * 2),
			usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
			usernameLabel.heightAnchor.constraint(equalToConstant: 40)
		])
	}
	
}
