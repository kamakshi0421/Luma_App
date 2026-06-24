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
        Color.lumaPinkBubble
        .clipShape(RoundedRectangle(cornerRadius: 22))
      )
      .frame(maxWidth: UIScreen.main.bounds.width * 0.75,
          alignment: .trailing)
      .fixedSize(horizontal: false, vertical: true)
      .shadow(
        color: Color.pink.opacity(0.3),
        radius: 12,
        y: 6
      )
  }
  
  
  var aiBubble: some View {
    let sections = parseSections()
    let firstLine = getFirstLine() ?? ""
    
    let isEmergency = message.text.lowercased().contains("emergency")
      || message.text.lowercased().contains("seek immediate")
    
    return VStack(alignment: .leading, spacing: 16) {
      if !firstLine.isEmpty {
        Text(firstLine)
          .font(.system(size: 15, weight: .medium))
          .foregroundColor(
            isEmergency
            ? .red
            : Color.primary
          )
          .lineSpacing(4)
          .fixedSize(horizontal: false, vertical: true)
      }
      
      if sections.isEmpty && firstLine.isEmpty {
        // Fallback for completely unstructured single-block responses
        Text(message.text.replacingOccurrences(of: "**", with: ""))
          .font(.system(size: 14))
          .foregroundColor(.primary)
          .lineSpacing(4)
          .fixedSize(horizontal: false, vertical: true)
      } else {
        ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
          VStack(alignment: .leading, spacing: 8) {
            Text(section.title)
              .font(.system(size: 11, weight: .bold, design: .rounded))
              .foregroundColor(colorForSection(section.title))
              .padding(.horizontal, 10)
              .padding(.vertical, 4)
              .background(colorForSection(section.title).opacity(0.12))
              .clipShape(Capsule())
              .padding(.bottom, 2)
            
            formattedContent(
              section.content,
              color: colorForSection(section.title)
            )
          }
          .padding(.bottom, index == sections.count - 1 ? 0 : 12)
        }
      }
      
      if !isEmergency {
        Text("This is general guidance ")
          .font(.caption2)
          .foregroundColor(.lumaMidGray)
          .padding(.top, 4)
      }
    }
    .padding(20)
    .background(
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(.ultraThinMaterial)
        .overlay(
          RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color.pink.opacity(0.05))
        )
    )
    .overlay(
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .stroke(
          Color.pink.opacity(0.2),
          lineWidth: 1
        )
    )
    .shadow(
      color: isEmergency
      ? Color.red.opacity(0.15)
      : Color.black.opacity(0.06),
      radius: 12,
      y: 6
    )
    .frame(maxWidth: UIScreen.main.bounds.width * 0.82,
        alignment: .leading)
    .fixedSize(horizontal: false, vertical: true)
  }

  struct BulletLine: Identifiable {
    let id = UUID()
    let isBullet: Bool
    let text: String
  }

  func formattedContent(_ content: String,
             color: Color) -> some View {
    let rawLines = content
      .split(separator: "\n")
      .map { String($0) }
      .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    
    let lines: [BulletLine] = rawLines.map { rawLine in
      var line = rawLine.replacingOccurrences(of: "**", with: "")
        .replacingOccurrences(of: "*", with: "")
        .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      
      let isBullet = line.hasPrefix("-") || line.hasPrefix("•")
      
      if isBullet {
        if line.hasPrefix("-") {
          line = String(line.dropFirst())
        } else if line.hasPrefix("•") {
          line = String(line.dropFirst())
        }
        line = line.trimmingCharacters(in: CharacterSet.whitespaces)
      }
      return BulletLine(isBullet: isBullet, text: line)
    }
    
    return VStack(alignment: .leading, spacing: 8) {
      ForEach(lines) { line in
        if line.isBullet {
          HStack(alignment: .top, spacing: 10) {
            Image(systemName: "circle.fill")
              .font(.system(size: 6))
              .foregroundColor(color)
              .padding(.top, 6)
            
            Text(line.text)
              .font(.system(size: 14))
              .foregroundColor(.primary)
              .lineSpacing(4)
              .fixedSize(horizontal: false, vertical: true)
          }
        } else {
          Text(line.text)
            .font(.system(size: 14))
            .foregroundColor(.primary)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
    }
  }
  
  func getFirstLine() -> String? {
    let cleanedText = message.text
      .replacingOccurrences(of: "**---**", with: "---")
    let parts = cleanedText.components(separatedBy: "---")
    
    // If there are no --- dividers, everything is parsed into sections (if there are headers)
    // or printed as a single block. We return nil to prevent double rendering.
    guard parts.count > 1 else { return nil }
    
    guard let first = parts.first else { return nil }
    
    let trimmed = first.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.hasPrefix("") || trimmed.hasPrefix("") || trimmed.hasPrefix("") || trimmed.hasPrefix("") || trimmed.hasPrefix("") || trimmed.hasPrefix("**") {
      return nil
    }
    return trimmed.replacingOccurrences(of: "**", with: "")
  }
  
  func parseSections() -> [SectionData] {
    let cleanedText = message.text
      .replacingOccurrences(of: "**---**", with: "---")
      .replacingOccurrences(of: "### ", with: "--- \n")
    
    let parts = cleanedText.components(separatedBy: "---")
    
    if parts.count <= 1 {
      // Fallback: parse lines looking for emoji headers
      var sections: [SectionData] = []
      let lines = message.text.components(separatedBy: "\n")
      var currentTitle = ""
      var currentContent: [String] = []
      var foundAnyHeader = false
      
      for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { continue }
        
        let isHeader = (trimmed.hasPrefix("**") && trimmed.hasSuffix("**")) ||
                (trimmed.hasPrefix("") || trimmed.hasPrefix("") || trimmed.hasPrefix("") || trimmed.hasPrefix("") || trimmed.hasPrefix(""))
        
        if isHeader {
          foundAnyHeader = true
          if !currentContent.isEmpty || !currentTitle.isEmpty {
            sections.append(SectionData(
              title: currentTitle.isEmpty ? "Insights": currentTitle,
              content: currentContent.joined(separator: "\n")
            ))
            currentContent = []
          }
          currentTitle = trimmed.replacingOccurrences(of: "**", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
          currentContent.append(line)
        }
      }
      
      if !currentContent.isEmpty || !currentTitle.isEmpty {
        sections.append(SectionData(
          title: currentTitle.isEmpty ? "Insights": currentTitle,
          content: currentContent.joined(separator: "\n")
        ))
      }
      
      // If no headers were actually found, return empty array to fall back to a single plain block
      guard foundAnyHeader else { return [] }
      
      return sections.filter { !$0.title.isEmpty && !$0.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    var sections: [SectionData] = []
    for part in parts.dropFirst() {
      let trimmed = part.trimmingCharacters(in: .whitespacesAndNewlines)
      let lines = trimmed.components(separatedBy: "\n")
      
      guard var title = lines.first,
         !title.trimmingCharacters(in: .whitespaces).isEmpty
      else { continue }
      
      title = title.replacingOccurrences(of: "**", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
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
    let cleanTitle = title.lowercased()
    if cleanTitle.contains("what this means") || cleanTitle.contains("means") {
      return Color(red: 0.94, green: 0.52, blue: 0.65) // Pastel Pink
    } else if cleanTitle.contains("possible reasons") || cleanTitle.contains("reasons") || cleanTitle.contains("causes") {
      return Color(red: 0.95, green: 0.65, blue: 0.50) // Pastel Orange
    } else if cleanTitle.contains("is this normal") || cleanTitle.contains("normal") {
      return Color(red: 0.72, green: 0.60, blue: 0.88) // Pastel Purple
    } else if cleanTitle.contains("what you can do") || cleanTitle.contains("do") || cleanTitle.contains("prevention") {
      return Color(red: 0.45, green: 0.76, blue: 0.62) // Pastel Green
    } else if cleanTitle.contains("doctor") || cleanTitle.contains("note") || cleanTitle.contains("medical") {
      return Color(red: 0.90, green: 0.50, blue: 0.50) // Pastel Red
    } else {
      return Color.lumaPinkBubble.opacity(0.85) // Fallback
    }
  }
}

struct SectionData: Identifiable {
  let id = UUID()
  let title: String
  let content: String
}
