//
//  FollowerListViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/5/24.
//

import UIKit

protocol FollowerListViewControllerDelegate: AnyObject {
	func didRequestFollowers(for username: String)
}

class FollowerListViewController: UIViewController {
	
	enum Section { case main }
	
	var username: String!
	var followers: [Follower] = []
	var filteredFollowers: [Follower] = []
	var page = 1
	var hasMoreFollowers = true
	var isSearching = false
	
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureViewController()
		configureSearchController()
		configureCollectionView()
		configureDataSource()

		getFollowers(for: username, page: page)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	func updateData(on followers: [Follower]) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
		snapshot.appendSections([.main])
		snapshot.appendItems(followers)
		
		DispatchQueue.main.async {
			self.dataSource.apply(snapshot, animatingDifferences: true)
		}
	}
	
	private func configureViewController() {
		view.backgroundColor = .systemBackground
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func configureCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: FlowLayoutFactory.createThreeColumnFlowLayout(in: view))
		view.addSubview(collectionView)
		collectionView.backgroundColor = .systemBackground

		collectionView.delegate = self
		collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
	}
	
	private func getFollowers(for username: String, page: Int) {
		showLoadingView()
		NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
			guard let self = self else { return }
			
			self.dismissLoadingView()
			switch result {
			case .success(let followers):
				if followers.count < 100 { self.hasMoreFollowers = false }
				self.followers.append(contentsOf: followers)
				
				if self.followers.isEmpty {
					let message = "This user doesn't have any followers."
					DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
					return
				}
				self.updateData(on: self.followers)
			case .failure(let error):
				self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
			}
		}
	}
	
	private func configureDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
			cell.set(follower: follower)
			return cell
		})
	}
	
	private func configureSearchController() {
		let searchController = UISearchController()
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.searchBar.placeholder = "Search for a username"
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
}

extension FollowerListViewController: UICollectionViewDelegate {
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let height = scrollView.frame.size.height
		
		if offsetY > contentHeight - height {
			guard hasMoreFollowers else { return }
			page += 1
			getFollowers(for: username, page: page)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let activeArray = isSearching ? filteredFollowers : followers
		let follower = activeArray[indexPath.item]
		
		let destination = UserDetailViewController()
		destination.delegate = self
		destination.username = follower.login
		let navController = UINavigationController(rootViewController: destination)
		present(navController, animated: true)
	}
}

extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate {
	func updateSearchResults(for searchController: UISearchController) {
		guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
		isSearching = true
		filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
		updateData(on: filteredFollowers)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		isSearching = false
		updateData(on: followers)
	}
}


extension FollowerListViewController: FollowerListViewControllerDelegate {
	func didRequestFollowers(for username: String) {
		self.username = username
		title = username
		page = 1
		followers.removeAll()
		filteredFollowers.removeAll()
		collectionView.setContentOffset(.zero, animated: true)
		getFollowers(for: self.username, page: page)
	}
}
