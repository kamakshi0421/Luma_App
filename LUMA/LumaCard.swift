import SwiftUI


struct LumaCard<Content: View>: View {
  let content: Content
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    content
      .padding(18)
      .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
      .liquidGlass(cornerRadius: 22)
  }
}
