#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

static half3 spvLoadVertexRG11B10Half(uint value)
{
    ushort3 res = ushort3(value << 5, (value >> 6) & 0xffc0, (value >> 16) & 0xff80);
    return as_type<half3>(res);
}
static float3 spvLoadVertexRGB9E5Float(uint value)
{
    float exponent = exp2(float(value >> 27)) * exp2(float(-(15 + 9)));
    int3 mantissa = int3(value & 0x1ff, extract_bits(value, 9, 9), extract_bits(value, 18, 9));
    return float3(mantissa) * exp2(float(exponent));
}
struct UBO
{
    float4x4 uMVP;
};

struct main0_out
{
    float3 vNormal [[user(locn0)]];
    float3 vExtra [[user(locn1)]];
    float4 gl_Position [[position]];
};

struct main0_in
{
    float4 aVertex [[attribute(4)]];
    float3 aNormal [[attribute(5)]];
    float3 aExtra [[attribute(6)]];
};

struct spvVertexData2
{
    uint aVertex;
    uint aNormal;
    uint aExtra;
    uint spvPad12;
};
static_assert(alignof(spvVertexData2) == 4, "Unexpected alignment");
static_assert(sizeof(spvVertexData2) == 16, "Unexpected size");

main0_in spvLoadVertex(const device spvVertexData2& data2)
{
    main0_in out;
    out.aVertex = unpack_unorm10a2_to_float(data2.aVertex);
    out.aNormal = spvLoadVertexRGB9E5Float(data2.aNormal);
    out.aExtra = float3(spvLoadVertexRG11B10Half(data2.aExtra));
    return out;
}

vertex main0_out main0(device const spvVertexData2* spvVertexBuffer2 [[buffer(2)]], constant UBO& _16 [[buffer(0)]], uint gl_VertexIndex [[vertex_id]], uint gl_BaseVertex [[base_vertex]], uint gl_InstanceIndex [[instance_id]], uint gl_BaseInstance [[base_instance]])
{
    main0_out out = {};
    main0_in in = spvLoadVertex(spvVertexBuffer2[gl_BaseInstance]);
    out.gl_Position = _16.uMVP * in.aVertex;
    out.vNormal = in.aNormal;
    out.vExtra = in.aExtra;
    return out;
}

