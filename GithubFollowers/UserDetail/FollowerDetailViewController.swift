//
//  FollowerDetailViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/23/24.
//

import UIKit

class FollowerDetailViewController: ItemDetailViewController {
	
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
		actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
	}
}

