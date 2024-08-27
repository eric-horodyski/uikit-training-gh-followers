//
//  UserDetailHeaderViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/21/24.
//

import UIKit

class UserDetailHeaderViewController: UIViewController {
	
	let avatarImageView = GFAvatarView(frame: .zero)
	let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 34)
	let nameLabel = GFSubtitleLabel(fontSize: 18)
	let locationImageView = UIImageView()
	let locationLabel = GFSubtitleLabel(fontSize: 18)
	let bioLabel = GFBodyLabel(textAlignment: .left)
	
	var user: User!
	
	init(user: User) {
		super.init(nibName: nil, bundle: nil)
		self.user = user
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addSubViews()
		layoutUI()
		configureUIElements()
	}
	
	private func configureUIElements() {
		avatarImageView.downloadImage(from: user.avatarUrl)
		usernameLabel.text = user.login
		nameLabel.text = user.name ?? ""
		locationLabel.text = user.location ?? ""
		bioLabel.text = user.bio ?? ""
		bioLabel.numberOfLines = 3
		
		locationImageView.image = UIImage(systemName: "mappin.and.ellipse")
		locationImageView.tintColor = .secondaryLabel
		
	}
	
	private func addSubViews() {
		view.addSubview(avatarImageView)
		view.addSubview(usernameLabel)
		view.addSubview(nameLabel)
		view.addSubview(locationImageView)
		view.addSubview(locationLabel)
		view.addSubview(bioLabel)
	}
	
	private func layoutUI() {
		let padding: CGFloat = 20
		let textImagePadding: CGFloat = 12
		locationImageView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
			avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			avatarImageView.widthAnchor.constraint(equalToConstant: 90),
			avatarImageView.heightAnchor.constraint(equalToConstant: 90),
			usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
			usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
			usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			usernameLabel.heightAnchor.constraint(equalToConstant: 38),
			nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
			nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
			nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			nameLabel.heightAnchor.constraint(equalToConstant: 20),
			locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
			locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
			locationImageView.widthAnchor.constraint(equalToConstant: 20),
			locationImageView.heightAnchor.constraint(equalToConstant: 20),
			locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
			locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
			locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			locationLabel.heightAnchor.constraint(equalToConstant: 20),
			bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
			bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
			bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			bioLabel.heightAnchor.constraint(equalToConstant: 60)
		])
	}
}
