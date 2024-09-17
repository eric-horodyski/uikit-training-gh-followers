//
//  FollowerListViewController.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/5/24.
//

import UIKit

class FollowerListViewController: GFDataLoadingViewController {
	
	enum Section { case main }
	
	var username: String!
	var followers: [Follower] = []
	var filteredFollowers: [Follower] = []
	var page = 1
	var hasMoreFollowers = true
	var isSearching = false
	var isLoading = false
	
	var collectionView: UICollectionView!
	var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
	
	init(username: String) {
		super.init(nibName: nil, bundle: nil)
		self.username = username
		title = username
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureViewController()
		configureSearchController()
		configureCollectionView()
		configureDataSource()

		getFollowers(for: username, page: page)
	}
	
	override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
		super.beginAppearanceTransition(isAppearing, animated: animated)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
		if followers.isEmpty && !isLoading {
			var config = UIContentUnavailableConfiguration.empty()
			config.image = .init(systemName: "person.slash")
			config.text = "No Followers"
			config.secondaryText = "This user has no followers. Follow them!"
			contentUnavailableConfiguration = config
		} else if isSearching && filteredFollowers.isEmpty {
			contentUnavailableConfiguration = UIContentUnavailableConfiguration.search()
		} else {
			contentUnavailableConfiguration = nil
		}
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
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
		navigationItem.rightBarButtonItem = addButton
	}
	
	private func configureCollectionView() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: FlowLayoutFactory.createThreeColumnFlowLayout(in: view))
		view.addSubview(collectionView)
		collectionView.backgroundColor = .systemBackground

		collectionView.delegate = self
		collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
	}
	
	private func getFollowers(for username: String, page: Int)  {
		showLoadingView()
		isLoading = true
		
		/*
		 *	guard let followers = try? await NetworkManager.shared.getFollowers(for: username, page: page) else {}
		*/
		
		Task {
			do {
				let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
				updateUI(with: followers)
				dismissLoadingView()
				isLoading = false
			} catch {
				if let error = error as? GFError {
					presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
				} else {
					presentDefaultError()
				}
				isLoading = false
				dismissLoadingView()
			}
		}
	}
	
	private func updateUI(with followers: [Follower]) {
		if followers.count < 100 {
			hasMoreFollowers = false
		}
		self.followers.append(contentsOf: followers)
		updateData(on: self.followers)
		setNeedsUpdateContentUnavailableConfiguration()
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
		searchController.searchBar.placeholder = "Search for a username"
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}
	
	@objc private func addButtonTapped() {
		showLoadingView()
		
		Task {
			do {
				let user = try await NetworkManager.shared.getUserDetail(for: username)
				addUserToFavorites(user: user)
				dismissLoadingView()
			} catch {
				if let error = error as? GFError {
					presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
				} else {
					presentDefaultError()
				}
				dismissLoadingView()
			}
		}
	}
	
	private func addUserToFavorites(user: User) {
		let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
		PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
			guard let self else { return }
			
			guard let error else {
				DispatchQueue.main.async {
					self.presentGFAlert(title: "Success", message: "You've successfully favorited this user.", buttonTitle: "OK")
				}
				return
			}
			DispatchQueue.main.async {
				self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
			}
		}
	}
}

extension FollowerListViewController: UICollectionViewDelegate {
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let height = scrollView.frame.size.height - 100
		
		if offsetY > contentHeight - height {
			guard hasMoreFollowers, !isLoading else { return }
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

extension FollowerListViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let filter = searchController.searchBar.text, !filter.isEmpty else {
			filteredFollowers.removeAll()
			updateData(on: followers)
			isSearching = false
			return
		}
		isSearching = true
		filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
		updateData(on: filteredFollowers)
		setNeedsUpdateContentUnavailableConfiguration()
	}
}


extension FollowerListViewController: UserDetailViewControllerDelegate {
	func didRequestFollowers(for username: String) {
		self.username = username
		title = username
		page = 1
		followers.removeAll()
		filteredFollowers.removeAll()
		collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
		getFollowers(for: self.username, page: page)
	}
}
