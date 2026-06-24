
import SwiftUI
import Foundation

struct GlobalInfoButton: View {
  
  let tab: LumaTab
  @State private var showInfo = false
  
  var body: some View {
    Button {
      showInfo = true
    } label: {
      Image(systemName: "info.circle")
        .font(.title3)
        .foregroundColor(.lumaDarkGray)
    }
    .sheet(isPresented: $showInfo) {
      InfoSheetView(tab: tab)
        .presentationDetents([.medium])
    }
  }
}

