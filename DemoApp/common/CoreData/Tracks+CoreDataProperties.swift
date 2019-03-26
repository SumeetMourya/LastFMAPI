//
//  Tracks+CoreDataProperties.swift
//  DemoApp
//
//  Created by sumeet mourya on 25/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//
//

import Foundation
import CoreData


extension Tracks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tracks> {
        return NSFetchRequest<Tracks>(entityName: "Tracks")
    }
    
    @nonobjc public class func fetchRequestWith(albumID: String) -> NSFetchRequest<Tracks> {
        let request: NSFetchRequest<Tracks> = Tracks.fetchRequest()
        request.predicate = NSPredicate(format: "albumMBID == %@ ", albumID)
        request.sortDescriptors = [NSSortDescriptor(key: "trackOrder", ascending: true)]
        return request
    }
    
    @nonobjc public class func fetchRequestWith(artistName: String, albumName: String) -> NSFetchRequest<Tracks> {
        let request: NSFetchRequest<Tracks> = Tracks.fetchRequest()
        request.predicate = NSPredicate(format: "artistName == %@ AND albumName == %@", artistName, albumName)
        request.sortDescriptors = [NSSortDescriptor(key: "trackOrder", ascending: true)]
        return request
    }
    
    @nonobjc public class func fetchRequestResultWith(albumID: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tracks")
        request.predicate = NSPredicate(format: "albumMBID == %@ ", albumID)
//        request.sortDescriptors = [NSSortDescriptor(key: "trackOrder", ascending: true)]
        return request
    }

    @nonobjc public class func fetchRequestResultWith(artistName: String, albumName: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Tracks")
        request.predicate = NSPredicate(format: "artistName == %@ AND albumName == %@", artistName, albumName)
        return request
    }

    
    @NSManaged public var trackDuration: String?
    @NSManaged public var trackName: String?
    @NSManaged public var trackOrder: Int32
    @NSManaged public var trackURL: String?
    @NSManaged public var albumMBID: String?
    @NSManaged public var artistName: String?
    @NSManaged public var albumName: String?

}
