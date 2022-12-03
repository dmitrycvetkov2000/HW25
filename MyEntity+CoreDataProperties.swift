//
//  MyEntity+CoreDataProperties.swift
//  HW25
//
//  Created by Дмитрий Цветков on 02.12.2022.
//
//

import Foundation
import CoreData


extension MyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyEntity> {
        return NSFetchRequest<MyEntity>(entityName: "MyEntity")
    }

    @NSManaged public var name: String?

}

extension MyEntity : Identifiable {

}
