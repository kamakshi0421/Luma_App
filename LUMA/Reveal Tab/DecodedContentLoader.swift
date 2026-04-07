import Foundation

final class DecodedContentLoader {
    
    static func load() -> RevealContent {
        
        guard let url = Bundle.main.url(forResource: "decoded_content", withExtension: "json") else {
            return emptyContent()
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(RevealContent.self, from: data)
        } catch {
            return emptyContent()
        }
    }
    
    private static func emptyContent() -> RevealContent {
        RevealContent(
            myths: [],
            commonConcerns: [],
            redFlags: []
        )
    }
}
