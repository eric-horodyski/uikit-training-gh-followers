//
//  PersistenceManager.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/28/24.
//

import Foundation

enum PersistenceActionType {
	case add, remove
}

enum PersistenceManager {
	enum Keys {
		static let favorites = "favorites"
	}
	
	static private let defaults = UserDefaults.standard
	
	static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (GFError?) -> Void) {
		getAll { result in
			switch result {
			case .success(var favorites):
				
				switch actionType {
				case .add:
					guard !favorites.contains(favorite) else {
						completion(.alreadyInFavorites)
						return
					}
					favorites.append(favorite)
				case .remove:
					favorites.removeAll { $0.login == favorite.login }
				}
				
				completion(save(favorites: favorites))
				
			case .failure(let error):
				completion(error)
			}
		}
	}
	
	static func getAll(completion: @escaping (Result<[Follower], GFError>) -> Void) {
		guard let data = defaults.object(forKey: Keys.favorites) as? Data else {
			completion(.success([]))
			return
		}
		
		do {
			let decoder = JSONDecoder()
			let favorites = try decoder.decode([Follower].self, from: data)
			completion(.success(favorites))
		} catch {
			completion(.failure(.unableToFavorite))
		}
	}
	
	static func save(favorites: [Follower]) -> GFError? {
		do {
			let encoder = JSONEncoder()
			let encoded = try encoder.encode(favorites)
			defaults.set(encoded, forKey: Keys.favorites)
			return nil
		} catch {
			return GFError.unableToFavorite
		}
	}
}
