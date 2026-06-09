//
//  FileIO.swift
//  DailyReview
//
//  Created by Danny Hazley on 09/06/2026.
//

import Foundation


struct FileIO {
    static var badWrite = "ERROR"
    
    static func saveFolder(_ url: URL, for reviewType: ReviewType){
        do {
            let didAccess = url.startAccessingSecurityScopedResource()
            
            defer {
                if didAccess {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            let bookmarkData = try url.bookmarkData(
                options: [],
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            
            UserDefaults.standard.set(bookmarkData, forKey: reviewType.folderBookmarkKey)
            
            print("Saved folder for \(reviewType.rawValue)")
        } catch {
            print("Failed to save folder: \(error)")
        }
    }
    
    static func writeMarkdown(from input: SavedReview, using template: ReviewTemplate) -> String{
        var result: (markdown: String, filename: String)?
        var type: ReviewType?
        
        switch(template.id){
        case("daily-work-note"):
            result = DailyMarkdownRenderer(input: input, template: template).render()
            type = .daily
        case("weekly-work-note"):
            result = WeeklyMarkdownRenderer(input: input, template: template).render()
            type = .weekly
        case("monthly-work-review"):
            result = MonthlyMarkdownRenderer(input: input, template: template).render()
            type = .monthly
        default:
            print("Unknown template id: \(template.id)")
            return badWrite
        }
        
        
        guard let type, let result else {
            print("Unknown template id: \(template.id)")
            return badWrite
        }

        return writeMarkdownFile(for: type, with: result.markdown, as: result.filename)
    }
    
    private static func loadFolder(for reviewType: ReviewType) -> URL? {
        guard let bookmarkData = UserDefaults.standard.data(forKey: reviewType.folderBookmarkKey) else {
            print("No saved folder for \(reviewType.rawValue)")
            return nil
        }
        
        do {
            var isStale = false
            
            let folderURL = try URL(
                resolvingBookmarkData: bookmarkData,
                options: [],
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
                )
            
            if isStale {
                print("Saved folder bookmark is stale for \(reviewType.rawValue)")
                return nil
            }
            
            return folderURL
        } catch {
            print("Failed to load folder for \(reviewType.rawValue): \(error)")
            return nil
        }
    }
    
    private static func writeMarkdownFile(for reviewType: ReviewType, with markdown: String, as filename: String) -> String{
        guard let folderURL = loadFolder(for: reviewType) else { return badWrite }
        
        let didAccess = folderURL.startAccessingSecurityScopedResource()
        
        defer {
            if didAccess {
                folderURL.stopAccessingSecurityScopedResource()
            }
        }
        
        let fileURL = folderURL.appendingPathComponent("\(filename).md")
        
        do {
            try markdown.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Saved markdown file to: \(fileURL)")
            return "\(fileURL)"
        } catch {
            print("Failed to write markdown file: \(error)")
            return badWrite
        }
    }
}
