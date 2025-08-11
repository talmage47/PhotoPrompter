//
//  PhotoPrompterApp.swift
//  PhotoPrompter
//
//  Created by Talmage Gaisford on 8/8/25.
//

import SwiftUI
import CoreData

@main
struct PhotoPrompterApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
