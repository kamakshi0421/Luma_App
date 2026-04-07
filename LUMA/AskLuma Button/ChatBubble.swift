import SwiftUI
import Foundation

struct ChatBubble: View {
    
    let message: ChatMessage
    
    var body: some View {
        HStack {
            
            if message.isUser { Spacer() }
            
            if message.isUser {
                userBubble
            } else {
                aiBubble
            }
            
            if !message.isUser { Spacer() }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
    }
    
    
    var userBubble: some View {
        Text(message.text)
            .font(.system(size: 15, weight: .medium))
            .padding(16)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.lumaAccent)
            )
            .frame(maxWidth: UIScreen.main.bounds.width * 0.75,
                   alignment: .trailing)
            .fixedSize(horizontal: false, vertical: true)
            .shadow(
                color: Color.lumaAccent.opacity(0.45),
                radius: 12,
                y: 6
            )
    }
    
   
    var aiBubble: some View {
        
        let sections = parseSections()
        let firstLine = getFirstLine() ?? ""
        
        let isEmergency = message.text.lowercased().contains("emergency")
            || message.text.lowercased().contains("seek immediate")
        
        return VStack(alignment: .leading, spacing: 18) {
            
           
            if !firstLine.isEmpty {
                Text(firstLine)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(
                        isEmergency
                        ? .red
                        : Color.lumaDarkGray.opacity(0.9)
                    )
                    .lineSpacing(3)
            }
            
            
            ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(section.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(colorForSection(section.title))
                    
                    formattedContent(
                        section.content,
                        color: colorForSection(section.title)
                    )
                }
                
                
                if index != sections.count - 1 {
                    Rectangle()
                        .fill(Color.lumaDarkGray.opacity(0.18))
                        .frame(height: 1)
                        .padding(.vertical, 4)
                }
            }
            
            if !isEmergency {
                Text("This is general guidance 💕")
                    .font(.caption2)
                    .foregroundColor(.lumaMidGray)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.lumaSurface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.lumaAccent.opacity(0.12), lineWidth: 1)
        )
        .shadow(
            color: isEmergency
            ? Color.red.opacity(0.18)
            : Color.lumaAccent.opacity(0.08),
            radius: 10,
            y: 5
        )
        .frame(maxWidth: UIScreen.main.bounds.width * 0.8,
               alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }
    func formattedContent(_ content: String,
                          color: Color) -> some View {
        
        let lines = content
            .split(separator: "\n")
            .map { String($0) }
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        return VStack(alignment: .leading, spacing: 8) {
            
            ForEach(lines, id: \.self) { line in
                
                if line.hasPrefix("-") {
                    
                    HStack(alignment: .top, spacing: 10) {
                        
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .foregroundColor(color)
                            .padding(.top, 6)
                        
                        Text(
                            line
                                .replacingOccurrences(of: "-", with: "")
                                .trimmingCharacters(in: .whitespaces)
                        )
                        .font(.system(size: 14))
                        .foregroundColor(.lumaDarkGray)
                        .lineSpacing(4)
                    }
                    
                } else {
                    
                    Text(line)
                        .font(.system(size: 14))
                        .foregroundColor(.lumaDarkGray)
                        .lineSpacing(4)
                }
            }
        }
    }
    
    func getFirstLine() -> String? {
        let parts = message.text.components(separatedBy: "---")
        return parts.first?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func parseSections() -> [SectionData] {
        
        let parts = message.text.components(separatedBy: "---")
        guard parts.count > 1 else { return [] }
        
        var sections: [SectionData] = []
        
        for part in parts.dropFirst() {
            
            let trimmed = part.trimmingCharacters(in: .whitespacesAndNewlines)
            let lines = trimmed.components(separatedBy: "\n")
            
            guard let title = lines.first,
                  !title.trimmingCharacters(in: .whitespaces).isEmpty
            else { continue }
            
            let content = lines.dropFirst().joined(separator: "\n")
            
            sections.append(
                SectionData(
                    title: title,
                    content: content
                )
            )
        }
        
        return sections
    }
    
    func colorForSection(_ title: String) -> Color {
        
        if title.contains("What This Means") {
            return .pink
        } else if title.contains("Possible Reasons") {
            return .orange
        } else if title.contains("Is This Normal") {
            return .purple
        } else if title.contains("What You Can Do") {
            return .green
        } else if title.contains("Doctor") {
            return .red
        } else {
            return .lumaAccent
        }
    }
}

struct SectionData: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}
