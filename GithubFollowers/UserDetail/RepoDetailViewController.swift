//
//  RepoDetailViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/23/24.
//

import UIKit

class RepoDetailViewController: ItemDetailViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureDetails()
	}
	
	override func actionButtonTapped() {
		delegate.didTapGithubProfile(for: user)
	}
	
	private func configureDetails() {
		itemDetailViewOne.set(type: .repos, with: user.publicRepos)
		itemDetailViewTwo.set(type: .gists, with: user.publicGists)
		actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
	}
}
