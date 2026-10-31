import Foundation
internal import MLX
internal import MLXFast
internal import MLXLLM
internal import MLXLMCommon
internal import MLXNN

// MARK: - LFM3 Tri-Hybrid Configuration (LFM3-1.7B & LFM3-Omni-2B)

internal struct AILFM3RoPELayerConfig: Codable, Sendable {
    public var partialRotaryFactor: Float?
    public var ropeTheta: Float?
    public var ropeType: String?

    enum CodingKeys: String, CodingKey {
        case partialRotaryFactor = "partial_rotary_factor"
        case ropeTheta = "rope_theta"
        case ropeType = "rope_type"
    }
}

internal struct AILFM3Configuration: Codable, Sendable {
    public var modelType: String
    public var vocabularySize: Int
    public var hiddenSize: Int
    public var hiddenLayers: Int
    public var attentionHeads: Int
    public var kvHeads: Int
    public var headDim: Int
    public var intermediateSize: Int
    public var maxPositionEmbeddings: Int
    public var normEps: Float
    public var convBias: Bool
    public var convLCache: Int
    public var slidingWindow: Int
    public var useSandwichNorm: Bool
    public var tieWordEmbeddings: Bool
    public var layerTypes: [String]
    public var fullAttentionRopeTheta: Float
    public var fullAttentionPartialRotaryFactor: Float
    public var slidingAttentionRopeTheta: Float

    enum CodingKeys: String, CodingKey {
        case modelType = "model_type"
        case vocabularySize = "vocab_size"
        case hiddenSize = "hidden_size"
        case hiddenLayers = "num_hidden_layers"
        case attentionHeads = "num_attention_heads"
        case kvHeads = "num_key_value_heads"
        case headDim = "head_dim"
        case intermediateSize = "intermediate_size"
        case maxPositionEmbeddings = "max_position_embeddings"
        case normEps = "norm_eps"
        case convBias = "conv_bias"
        case convLCache = "conv_L_cache"
        case slidingWindow = "sliding_window"
        case useSandwichNorm = "use_sandwich_norm"
        case tieWordEmbeddings = "tie_word_embeddings"
        case layerTypes = "layer_types"
        case ropeParameters = "rope_parameters"
        case textConfig = "text_config"
    }

    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let container: KeyedDecodingContainer<CodingKeys>
        if rootContainer.contains(.textConfig) {
            container = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .textConfig)
        } else {
            container = rootContainer
        }

        self.modelType = try container.decodeIfPresent(String.self, forKey: .modelType) ?? "lfm3"
        self.vocabularySize = try container.decodeIfPresent(Int.self, forKey: .vocabularySize)
            ?? (try rootContainer.decodeIfPresent(Int.self, forKey: .vocabularySize) ?? 128_000)
        self.hiddenSize = try container.decodeIfPresent(Int.self, forKey: .hiddenSize) ?? 2048
        self.hiddenLayers = try container.decodeIfPresent(Int.self, forKey: .hiddenLayers) ?? 24
        self.attentionHeads = try container.decodeIfPresent(Int.self, forKey: .attentionHeads) ?? 16
        self.kvHeads = try container.decodeIfPresent(Int.self, forKey: .kvHeads) ?? 4
        let defaultHeadDim = self.hiddenSize / max(self.attentionHeads, 1)
        self.headDim = try container.decodeIfPresent(Int.self, forKey: .headDim) ?? defaultHeadDim
        self.intermediateSize = try container.decodeIfPresent(Int.self, forKey: .intermediateSize) ?? 7680
        self.maxPositionEmbeddings = try container.decodeIfPresent(Int.self, forKey: .maxPositionEmbeddings) ?? 262_144
        self.normEps = try container.decodeIfPresent(Float.self, forKey: .normEps) ?? 1e-5
        self.convBias = try container.decodeIfPresent(Bool.self, forKey: .convBias) ?? false
        self.convLCache = try container.decodeIfPresent(Int.self, forKey: .convLCache) ?? 7
        self.slidingWindow = try container.decodeIfPresent(Int.self, forKey: .slidingWindow) ?? 256
        self.useSandwichNorm = try container.decodeIfPresent(Bool.self, forKey: .useSandwichNorm) ?? true
        self.tieWordEmbeddings = try container.decodeIfPresent(Bool.self, forKey: .tieWordEmbeddings) ?? true

        if let decodedLayerTypes = try container.decodeIfPresent([String].self, forKey: .layerTypes) {
            self.layerTypes = decodedLayerTypes
        } else {
            self.layerTypes = (0..<self.hiddenLayers).map { idx in
                if idx % 2 == 1 { return "conv" }
                return (idx % 4 == 2) ? "full_attention" : "sliding_attention"
            }
        }

        let ropeDict = try? container.decodeIfPresent([String: AILFM3RoPELayerConfig].self, forKey: .ropeParameters)
        self.fullAttentionRopeTheta = ropeDict?["full_attention"]?.ropeTheta ?? 1_000_000.0
        self.fullAttentionPartialRotaryFactor = ropeDict?["full_attention"]?.partialRotaryFactor ?? 0.5
        self.slidingAttentionRopeTheta = ropeDict?["sliding_attention"]?.ropeTheta ?? 10_000.0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(modelType, forKey: .modelType)
        try container.encode(vocabularySize, forKey: .vocabularySize)
        try container.encode(hiddenSize, forKey: .hiddenSize)
        try container.encode(hiddenLayers, forKey: .hiddenLayers)
        try container.encode(attentionHeads, forKey: .attentionHeads)
        try container.encode(kvHeads, forKey: .kvHeads)
        try container.encode(headDim, forKey: .headDim)
        try container.encode(intermediateSize, forKey: .intermediateSize)
        try container.encode(maxPositionEmbeddings, forKey: .maxPositionEmbeddings)
        try container.encode(normEps, forKey: .normEps)
        try container.encode(convBias, forKey: .convBias)
        try container.encode(convLCache, forKey: .convLCache)
        try container.encode(slidingWindow, forKey: .slidingWindow)
        try container.encode(useSandwichNorm, forKey: .useSandwichNorm)
        try container.encode(tieWordEmbeddings, forKey: .tieWordEmbeddings)
        try container.encode(layerTypes, forKey: .layerTypes)
    }

    public func isAttentionLayer(_ index: Int) -> Bool {
        guard index < layerTypes.count else { return false }
        return layerTypes[index] != "conv"
    }

    public func isSlidingAttentionLayer(_ index: Int) -> Bool {
        guard index < layerTypes.count else { return false }
        return layerTypes[index] == "sliding_attention"
    }
}

// MARK: - LFM3 Attention (GQA + QK RMSNorm + Per-Head Sigmoid Output Gate + Zero-Tail Partial RoPE)

final class AILFM3Attention: Module {
    let args: AILFM3Configuration
    let layerIdx: Int
    let scale: Float
    let headDim: Int
    let isSliding: Bool
    let ropeDimensions: Int
    let rope: RoPE

    @ModuleInfo(key: "q_proj") var qProj: Linear
    @ModuleInfo(key: "k_proj") var kProj: Linear
    @ModuleInfo(key: "v_proj") var vProj: Linear
    @ModuleInfo(key: "o_proj") var oProj: Linear
    @ModuleInfo(key: "gate_proj") var gateProj: Linear
    @ModuleInfo(key: "q_norm") var qNorm: RMSNorm
    @ModuleInfo(key: "k_norm") var kNorm: RMSNorm

    init(_ args: AILFM3Configuration, layerIdx: Int) {
        self.args = args
        self.layerIdx = layerIdx
        self.headDim = args.headDim
        self.scale = pow(Float(headDim), -0.5)
        self.isSliding = args.isSlidingAttentionLayer(layerIdx)

        let dim = args.hiddenSize
        let heads = args.attentionHeads
        let kvHeads = args.kvHeads

        _qProj.wrappedValue = Linear(dim, heads * headDim, bias: false)
        _kProj.wrappedValue = Linear(dim, kvHeads * headDim, bias: false)
        _vProj.wrappedValue = Linear(dim, kvHeads * headDim, bias: false)
        _oProj.wrappedValue = Linear(heads * headDim, dim, bias: false)
        _gateProj.wrappedValue = Linear(dim, heads, bias: false)

        _qNorm.wrappedValue = RMSNorm(dimensions: headDim, eps: args.normEps)
        _kNorm.wrappedValue = RMSNorm(dimensions: headDim, eps: args.normEps)

        let partialFactor = isSliding ? 1.0 : args.fullAttentionPartialRotaryFactor
        let rotatedDims = max(2, Int(Float(headDim) * partialFactor))
        self.ropeDimensions = rotatedDims
        let theta = isSliding ? args.slidingAttentionRopeTheta : args.fullAttentionRopeTheta

        self.rope = RoPE(
            dimensions: rotatedDims,
            traditional: false,
            base: theta
        )
    }

    func callAsFunction(
        _ x: MLXArray,
        mask: MLXFast.ScaledDotProductAttentionMaskMode,
        cache: KVCache?
    ) -> MLXArray {
        let (B, L) = (x.dim(0), x.dim(1))

        var queries = qProj(x)
        var keys = kProj(x)
        var values = vProj(x)

        queries = qNorm(queries.reshaped(B, L, args.attentionHeads, headDim)).transposed(0, 2, 1, 3)
        keys = kNorm(keys.reshaped(B, L, args.kvHeads, headDim)).transposed(0, 2, 1, 3)
        values = values.reshaped(B, L, args.kvHeads, headDim).transposed(0, 2, 1, 3)

        if let cache {
            queries = rope(queries, offset: cache.offset)
            keys = rope(keys, offset: cache.offset)
        } else {
            queries = rope(queries)
            keys = rope(keys)
        }

        if let cache {
            (keys, values) = cache.update(keys: keys, values: values)
        }

        let attnOut = MLXFast.scaledDotProductAttention(
            queries: queries,
            keys: keys,
            values: values,
            scale: scale,
            mask: mask
        )
        .transposed(0, 2, 1, 3)

        // Per-head sigmoid output gate: gate shape [B, L, H, 1]
        let gate = sigmoid(gateProj(x)).expandedDimensions(axis: -1)
        let gated = (attnOut * gate).reshaped(B, L, args.attentionHeads * headDim)
        return oProj(gated)
    }
}

// MARK: - LFM3 Gated Short Convolution (Width-7 Causal Depthwise Conv)

final class AILFM3ShortConv: Module {
    let args: AILFM3Configuration
    let layerIdx: Int
    let lCache: Int
    let bias: Bool

    @ModuleInfo(key: "conv") var conv: Conv1d
    @ModuleInfo(key: "in_proj") var inProj: Linear
    @ModuleInfo(key: "out_proj") var outProj: Linear

    init(_ args: AILFM3Configuration, layerIdx: Int) {
        self.args = args
        self.layerIdx = layerIdx
        self.lCache = args.convLCache
        self.bias = args.convBias

        _conv.wrappedValue = Conv1d(
            inputChannels: args.hiddenSize,
            outputChannels: args.hiddenSize,
            kernelSize: lCache,
            groups: args.hiddenSize,
            bias: bias
        )
        _inProj.wrappedValue = Linear(args.hiddenSize, 3 * args.hiddenSize, bias: bias)
        _outProj.wrappedValue = Linear(args.hiddenSize, args.hiddenSize, bias: bias)
    }

    func callAsFunction(_ x: MLXArray, cache: MambaCache?) -> MLXArray {
        let BCx = inProj(x)
        let parts = BCx.split(parts: 3, axis: -1)
        let B = parts[0]
        let C = parts[1]
        let xProj = parts[2]
        var Bx = B * xProj

        var state: MLXArray? = cache?[0]
        if state == nil {
            state = MLXArray.zeros([Bx.dim(0), lCache - 1, args.hiddenSize], dtype: Bx.dtype)
        }

        Bx = concatenated([state!, Bx], axis: -2)
        if let cache {
            cache[0] = Bx[0..., (Bx.dim(1) - (lCache - 1))..., 0...]
        }

        let convOut = conv(Bx)
        let y = C * convOut
        return outProj(y)
    }
}

// MARK: - LFM3 SwiGLU MLP

final class AILFM3MLP: Module, UnaryLayer {
    @ModuleInfo(key: "w1") var w1: Linear
    @ModuleInfo(key: "w2") var w2: Linear
    @ModuleInfo(key: "w3") var w3: Linear

    init(_ args: AILFM3Configuration) {
        _w1.wrappedValue = Linear(args.hiddenSize, args.intermediateSize, bias: false)
        _w2.wrappedValue = Linear(args.intermediateSize, args.hiddenSize, bias: false)
        _w3.wrappedValue = Linear(args.hiddenSize, args.intermediateSize, bias: false)
    }

    func callAsFunction(_ x: MLXArray) -> MLXArray {
        w2(silu(w1(x)) * w3(x))
    }
}

// MARK: - LFM3 Decoder Layer (with Sandwich RMSNorm)

final class AILFM3DecoderLayer: Module {
    let isAttentionLayer: Bool
    let useSandwichNorm: Bool

    @ModuleInfo(key: "self_attn") var selfAttn: AILFM3Attention?
    @ModuleInfo(key: "conv") var conv: AILFM3ShortConv?
    @ModuleInfo(key: "feed_forward") var feedForward: AILFM3MLP
    @ModuleInfo(key: "operator_norm") var operatorNorm: RMSNorm
    @ModuleInfo(key: "post_operator_norm") var postOperatorNorm: RMSNorm?
    @ModuleInfo(key: "ffn_norm") var ffnNorm: RMSNorm
    @ModuleInfo(key: "post_ffn_norm") var postFFNNorm: RMSNorm?

    init(_ args: AILFM3Configuration, layerIdx: Int) {
        self.isAttentionLayer = args.isAttentionLayer(layerIdx)
        self.useSandwichNorm = args.useSandwichNorm

        if isAttentionLayer {
            _selfAttn.wrappedValue = AILFM3Attention(args, layerIdx: layerIdx)
        } else {
            _conv.wrappedValue = AILFM3ShortConv(args, layerIdx: layerIdx)
        }

        _feedForward.wrappedValue = AILFM3MLP(args)
        _operatorNorm.wrappedValue = RMSNorm(dimensions: args.hiddenSize, eps: args.normEps)
        _ffnNorm.wrappedValue = RMSNorm(dimensions: args.hiddenSize, eps: args.normEps)
        if useSandwichNorm {
            _postOperatorNorm.wrappedValue = RMSNorm(dimensions: args.hiddenSize, eps: args.normEps)
            _postFFNNorm.wrappedValue = RMSNorm(dimensions: args.hiddenSize, eps: args.normEps)
        }
    }

    func callAsFunction(
        _ x: MLXArray,
        mask: MLXFast.ScaledDotProductAttentionMaskMode,
        cache: KVCache?
    ) -> MLXArray {
        var opOut: MLXArray
        if isAttentionLayer, let selfAttn {
            opOut = selfAttn(operatorNorm(x), mask: mask, cache: cache)
        } else if let conv {
            opOut = conv(operatorNorm(x), cache: cache as? MambaCache)
        } else {
            opOut = x
        }
        if let postOperatorNorm {
            opOut = postOperatorNorm(opOut)
        }
        let h = x + opOut

        var ffnOut = feedForward(ffnNorm(h))
        if let postFFNNorm {
            ffnOut = postFFNNorm(ffnOut)
        }
        return h + ffnOut
    }
}

// MARK: - LFM3 Inner & CausalLM Model

internal final class AILFM3ModelInner: Module {
    let args: AILFM3Configuration
    fileprivate let layers: [AILFM3DecoderLayer]

    @ModuleInfo(key: "embed_tokens") var embedTokens: Embedding
    @ModuleInfo(key: "embedding_norm") var embeddingNorm: RMSNorm

    public init(_ args: AILFM3Configuration) {
        self.args = args
        _embedTokens.wrappedValue = Embedding(
            embeddingCount: args.vocabularySize,
            dimensions: args.hiddenSize
        )
        self.layers = (0..<args.hiddenLayers).map { idx in
            AILFM3DecoderLayer(args, layerIdx: idx)
        }
        _embeddingNorm.wrappedValue = RMSNorm(dimensions: args.hiddenSize, eps: args.normEps)
    }

    public func callAsFunction(_ inputs: MLXArray, cache: [KVCache]? = nil) -> MLXArray {
        var h = embedTokens(inputs)

        let fullAttnIndex = args.layerTypes.firstIndex(of: "full_attention") ?? 2
        let slidingAttnIndex = args.layerTypes.firstIndex(of: "sliding_attention") ?? 4

        let fullMask = createAttentionMask(
            h: h,
            cache: cache != nil && fullAttnIndex < cache!.count ? [cache![fullAttnIndex]] : nil
        )
        let slidingMask = createAttentionMask(
            h: h,
            cache: cache != nil && slidingAttnIndex < cache!.count ? [cache![slidingAttnIndex]] : nil
        )

        for (i, layer) in layers.enumerated() {
            let mask = args.isSlidingAttentionLayer(i) ? slidingMask : fullMask
            h = layer(h, mask: mask, cache: cache?[i])
        }

        return embeddingNorm(h)
    }
}

internal final class AILFM3Model: Module, LLMModel, KVCacheDimensionProvider, LoRAModel {
    public let vocabularySize: Int
    public let kvHeads: [Int]
    public let model: AILFM3ModelInner
    let configuration: AILFM3Configuration

    @ModuleInfo(key: "lm_head") var lmHead: Linear?

    public init(_ args: AILFM3Configuration) {
        self.configuration = args
        self.vocabularySize = args.vocabularySize
        self.kvHeads = (0..<args.hiddenLayers).map { idx in
            args.isAttentionLayer(idx) ? args.kvHeads : 0
        }
        self.model = AILFM3ModelInner(args)
        if !args.tieWordEmbeddings {
            _lmHead.wrappedValue = Linear(args.hiddenSize, args.vocabularySize, bias: false)
        }
    }

    public func callAsFunction(_ inputs: MLXArray, cache: [KVCache]?) -> MLXArray {
        let out = model(inputs, cache: cache)
        if let lmHead {
            return lmHead(out)
        }
        return model.embedTokens.asLinear(out)
    }

    public func sanitize(weights: [String: MLXArray]) -> [String: MLXArray] {
        var sanitized: [String: MLXArray] = [:]

        for (rawName, param) in weights {
            // Skip multimodal encoder/decoder weights when loading LFM3-Omni-2B in LLM pipeline
            if rawName.hasPrefix("audio_tower.")
                || rawName.hasPrefix("audio_projector.")
                || rawName.hasPrefix("audio_detokenizer.")
                || rawName.hasPrefix("codebook_embed.")
                || rawName.hasPrefix("vision_tower.")
                || rawName.hasPrefix("multi_modal_projector.")
                || rawName.hasPrefix("vision_projector.")
            {
                continue
            }

            var name = rawName
            if name.hasPrefix("language_model.") {
                name = String(name.dropFirst("language_model.".count))
            }

            if configuration.tieWordEmbeddings && name.hasPrefix("lm_head.") {
                continue
            }

            var sanitizedParam = param
            if name.contains("conv.conv.weight") || name.contains("conv.weight") {
                if param.ndim == 3 && param.shape[param.shape.count - 1] > param.shape[1] {
                    sanitizedParam = param.transposed(0, 2, 1)
                }
            }

            sanitized[name] = sanitizedParam
        }

        return sanitized
    }

    public func newCache(parameters: GenerateParameters?) -> [KVCache] {
        (0..<configuration.hiddenLayers).map { idx in
            if configuration.isSlidingAttentionLayer(idx) {
                return RotatingKVCache(maxSize: configuration.slidingWindow, keep: 0)
            } else if configuration.isAttentionLayer(idx) {
                return KVCacheSimple()
            } else {
                return MambaCache()
            }
        }
    }

    public var loraLayers: [Module] {
        model.layers
    }
}
