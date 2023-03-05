//
//  DataPersistentManager.swift
//  NetflixClone
//
//  Created by Halis Kayar on 5.03.2023.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSavedData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        
        item.originalTitle = model.originalTitle
        item.id = Int64(model.id!)
        item.originalName = model.originalName
        item.overview = model.overview
        item.posterPath = model.posterPath
        item.mediaType = model.mediaType
        item.releaseDate = model.releaseDate
        item.voteAverage = model.voteAverage!
        item.voteCount = Int64(model.voteCount!)
        
        do {
         try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSavedData))
        }
    }
    
    func fetchingTitlesFromDatabase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
}
