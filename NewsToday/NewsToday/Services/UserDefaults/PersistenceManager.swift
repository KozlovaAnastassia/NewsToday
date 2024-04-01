//
//  PersistenceManager.swift
//  NewsToday
//
//  Created by Maryna Bolotska on 28/03/24.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}
enum PersistenceError: Error {
    case alreadyInFavorites
}

typealias UpdateCompletionHandler = (Error?) -> Void

struct PersistenceManager {
    static func updateWith(favorite: Article, actionType: PersistenceActionType, completed: @escaping (Error?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                switch actionType {
                case .add:
                    if favorites.contains(where: { $0.title == favorite.title }) {
                        completed(PersistenceError.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.title == favorite.title }
                }
                completed(save(favorites: favorites))
            case .failure(let error):
                completed(error)
            }
        }
    }

    static func retrieveFavorites(completed: @escaping (Result<[Article], Error>) -> Void) {
        guard let favoritesData = UserDefaults.standard.object(forKey: Keys.favorites.rawValue) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Article].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(error))
        }
    }



    static func save(favorites: [Article]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            
            UserDefaults.standard.set(encodedFavorites, forKey: Keys.favorites.rawValue)
            return nil
        } catch {
            return error
        }
    }
    
}
