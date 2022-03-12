//
//  DataPersistenceManager.swift
//  NetflixApp
//
//  Created by Кирилл Тила on 12.03.2022.
//

import CoreData
import UIKit

final class DataPersistenceManager {
    
    static let shared: DataPersistenceManager = .init()
    
    private init() {}
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        item.id = Int64(model.id)
        item.originalTitle = model.originalTitle
        item.originalName = model.originalName
        item.overview = model.overview
        item.mediaType = model.mediaType
        item.posterPath = model.posterPath
        item.releaseDate = model.releaseDate
        item.voteCount = Int64(model.voteCount)
        item.voteAverage = model.voteAverage
        
        do {
            try context.save()
            completion(.success(print("📥 downloadTitleWith — Succses")))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    func fetchingTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) ->Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let requset: NSFetchRequest<TitleItem>
        requset = TitleItem.fetchRequest()
        do {
            let titles = try context.fetch(requset)
            completion(.success(titles))
            print("📤 Fetching Sucsses!")
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) ->Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(print("🗑 Delete Succsess")))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
}
