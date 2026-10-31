import BraisenlySwiftUI
import SwiftUI

public struct AIModelSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding private var configuration: AIInferenceConfiguration

    public let profiles: [AIModelProfile]
    public let platform: BraisenlyPlatform

    public init(
        configuration: Binding<AIInferenceConfiguration>,
        profiles: [AIModelProfile] = AIModelProfile.defaultProfiles,
        platform: BraisenlyPlatform = .automatic
    ) {
        _configuration = configuration
        self.profiles = profiles
        self.platform = platform
    }

    public var body: some View {
        let resolvedPlatform = platform.resolved(horizontalSizeClass: horizontalSizeClass)
        ZStack {
            BraisenlyDS.Colors.surfaceSheet.ignoresSafeArea()
            VStack(spacing: 14) {
                if resolvedPlatform != .mac {
                    Capsule()
                        .fill(BraisenlyDS.Colors.textSecondary.opacity(0.6))
                        .frame(width: 46, height: 5)
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Inference & Model Settings")
                                    .font(BraisenlyDS.Typography.vaultTitle)
                                    .foregroundStyle(BraisenlyDS.Colors.textBright)
                                Text("Choose on-device Apple Foundation Models or cloud endpoints.")
                                    .font(BraisenlyDS.Typography.metadata)
                                    .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                            }
                            Spacer()
                            BraisenlyCircleIconButton(
                                systemName: "xmark",
                                accessibilityLabel: "Close settings",
                                platform: resolvedPlatform,
                                action: { dismiss() }
                            )
                        }

                        BraisenlyStatusCard(
                            title: AIFoundationModelsChatClient.isSystemModelAvailable
                                ? "Apple Foundation Models Ready"
                                : "Smart Local Assistant Active",
                            subtitle: AIFoundationModelsChatClient.isSystemModelAvailable
                                ? "On-device Apple Intelligence is available for private zero-latency inference."
                                : "Using built-in local synthesis engine with automatic fallback when offline.",
                            systemImage: "apple.intelligence",
                            iconColor: BraisenlyDS.Colors.accentTeal
                        )

                        Text("Select Model Profile")
                            .font(BraisenlyDS.Typography.rowLabelMedium)
                            .foregroundStyle(BraisenlyDS.Colors.textBright)

                        BraisenlyActionGroup(
                            items: profiles.map { profile in
                                BraisenlyActionItem(
                                    id: profile.id,
                                    icon: profile.provider.iconName,
                                    title: LocalizedStringResource(stringLiteral: "\(profile.name) — \(profile.subtitle)"),
                                    isChecked: profile.id == configuration.activeProfile.id
                                )
                            },
                            platform: resolvedPlatform
                        ) { selectedItem in
                            if let matched = profiles.first(where: { $0.id == selectedItem.id }) {
                                configuration.activeProfile = matched
                            }
                        }

                        BraisenlyParameterSliderRow(
                            title: "Sampling Temperature",
                            value: $configuration.temperature,
                            in: 0.0...1.5,
                            step: 0.1
                        )

                        VStack(alignment: .leading, spacing: 6) {
                            Text("System Instructions")
                                .font(BraisenlyDS.Typography.metadata)
                                .foregroundStyle(BraisenlyDS.Colors.textSecondary)
                            BraisenlyPromptField(
                                "System instructions…",
                                text: $configuration.systemPrompt
                            )
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Cloud Provider Credentials")
                                .font(BraisenlyDS.Typography.rowLabelMedium)
                                .foregroundStyle(BraisenlyDS.Colors.textBright)

                            BraisenlyKeyEntryField(
                                title: "OpenAI / Compatible API Key",
                                placeholder: "sk-proj-…",
                                text: $configuration.openAIAPIKey
                            )

                            BraisenlyKeyEntryField(
                                title: "Anthropic Claude API Key",
                                placeholder: "sk-ant-…",
                                text: $configuration.anthropicAPIKey
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                    .frame(maxWidth: resolvedPlatform == .mac ? 500 : 620)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, resolvedPlatform == .mac ? 16 : 10)
        }
        .frame(minWidth: resolvedPlatform == .mac ? 480 : nil, minHeight: resolvedPlatform == .mac ? 640 : nil)
    }
}
