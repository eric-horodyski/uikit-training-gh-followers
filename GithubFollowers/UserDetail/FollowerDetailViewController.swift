//
//  FollowerDetailViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/23/24.
//

import UIKit

protocol FollowerDetailViewControllerDelegate: AnyObject {
	func didTapGetFollowers(for user: User)
}

class FollowerDetailViewController: ItemDetailViewController {
	weak var delegate: FollowerDetailViewControllerDelegate!
	
	init(user: User, delegate: FollowerDetailViewControllerDelegate) {
		super.init(user: user)
		self.delegate = delegate
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureDetails()
	}
	
	override func actionButtonTapped() {
		delegate.didTapGetFollowers(for: user)
	}
	
	private func configureDetails() {
		itemDetailViewOne.set(type: .followers, with: user.followers)
		itemDetailViewTwo.set(type: .following, with: user.following)
		actionButton.set(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
	}
}

