//
//  ItemDetailViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/23/24.
//

import UIKit

class ItemDetailViewController: UIViewController {
	let stackView = UIStackView()
	let itemDetailViewOne = GFItemDetailView()
	let itemDetailViewTwo = GFItemDetailView()
	let actionButton = GFButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureBackgroundView()
		configureUI()
		configureStackView()
	}
	
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
	
	private func configureUI() {
		let padding: CGFloat = 20
		view.addSubview(stackView)
		view.addSubview(actionButton)
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
