import SwiftUI

@available(iOS 26.0, *)
struct ConcernDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let topic: NormalTopic
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(topic.shortDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text("Why this happens")
                                .font(.headline)
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "waveform.path.ecg")
                                .foregroundColor(.purple)
                        }
                        
                        Text(topic.whyItHappens)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 4)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text("When it is normal")
                                .font(.headline)
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "checkmark.seal")
                                .foregroundColor(.green)
                        }
                        
                        Text(topic.whenItsNormal)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 4)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text("What may help")
                                .font(.headline)
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "leaf")
                                .foregroundColor(.pink)
                        }
                        
                        Text(topic.whatHelps)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 4)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text("When to seek a doctor")
                                .font(.headline)
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "stethoscope")
                                .foregroundColor(.orange)
                        }
                        
                        Text(topic.whenToSeekHelp)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(topic.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Text("Your body communicates through patterns. Listening to it is a strength.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
