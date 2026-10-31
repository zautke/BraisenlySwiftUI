import Foundation
internal import MLX
internal import MLXFast
internal import MLXLLM
internal import MLXLMCommon
internal import MLXNN

// MARK: - Gemma 4 Configuration & Model (Gemma 4 E4B IT 4-bit)

private let kGemma4RMSEps: Float = 1e-6

internal struct AIGemma4Configuration: Codable, Sendable {
    public var modelType: String = "gemma4"
    public var textConfig: AIGemma4TextConfiguration
    public var vocabSize: Int = 262_144

    enum CodingKeys: String, CodingKey {
        case modelType = "model_type"
        case textConfig = "text_config"
        case vocabSize = "vocab_size"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.modelType = try container.decodeIfPresent(String.self, forKey: .modelType) ?? "gemma4"
        self.vocabSize = try container.decodeIfPresent(Int.self, forKey: .vocabSize) ?? 262_144

        if var textConfig = try container.decodeIfPresent(
            AIGemma4TextConfiguration.self,
            forKey: .textConfig
        ) {
            textConfig.vocabSize = self.vocabSize
            self.textConfig = textConfig
        } else {
            self.textConfig = try AIGemma4TextConfiguration(from: decoder)
        }
    }
}

internal struct AIGemma4TextConfiguration: Codable, Sendable {
    public var modelType: String = "gemma4_text"
    public var hiddenSize: Int = 1536
    public var numHiddenLayers: Int = 35
    public var intermediateSize: Int = 6144
    public var numAttentionHeads: Int = 8
    public var headDim: Int = 256
    public var globalHeadDim: Int = 512
    public var globalPartialRotaryFactor: Float = 0.25
    public var rmsNormEps: Float = 1e-6
    public var vocabSize: Int = 262_144
    public var vocabSizePerLayerInput: Int = 262_144
    public var numKeyValueHeads: Int = 1
    public var numGlobalKeyValueHeads: Int?
    public var numKvSharedLayers: Int = 20
    public var hiddenSizePerLayerInput: Int = 256
    public var slidingWindow: Int = 512
    public var slidingWindowPattern: Int = 5
    public var maxPositionEmbeddings: Int = 131_072
    public var attentionKeqV: Bool = false
    public var finalLogitSoftcapping: Float = 30.0
    public var useDoubleWideMlp: Bool = true
    public var layerTypes: [String] = []
    public var tieWordEmbeddings: Bool = true
    public var slidingRopeTheta: Float = 10_000.0
    public var fullRopeTheta: Float = 1_000_000.0
    public var fullPartialRotaryFactor: Float = 1.0

    enum CodingKeys: String, CodingKey {
        case modelType = "model_type"
        case hiddenSize = "hidden_size"
        case numHiddenLayers = "num_hidden_layers"
        case intermediateSize = "intermediate_size"
        case numAttentionHeads = "num_attention_heads"
        case headDim = "head_dim"
        case globalHeadDim = "global_head_dim"
        case globalPartialRotaryFactor = "global_partial_rotary_factor"
        case rmsNormEps = "rms_norm_eps"
        case vocabSize = "vocab_size"
        case vocabSizePerLayerInput = "vocab_size_per_layer_input"
        case numKeyValueHeads = "num_key_value_heads"
        case numGlobalKeyValueHeads = "num_global_key_value_heads"
        case numKvSharedLayers = "num_kv_shared_layers"
        case hiddenSizePerLayerInput = "hidden_size_per_layer_input"
        case slidingWindow = "sliding_window"
        case slidingWindowPattern = "sliding_window_pattern"
        case maxPositionEmbeddings = "max_position_embeddings"
        case attentionKeqV = "attention_k_eq_v"
        case finalLogitSoftcapping = "final_logit_softcapping"
        case useDoubleWideMlp = "use_double_wide_mlp"
        case layerTypes = "layer_types"
        case tieWordEmbeddings = "tie_word_embeddings"
        case ropeParameters = "rope_parameters"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.modelType = try container.decodeIfPresent(String.self, forKey: .modelType) ?? "gemma4_text"
        self.hiddenSize = try container.decodeIfPresent(Int.self, forKey: .hiddenSize) ?? 1536
        self.numHiddenLayers = try container.decodeIfPresent(Int.self, forKey: .numHiddenLayers) ?? 35
        self.intermediateSize = try container.decodeIfPresent(Int.self, forKey: .intermediateSize) ?? 6144
        self.numAttentionHeads = try container.decodeIfPresent(Int.self, forKey: .numAttentionHeads) ?? 8
        self.headDim = try container.decodeIfPresent(Int.self, forKey: .headDim) ?? 256
        self.globalHeadDim = try container.decodeIfPresent(Int.self, forKey: .globalHeadDim) ?? 512
        self.globalPartialRotaryFactor = try container.decodeIfPresent(Float.self, forKey: .globalPartialRotaryFactor) ?? 0.25
        self.rmsNormEps = try container.decodeIfPresent(Float.self, forKey: .rmsNormEps) ?? 1e-6
        self.vocabSize = try container.decodeIfPresent(Int.self, forKey: .vocabSize) ?? 262_144
        self.vocabSizePerLayerInput = try container.decodeIfPresent(Int.self, forKey: .vocabSizePerLayerInput) ?? 262_144
        self.numKeyValueHeads = try container.decodeIfPresent(Int.self, forKey: .numKeyValueHeads) ?? 1
        self.numGlobalKeyValueHeads = try container.decodeIfPresent(Int.self, forKey: .numGlobalKeyValueHeads)
        self.numKvSharedLayers = try container.decodeIfPresent(Int.self, forKey: .numKvSharedLayers) ?? 20
        self.hiddenSizePerLayerInput = try container.decodeIfPresent(Int.self, forKey: .hiddenSizePerLayerInput) ?? 256
        self.slidingWindow = try container.decodeIfPresent(Int.self, forKey: .slidingWindow) ?? 512
        self.slidingWindowPattern = try container.decodeIfPresent(Int.self, forKey: .slidingWindowPattern) ?? 5
        self.maxPositionEmbeddings = try container.decodeIfPresent(Int.self, forKey: .maxPositionEmbeddings) ?? 131_072
        self.attentionKeqV = try container.decodeIfPresent(Bool.self, forKey: .attentionKeqV) ?? false
        self.finalLogitSoftcapping = try container.decodeIfPresent(Float.self, forKey: .finalLogitSoftcapping) ?? 30.0
        self.useDoubleWideMlp = try container.decodeIfPresent(Bool.self, forKey: .useDoubleWideMlp) ?? true
        if let decoded = try container.decodeIfPresent([String].self, forKey: .layerTypes) {
            self.layerTypes = decoded
        } else {
            var pattern = [String]()
            for i in 0..<slidingWindowPattern {
                pattern.append(i == slidingWindowPattern - 1 ? "full_attention" : "sliding_attention")
            }
            var types = [String]()
            while types.count < numHiddenLayers {
                types.append(contentsOf: pattern)
            }
            self.layerTypes = Array(types.prefix(numHiddenLayers))
        }
        self.tieWordEmbeddings = try container.decodeIfPresent(Bool.self, forKey: .tieWordEmbeddings) ?? true

        if let ropeDict = try? container.decodeIfPresent([String: AILFM3RoPELayerConfig].self, forKey: .ropeParameters) {
            self.slidingRopeTheta = ropeDict["sliding_attention"]?.ropeTheta ?? 10_000.0
            self.fullRopeTheta = ropeDict["full_attention"]?.ropeTheta ?? 1_000_000.0
            self.fullPartialRotaryFactor = ropeDict["full_attention"]?.partialRotaryFactor ?? 1.0
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(modelType, forKey: .modelType)
        try container.encode(hiddenSize, forKey: .hiddenSize)
        try container.encode(numHiddenLayers, forKey: .numHiddenLayers)
        try container.encode(intermediateSize, forKey: .intermediateSize)
        try container.encode(numAttentionHeads, forKey: .numAttentionHeads)
        try container.encode(headDim, forKey: .headDim)
        try container.encode(globalHeadDim, forKey: .globalHeadDim)
        try container.encode(vocabSize, forKey: .vocabSize)
    }
}

private final class AIGemma4RMSNormNoScale: Module {
    let eps: Float

    init(eps: Float = 1e-6) {
        self.eps = eps
        super.init()
    }

    func callAsFunction(_ x: MLXArray) -> MLXArray {
        MLXFast.rmsNorm(x, weight: MLXArray.ones([x.dim(-1)], dtype: x.dtype), eps: eps)
    }
}

private struct AIGemma4SharedKV {
    let keys: MLXArray
    let values: MLXArray
}

private final class AIGemma4Attention: Module {
    let config: AIGemma4TextConfiguration
    let layerIdx: Int
    let layerType: String
    let isSliding: Bool
    let effectiveHeadDim: Int
    let nHeads: Int
    let nKvHeads: Int
    let useKeqV: Bool
    let scale: Float

    @ModuleInfo(key: "q_proj") var qProj: Linear
    @ModuleInfo(key: "k_proj") var kProj: Linear?
    @ModuleInfo(key: "v_proj") var vProj: Linear?
    @ModuleInfo(key: "o_proj") var oProj: Linear
    @ModuleInfo(key: "q_norm") var qNorm: RMSNorm
    @ModuleInfo(key: "k_norm") var kNorm: RMSNorm?
    @ModuleInfo(key: "v_norm") var vNorm: AIGemma4RMSNormNoScale
    @ModuleInfo var rope: RoPE

    init(_ config: AIGemma4TextConfiguration, layerIdx: Int) {
        self.config = config
        self.layerIdx = layerIdx
        self.layerType = config.layerTypes[layerIdx]
        self.isSliding = layerType == "sliding_attention"
        self.effectiveHeadDim = isSliding ? config.headDim : config.globalHeadDim

        let dim = config.hiddenSize
        self.nHeads = config.numAttentionHeads
        self.useKeqV = config.attentionKeqV && !isSliding
        if useKeqV, let globalKvHeads = config.numGlobalKeyValueHeads {
            self.nKvHeads = globalKvHeads
        } else {
            self.nKvHeads = config.numKeyValueHeads
        }
        self.scale = 1.0

        self._qProj.wrappedValue = Linear(dim, nHeads * effectiveHeadDim, bias: false)
        let firstKvSharedLayerIdx = config.numHiddenLayers - config.numKvSharedLayers
        let isKvSharedLayer = layerIdx >= firstKvSharedLayerIdx && firstKvSharedLayerIdx > 0
        if !isKvSharedLayer {
            self._kProj.wrappedValue = Linear(dim, nKvHeads * effectiveHeadDim, bias: false)
            if !useKeqV {
                self._vProj.wrappedValue = Linear(dim, nKvHeads * effectiveHeadDim, bias: false)
            }
        }
        self._oProj.wrappedValue = Linear(nHeads * effectiveHeadDim, dim, bias: false)

        self._qNorm.wrappedValue = RMSNorm(dimensions: effectiveHeadDim, eps: config.rmsNormEps)
        if !isKvSharedLayer {
            self._kNorm.wrappedValue = RMSNorm(dimensions: effectiveHeadDim, eps: config.rmsNormEps)
        }
        self._vNorm.wrappedValue = AIGemma4RMSNormNoScale(eps: config.rmsNormEps)

        let partial = isSliding ? 1.0 : config.fullPartialRotaryFactor
        let ropeDims = max(2, Int(Float(effectiveHeadDim) * partial))
        let base = isSliding ? config.slidingRopeTheta : config.fullRopeTheta
        self.rope = RoPE(dimensions: ropeDims, traditional: false, base: base)
        super.init()
    }

    func callAsFunction(
        _ x: MLXArray,
        mask: MLXFast.ScaledDotProductAttentionMaskMode,
        cache: KVCache?,
        sharedKV: AIGemma4SharedKV?,
        positionOffset: Int?
    ) -> (MLXArray, AIGemma4SharedKV, Int?) {
        let (B, L, _) = (x.dim(0), x.dim(1), x.dim(2))

        var queries = qProj(x).reshaped(B, L, nHeads, effectiveHeadDim)
        queries = qNorm(queries)

        let activeOffset = positionOffset ?? cache?.offset
        let kvState: AIGemma4SharedKV

        if let sharedKV {
            kvState = sharedKV
        } else {
            let kRaw = kProj!(x).reshaped(B, L, nKvHeads, effectiveHeadDim)
            var k = kNorm!(kRaw).transposed(0, 2, 1, 3)
            if let activeOffset {
                k = rope(k, offset: activeOffset)
            } else {
                k = rope(k)
            }

            var v: MLXArray
            if let vProj {
                v = vNorm(vProj(x).reshaped(B, L, nKvHeads, effectiveHeadDim)).transposed(0, 2, 1, 3)
            } else {
                v = vNorm(kRaw).transposed(0, 2, 1, 3)
            }

            if let cache {
                let (uk, uv) = cache.update(keys: k, values: v)
                kvState = AIGemma4SharedKV(keys: uk, values: uv)
            } else {
                kvState = AIGemma4SharedKV(keys: k, values: v)
            }
        }

        queries = queries.transposed(0, 2, 1, 3)
        if let activeOffset {
            queries = rope(queries, offset: activeOffset)
        } else {
            queries = rope(queries)
        }

        let attnOut = MLXFast.scaledDotProductAttention(
            queries: queries,
            keys: kvState.keys,
            values: kvState.values,
            scale: scale,
            mask: mask
        )
        .transposed(0, 2, 1, 3)
        .reshaped(B, L, -1)

        return (oProj(attnOut), kvState, activeOffset)
    }
}

private final class AIGemma4MLP: Module {
    @ModuleInfo(key: "gate_proj") var gateProj: Linear
    @ModuleInfo(key: "up_proj") var upProj: Linear
    @ModuleInfo(key: "down_proj") var downProj: Linear

    init(_ config: AIGemma4TextConfiguration, layerIdx: Int) {
        let firstKvSharedLayerIdx = config.numHiddenLayers - config.numKvSharedLayers
        let isKvSharedLayer = layerIdx >= firstKvSharedLayerIdx && firstKvSharedLayerIdx > 0
        let useDoubleWide = config.useDoubleWideMlp && isKvSharedLayer
        let intermediateSize = config.intermediateSize * (useDoubleWide ? 2 : 1)

        self._gateProj.wrappedValue = Linear(config.hiddenSize, intermediateSize, bias: false)
        self._downProj.wrappedValue = Linear(intermediateSize, config.hiddenSize, bias: false)
        self._upProj.wrappedValue = Linear(config.hiddenSize, intermediateSize, bias: false)
        super.init()
    }

    func callAsFunction(_ x: MLXArray) -> MLXArray {
        downProj(geluApproximate(gateProj(x)) * upProj(x))
    }
}

internal final class AIGemma4DecoderLayer: Module {
    let config: AIGemma4TextConfiguration
    let layerIdx: Int
    let layerType: String
    let hiddenSizePerLayerInput: Int

    @ModuleInfo(key: "self_attn") fileprivate var selfAttn: AIGemma4Attention
    @ModuleInfo fileprivate var mlp: AIGemma4MLP
    @ModuleInfo(key: "input_layernorm") var inputLayernorm: RMSNorm
    @ModuleInfo(key: "post_attention_layernorm") var postAttentionLayernorm: RMSNorm
    @ModuleInfo(key: "pre_feedforward_layernorm") var preFeedforwardLayernorm: RMSNorm
    @ModuleInfo(key: "post_feedforward_layernorm") var postFeedforwardLayernorm: RMSNorm
    @ModuleInfo(key: "per_layer_input_gate") var perLayerInputGate: Linear?
    @ModuleInfo(key: "per_layer_projection") var perLayerProjection: Linear?
    @ModuleInfo(key: "post_per_layer_input_norm") var postPerLayerInputNorm: RMSNorm?
    @ModuleInfo(key: "layer_scalar") var layerScalar: MLXArray

    init(_ config: AIGemma4TextConfiguration, layerIdx: Int) {
        self.config = config
        self.layerIdx = layerIdx
        self.layerType = config.layerTypes[layerIdx]
        self.hiddenSizePerLayerInput = config.hiddenSizePerLayerInput

        self._selfAttn.wrappedValue = AIGemma4Attention(config, layerIdx: layerIdx)
        self._mlp.wrappedValue = AIGemma4MLP(config, layerIdx: layerIdx)
        self._inputLayernorm.wrappedValue = RMSNorm(dimensions: config.hiddenSize, eps: config.rmsNormEps)
        self._postAttentionLayernorm.wrappedValue = RMSNorm(dimensions: config.hiddenSize, eps: config.rmsNormEps)
        self._preFeedforwardLayernorm.wrappedValue = RMSNorm(dimensions: config.hiddenSize, eps: config.rmsNormEps)
        self._postFeedforwardLayernorm.wrappedValue = RMSNorm(dimensions: config.hiddenSize, eps: config.rmsNormEps)

        if hiddenSizePerLayerInput > 0 {
            self._perLayerInputGate.wrappedValue = Linear(config.hiddenSize, hiddenSizePerLayerInput, bias: false)
            self._perLayerProjection.wrappedValue = Linear(hiddenSizePerLayerInput, config.hiddenSize, bias: false)
            self._postPerLayerInputNorm.wrappedValue = RMSNorm(dimensions: config.hiddenSize, eps: config.rmsNormEps)
        }
        self._layerScalar.wrappedValue = MLXArray.ones([1], dtype: .float16)
        super.init()
    }

    fileprivate func callAsFunction(
        _ x: MLXArray,
        mask: MLXFast.ScaledDotProductAttentionMaskMode,
        cache: KVCache?,
        perLayerInput: MLXArray?,
        sharedKV: AIGemma4SharedKV?,
        positionOffset: Int?
    ) -> (MLXArray, AIGemma4SharedKV, Int?) {
        let residual = x
        let h = inputLayernorm(x)
        let (attnOut, kvPair, attnPosOffset) = selfAttn(
            h,
            mask: mask,
            cache: cache,
            sharedKV: sharedKV,
            positionOffset: positionOffset
        )
        var out = residual + postAttentionLayernorm(attnOut)
        let residual2 = out
        out = preFeedforwardLayernorm(out)
        out = mlp(out)
        out = residual2 + postFeedforwardLayernorm(out)

        if let gate = perLayerInputGate,
            let proj = perLayerProjection,
            let norm = postPerLayerInputNorm,
            let perLayerInput
        {
            let residual3 = out
            var g = gate(out)
            g = geluApproximate(g) * perLayerInput
            g = proj(g)
            out = residual3 + norm(g)
        }

        out = out * layerScalar
        return (out, kvPair, attnPosOffset)
    }
}

internal final class AIGemma4TextModelInner: Module {
    let config: AIGemma4TextConfiguration
    let embedScale: Float
    let perLayerProjectionScale: Float
    let hiddenSizePerLayerInput: Int

    @ModuleInfo(key: "embed_tokens") var embedTokens: Embedding
    @ModuleInfo(key: "layers") var layers: [AIGemma4DecoderLayer]
    @ModuleInfo var norm: RMSNorm
    @ModuleInfo(key: "embed_tokens_per_layer") var embedTokensPerLayer: Embedding?
    @ModuleInfo(key: "per_layer_model_projection") var perLayerModelProjection: Linear?
    @ModuleInfo(key: "per_layer_projection_norm") var perLayerProjectionNorm: RMSNorm?

    let previousKvs: [Int]
    let firstKvSharedLayerIdx: Int

    init(_ config: AIGemma4TextConfiguration) {
        self.config = config
        self.embedScale = Float(config.hiddenSize).squareRoot()
        self.hiddenSizePerLayerInput = config.hiddenSizePerLayerInput

        self._embedTokens.wrappedValue = Embedding(
            embeddingCount: config.vocabSize,
            dimensions: config.hiddenSize
        )
        self._layers.wrappedValue = (0..<config.numHiddenLayers).map {
            AIGemma4DecoderLayer(config, layerIdx: $0)
        }
        self._norm.wrappedValue = RMSNorm(dimensions: config.hiddenSize, eps: config.rmsNormEps)

        if config.hiddenSizePerLayerInput > 0 {
            self.perLayerProjectionScale = pow(Float(config.hiddenSize), -0.5)
            self._embedTokensPerLayer.wrappedValue = Embedding(
                embeddingCount: config.vocabSizePerLayerInput,
                dimensions: config.numHiddenLayers * config.hiddenSizePerLayerInput
            )
            self._perLayerModelProjection.wrappedValue = Linear(
                config.hiddenSize,
                config.numHiddenLayers * config.hiddenSizePerLayerInput,
                bias: false
            )
            self._perLayerProjectionNorm.wrappedValue = RMSNorm(
                dimensions: config.hiddenSizePerLayerInput,
                eps: config.rmsNormEps
            )
        } else {
            self.perLayerProjectionScale = 1.0
        }

        self.firstKvSharedLayerIdx = config.numHiddenLayers - config.numKvSharedLayers
        var kvMap = Array(0..<config.numHiddenLayers)
        if config.numKvSharedLayers > 0 {
            var lastByType = [String: Int]()
            for i in 0..<firstKvSharedLayerIdx {
                lastByType[config.layerTypes[i]] = i
            }
            for j in firstKvSharedLayerIdx..<config.numHiddenLayers {
                if let prev = lastByType[config.layerTypes[j]] {
                    kvMap[j] = prev
                }
            }
        }
        self.previousKvs = kvMap
        super.init()
    }

    func callAsFunction(_ inputs: MLXArray, cache: [KVCache]? = nil) -> MLXArray {
        let inputEmbeddings = embedTokens(inputs)
        var h = inputEmbeddings * embedScale

        let perLayerInputs: [MLXArray?]
        if hiddenSizePerLayerInput > 0,
            let embedPerLayer = embedTokensPerLayer,
            let modelProj = perLayerModelProjection,
            let projNorm = perLayerProjectionNorm
        {
            let tokenPLE = embedPerLayer(inputs) * Float(config.hiddenSizePerLayerInput).squareRoot()
            let reshapedTokenPLE = tokenPLE.reshaped(
                tokenPLE.dim(0),
                tokenPLE.dim(1),
                config.numHiddenLayers,
                config.hiddenSizePerLayerInput
            )
            let modelPLE = (modelProj(h) * perLayerProjectionScale).reshaped(
                h.dim(0),
                h.dim(1),
                config.numHiddenLayers,
                config.hiddenSizePerLayerInput
            )
            let normedModelPLE = projNorm(modelPLE)
            let perLayerInputScale = pow(Float(2.0), -0.5)
            let combined = (normedModelPLE + reshapedTokenPLE) * perLayerInputScale
            perLayerInputs = (0..<config.numHiddenLayers).map { i in
                combined[.ellipsis, i, 0...]
            }
        } else {
            perLayerInputs = Array(repeating: nil, count: config.numHiddenLayers)
        }

        var fullCache: [KVCache?]
        if let cache {
            fullCache = cache.map { Optional($0) }
            while fullCache.count < config.numHiddenLayers {
                fullCache.append(nil)
            }
        } else {
            fullCache = Array(repeating: nil, count: config.numHiddenLayers)
        }

        var maskByType = [String: MLXFast.ScaledDotProductAttentionMaskMode]()
        for (i, layer) in layers.enumerated() {
            let lt = layer.layerType
            if maskByType[lt] == nil {
                maskByType[lt] = createAttentionMask(
                    h: h,
                    cache: fullCache[i].map { [$0] }
                )
            }
        }

        var intermediates = [(kv: AIGemma4SharedKV?, positionOffset: Int?)](
            repeating: (nil, nil),
            count: config.numHiddenLayers
        )

        for (idx, layer) in layers.enumerated() {
            let prevIdx = previousKvs[idx]
            let sharedKV = intermediates[prevIdx].kv
            let sharedPosOffset = intermediates[prevIdx].positionOffset
            let mask = maskByType[layer.layerType] ?? .none
            let (out, kvPair, posOffset) = layer(
                h,
                mask: mask,
                cache: fullCache[idx],
                perLayerInput: perLayerInputs[idx],
                sharedKV: sharedKV,
                positionOffset: sharedPosOffset
            )
            h = out
            intermediates[idx] = (kvPair, posOffset)
        }

        return norm(h)
    }
}

internal final class AIGemma4TextModel: Module, LLMModel, KVCacheDimensionProvider, LoRAModel {
    public let vocabularySize: Int
    public let kvHeads: [Int]
    fileprivate let config: AIGemma4TextConfiguration
    public let model: AIGemma4TextModelInner

    @ModuleInfo(key: "lm_head") var lmHead: Linear?

    public init(_ config: AIGemma4TextConfiguration) {
        self.config = config
        self.vocabularySize = config.vocabSize
        self.kvHeads = (0..<config.numHiddenLayers).map { _ in config.numKeyValueHeads }
        self.model = AIGemma4TextModelInner(config)
        if !config.tieWordEmbeddings {
            self._lmHead.wrappedValue = Linear(config.hiddenSize, config.vocabSize, bias: false)
        }
    }

    public func callAsFunction(_ inputs: MLXArray, cache: [KVCache]?) -> MLXArray {
        var out = model(inputs, cache: cache)
        if let lmHead {
            out = lmHead(out)
        } else {
            out = model.embedTokens.asLinear(out)
        }
        return tanh(out / config.finalLogitSoftcapping) * config.finalLogitSoftcapping
    }

    public func sanitize(weights: [String: MLXArray]) -> [String: MLXArray] {
        let firstKvSharedLayerIdx = config.numHiddenLayers - config.numKvSharedLayers
        var sanitized = [String: MLXArray]()
        for (key, value) in weights {
            if config.tieWordEmbeddings && key.hasPrefix("lm_head.") {
                continue
            }
            if key.contains("self_attn.rotary_emb")
                || key.contains("input_max")
                || key.contains("input_min")
                || key.contains("output_max")
                || key.contains("output_min")
            {
                continue
            }
            if firstKvSharedLayerIdx > 0,
                key.contains("self_attn.k_proj")
                    || key.contains("self_attn.v_proj")
                    || key.contains("self_attn.k_norm"),
                let layerIdx = Self.decoderLayerIndex(in: key),
                layerIdx >= firstKvSharedLayerIdx
            {
                continue
            }
            sanitized[key] = value
        }
        return sanitized
    }

    private static func decoderLayerIndex(in key: String) -> Int? {
        guard let range = key.range(of: "layers.") else { return nil }
        let digits = key[range.upperBound...].prefix { $0.isNumber }
        return Int(digits)
    }

    public func newCache(parameters: GenerateParameters?) -> [KVCache] {
        let firstKvShared = config.numHiddenLayers - config.numKvSharedLayers
        return (0..<firstKvShared).map { i in
            if config.layerTypes[i] != "full_attention" {
                return RotatingKVCache(maxSize: config.slidingWindow, keep: 0)
            } else {
                return KVCacheSimple()
            }
        }
    }

    public var loraLayers: [Module] {
        model.layers
    }
}

internal final class AIGemma4Model: Module, LLMModel, KVCacheDimensionProvider, LoRAModel {
    public var vocabularySize: Int { languageModel.vocabularySize }
    public var kvHeads: [Int] { languageModel.kvHeads }

    @ModuleInfo(key: "language_model") public var languageModel: AIGemma4TextModel

    public init(_ config: AIGemma4Configuration) {
        self._languageModel.wrappedValue = AIGemma4TextModel(config.textConfig)
    }

    public func callAsFunction(_ inputs: MLXArray, cache: [KVCache]?) -> MLXArray {
        languageModel(inputs, cache: cache)
    }

    public func sanitize(weights: [String: MLXArray]) -> [String: MLXArray] {
        var sanitized = [String: MLXArray]()
        for (key, value) in weights {
            var k = key
            let startsWithModel = k.hasPrefix("model.")
            k = k.replacingOccurrences(of: "model.", with: "", options: .anchored)
            if k.hasPrefix("vision_tower")
                || k.hasPrefix("multi_modal_projector")
                || k.hasPrefix("audio_tower")
                || k.hasPrefix("embed_audio")
                || k.hasPrefix("embed_vision")
                || k.hasPrefix("vision_embedder")
            {
                continue
            }
            if !startsWithModel {
                sanitized[k] = value
                continue
            }
            if k.hasPrefix("language_model") {
                k = k.replacingOccurrences(
                    of: "language_model.",
                    with: "language_model.model.",
                    options: .anchored
                )
            }
            sanitized[k] = value
        }
        return languageModel.sanitize(weights: sanitized)
    }

    public func newCache(parameters: GenerateParameters?) -> [KVCache] {
        languageModel.newCache(parameters: parameters)
    }

    public var loraLayers: [Module] {
        languageModel.loraLayers
    }
}
