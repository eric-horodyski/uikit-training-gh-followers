//
//  RepoDetailViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/23/24.
//

import UIKit

protocol RepoDetailViewControllerDelegate: AnyObject {
	func didTapGithubProfile(for user: User)
}

class RepoDetailViewController: ItemDetailViewController {
	weak var delegate: RepoDetailViewControllerDelegate!
	
	init(user: User, delegate: RepoDetailViewControllerDelegate) {
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
		delegate.didTapGithubProfile(for: user)
	}
	
	private func configureDetails() {
		itemDetailViewOne.set(type: .repos, with: user.publicRepos)
		itemDetailViewTwo.set(type: .gists, with: user.publicGists)
		actionButton.set(color: .systemPurple, title: "GitHub Profile", systemImageName: "person")
	}
}
