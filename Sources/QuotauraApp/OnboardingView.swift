import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var step = 0
    @State private var selectedUseCases: Set<String> = ["Proyectos"]

    private let useCases = ["Proyectos", "Documentos", "Investigación", "Imágenes", "Automatizaciones"]

    var body: some View {
        VStack(spacing: 22) {
            Spacer()

            Image(systemName: step == 0 ? "gauge.with.dots.needle.50percent" : "graduationcap.fill")
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            VStack(spacing: 8) {
                Text(step == 0 ? "Haz que tu cuota dure más" : "Tu primera protección")
                    .font(.title2.bold())
                Text(step == 0
                     ? "Quotaura te avisará antes de que tu capacidad de trabajo se agote."
                     : "Te recomendaremos cargar solo el contexto necesario y te avisaremos al 75% y 90% de consumo.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            if step == 0 {
                VStack(alignment: .leading, spacing: 10) {
                    Text("¿Para qué utilizas la IA?")
                        .font(.headline)
                    FlowLayout(spacing: 8) {
                        ForEach(useCases, id: \.self) { useCase in
                            ToggleChip(
                                title: useCase,
                                isSelected: selectedUseCases.contains(useCase)
                            ) {
                                if selectedUseCases.contains(useCase) {
                                    selectedUseCases.remove(useCase)
                                } else {
                                    selectedUseCases.insert(useCase)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Alertas preventivas activadas", systemImage: "bell.badge.fill")
                    Label("Guías adaptadas a tu trabajo", systemImage: "book.pages.fill")
                    Label("Alternativas cuando se agote una cuota", systemImage: "lifepreserver.fill")
                }
                .font(.subheadline)
            }

            Spacer()

            Button(step == 0 ? "Continuar" : "Comenzar") {
                if step == 0 { step = 1 } else { onComplete() }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Text("Puedes cambiar estas preferencias después.")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(24)
    }
}

private struct ToggleChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.medium))
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(isSelected ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.1))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, point) in result.points.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, points: [CGPoint]) {
        let maxWidth = proposal.width ?? 360
        var points: [CGPoint] = []
        var cursor = CGPoint.zero
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if cursor.x + size.width > maxWidth, cursor.x > 0 {
                cursor.x = 0
                cursor.y += rowHeight + spacing
                rowHeight = 0
            }
            points.append(cursor)
            cursor.x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return (CGSize(width: maxWidth, height: cursor.y + rowHeight), points)
    }
}
