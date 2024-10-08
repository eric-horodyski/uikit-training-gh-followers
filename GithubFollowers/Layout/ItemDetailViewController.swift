//
//  ItemDetailViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/23/24.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
	func didTapGithubProfile(for user: User)
	func didTapGetFollowers(for user: User)
}

class ItemDetailViewController: UIViewController {
	let stackView = UIStackView()
	let itemDetailViewOne = GFItemDetailView()
	let itemDetailViewTwo = GFItemDetailView()
	let actionButton = GFButton()
	
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
		configureBackgroundView()
		configureUI()
		configureStackView()
		configureActionButton()
	}
	
	@objc func actionButtonTapped() {}
	
	private func configureBackgroundView() {
		view.layer.cornerRadius = 18
		view.backgroundColor = .secondarySystemBackground
	}
	
	private func configureStackView() {
		stackView.axis = .horizontal
		stackView.distribution = .equalSpacing
		stackView.addArrangedSubview(itemDetailViewOne)
		stackView.addArrangedSubview(itemDetailViewTwo)
	}
	
	private func configureActionButton() {
		actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
	}
	
	private func configureUI() {
		let padding: CGFloat = 20
		view.addSubviews(stackView, actionButton)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
			stackView.heightAnchor.constraint(equalToConstant: 50),
			actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
			actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
			actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
			actionButton.heightAnchor.constraint(equalToConstant: 44)
		])
		
	}
	
}
