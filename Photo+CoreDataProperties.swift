//
//  Photo+CoreDataProperties.swift
//  HW25
//
//  Created by Дмитрий Цветков on 03.12.2022.
//
//

import Foundation
import UIKit
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var content: UIImageView?
    @NSManaged public var title: String?

}

extension Photo : Identifiable {

}
