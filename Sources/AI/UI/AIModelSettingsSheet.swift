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
        let openWeightModels = profiles.filter(\.isLocalMLX)
        let systemAndCloudModels = profiles.filter { !$0.isLocalMLX }

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
                                Text("Pluggable on-device open-weight MLX models, Apple Foundation Models, and cloud endpoints.")
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
                            title: configuration.activeProfile.isLocalMLX
                                ? "\(configuration.activeProfile.name) (\(configuration.activeProfile.quantization))"
                                : (AIFoundationModelsChatClient.isSystemModelAvailable
                                    ? "Apple Foundation Models Ready"
                                    : "Smart Local Assistant Active"),
                            subtitle: configuration.activeProfile.isLocalMLX
                                ? "\(configuration.activeProfile.family) • \(configuration.activeProfile.parameterCount) • \(configuration.activeProfile.contextWindow / 1024)K context window"
                                : (AIFoundationModelsChatClient.isSystemModelAvailable
                                    ? "On-device Apple Intelligence is available for private zero-latency inference."
                                    : "Using built-in local synthesis engine with automatic fallback when offline."),
                            systemImage: configuration.activeProfile.provider.iconName,
                            iconColor: BraisenlyDS.Colors.accentTeal
                        )

                        if !openWeightModels.isEmpty {
                            Text("Pluggable On-Device Open-Weight Models (MLX)")
                                .font(BraisenlyDS.Typography.rowLabelMedium)
                                .foregroundStyle(BraisenlyDS.Colors.textBright)

                            BraisenlyActionGroup(
                                items: openWeightModels.map { profile in
                                    BraisenlyActionItem(
                                        id: profile.id,
                                        icon: profile.provider.iconName,
                                        title: LocalizedStringResource(stringLiteral: "\(profile.name) — \(profile.subtitle)"),
                                        isChecked: profile.id == configuration.activeProfile.id
                                    )
                                },
                                platform: resolvedPlatform
                            ) { selectedItem in
                                if let matched = openWeightModels.first(where: { $0.id == selectedItem.id }) {
                                    configuration.activeProfile = matched
                                    configuration.temperature = matched.defaultTemperature
                                }
                            }
                        }

                        if !systemAndCloudModels.isEmpty {
                            Text("Apple Intelligence & Cloud Endpoints")
                                .font(BraisenlyDS.Typography.rowLabelMedium)
                                .foregroundStyle(BraisenlyDS.Colors.textBright)

                            BraisenlyActionGroup(
                                items: systemAndCloudModels.map { profile in
                                    BraisenlyActionItem(
                                        id: profile.id,
                                        icon: profile.provider.iconName,
                                        title: LocalizedStringResource(stringLiteral: "\(profile.name) — \(profile.subtitle)"),
                                        isChecked: profile.id == configuration.activeProfile.id
                                    )
                                },
                                platform: resolvedPlatform
                            ) { selectedItem in
                                if let matched = systemAndCloudModels.first(where: { $0.id == selectedItem.id }) {
                                    configuration.activeProfile = matched
                                }
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
