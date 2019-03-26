//
//  Albums+CoreDataProperties.swift
//  DemoApp
//
//  Created by sumeet mourya on 25/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//
//

import Foundation
import CoreData


extension Albums {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Albums> {
        return NSFetchRequest<Albums>(entityName: "Albums")
    }

    @nonobjc public class func fetchRequestWith(albumID: String) -> NSFetchRequest<Albums> {
        let request: NSFetchRequest<Albums> = Albums.fetchRequest()
        request.predicate = NSPredicate(format: "albumMBID == %@ ", albumID)
        request.sortDescriptors = [NSSortDescriptor(key: "albumName", ascending: true)]
        return request
    }

    @nonobjc public class func fetchRequestWith(artistName: String) -> NSFetchRequest<Albums> {
        let request: NSFetchRequest<Albums> = Albums.fetchRequest()
        request.predicate = NSPredicate(format: "artistName == %@ ", artistName)
        request.sortDescriptors = [NSSortDescriptor(key: "albumName", ascending: true)]
        return request
    }
    
    @nonobjc public class func fetchRequestWith(artistMBID: String, artistName: String, albumName: String) -> NSFetchRequest<Albums> {
        let request: NSFetchRequest<Albums> = Albums.fetchRequest()
        request.predicate = NSPredicate(format: "artistMBID == %@ AND artistName == %@ AND albumName == %@", artistMBID, artistName, albumName)
        request.sortDescriptors = [NSSortDescriptor(key: "artistMBID", ascending: true)]
        return request
    }

    @nonobjc public class func fetchRequestWith(artistMBID: String, artistName: String) -> NSFetchRequest<Albums> {
        let request: NSFetchRequest<Albums> = Albums.fetchRequest()
        request.predicate = NSPredicate(format: "artistMBID == %@ AND artistName == %@", artistMBID, artistName)
        request.sortDescriptors = [NSSortDescriptor(key: "artistMBID", ascending: true)]
        return request
    }

    @nonobjc public class func fetchRequestWith(artistName: String, albumName: String) -> NSFetchRequest<Albums> {
        let request: NSFetchRequest<Albums> = Albums.fetchRequest()
        request.predicate = NSPredicate(format: "artistName == %@ AND albumName == %@", artistName, albumName)
        request.sortDescriptors = [NSSortDescriptor(key: "artistMBID", ascending: true)]
        return request
    }
    
    @nonobjc public class func fetchRequestResultWith(albumID: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Albums")
        request.predicate = NSPredicate(format: "albumMBID == %@ ", albumID)
        request.sortDescriptors = [NSSortDescriptor(key: "albumName", ascending: true)]
        return request
    }

    @nonobjc public class func fetchRequestResultWith(artistName: String, albumName: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request: NSFetchRequest<NSFetchRequestResult> = Albums.fetchRequest()
        request.predicate = NSPredicate(format: "artistName == %@ AND albumName == %@", artistName, albumName)
        request.sortDescriptors = [NSSortDescriptor(key: "artistMBID", ascending: true)]
        return request
    }


    @NSManaged public var albumCoverLargeImageURL: String?
    @NSManaged public var albumCoverSmallImageURL: String?
    @NSManaged public var albumListenersCount: String?
    @NSManaged public var albumName: String?
    @NSManaged public var albumPlayCount: Int32
    @NSManaged public var albumMBID: String?
    @NSManaged public var albumURL: String?
    @NSManaged public var artistName: String?
    @NSManaged public var artistMBID: String?

}


