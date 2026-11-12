import BraisenlySwiftUI
import SwiftUI

public struct AIModelSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.braisenlyTheme) private var theme
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
            theme.colors.surfaceSheet.ignoresSafeArea()
            VStack(spacing: theme.metrics.spacing[.m]) {
                if resolvedPlatform != .mac {
                    Capsule()
                        .fill(theme.colors.textSecondary.opacity(0.6))
                        .frame(width: theme.metrics.grabberSize.width, height: theme.metrics.grabberSize.height)
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: theme.metrics.spacing[.l]) {
                        HStack {
                            VStack(alignment: .leading, spacing: theme.metrics.spacing[.xs]) {
                                Text("Inference & Model Settings")
                                    .font(theme.typography.vaultTitle)
                                    .foregroundStyle(theme.colors.textBright)
                                Text("Pluggable on-device open-weight MLX models, Apple Foundation Models, and cloud endpoints.")
                                    .font(theme.typography.metadata)
                                    .foregroundStyle(theme.colors.textSecondary)
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
                            iconColor: theme.colors.accentTeal
                        )

                        if !openWeightModels.isEmpty {
                            Text("Pluggable On-Device Open-Weight Models (MLX)")
                                .font(theme.typography.rowLabelMedium)
                                .foregroundStyle(theme.colors.textBright)

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
                                .font(theme.typography.rowLabelMedium)
                                .foregroundStyle(theme.colors.textBright)

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

                        VStack(alignment: .leading, spacing: theme.metrics.spacing[.s]) {
                            Text("System Instructions")
                                .font(theme.typography.metadata)
                                .foregroundStyle(theme.colors.textSecondary)
                            BraisenlyPromptField(
                                "System instructions…",
                                text: $configuration.systemPrompt
                            )
                        }

                        VStack(alignment: .leading, spacing: theme.metrics.spacing[.m]) {
                            Text("Cloud Provider Credentials")
                                .font(theme.typography.rowLabelMedium)
                                .foregroundStyle(theme.colors.textBright)

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
                    .padding(.horizontal, theme.metrics.spacing[.l])
                    .padding(.bottom, theme.metrics.spacing[.xl])
                    .frame(maxWidth: resolvedPlatform == .mac ? 500 : 620)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, resolvedPlatform == .mac ? theme.metrics.spacing[.l] : theme.metrics.spacing[.s])
        }
        .frame(minWidth: resolvedPlatform == .mac ? 480 : nil, minHeight: resolvedPlatform == .mac ? 640 : nil)
    }
}
