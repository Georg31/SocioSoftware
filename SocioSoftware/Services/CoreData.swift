//
//  CoreData.swift
//  SocioSoftware
//
//  Created by George Digmelashvili on 9/21/21.
//

import UIKit
import CoreData

class Dbase {

    static let shared = Dbase()
    private let context = AppDelegate.coreDataContainer.viewContext
    private init() {}

    func saveBackGround(_ image: UIImage) {
        deleteAllData()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Backgrounds", in: context)
        let photoDB = Backgrounds(entity: entityDescription!, insertInto: context)
        photoDB.image = image.pngData()
        photoDB.dateTime = Date()
        do {
            try context.save()

        } catch {
            print(error.localizedDescription)
        }
    }

    func getBackGround() -> UIImage? {
        let request: NSFetchRequest<Backgrounds> = Backgrounds.fetchRequest()
        var img: UIImage?
        do {
            let result = try context.fetch(request)

            img = UIImage(data: result.first?.image ?? Data())

        } catch {
            print(error.localizedDescription)
        }
        return img
    }

    private func deleteAllData()
    {
        let Request = NSFetchRequest<NSFetchRequestResult>(entityName: "Backgrounds")
        let DelAll = NSBatchDeleteRequest(fetchRequest: Request)
        do { try context.execute(DelAll) }
        catch { print(error) }
    }

}

