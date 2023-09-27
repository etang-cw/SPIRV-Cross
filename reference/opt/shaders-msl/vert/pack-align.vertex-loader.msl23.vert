#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct UBO
{
    float4x4 uMVP;
};

struct main0_out
{
    float3 vNormal [[user(locn0)]];
    float4 gl_Position [[position]];
};

struct main0_in
{
    float4 aVertex [[attribute(2)]];
    float3 aNormal [[attribute(3)]];
};

struct alignas(4) spvVertexData1
{
    rgba8unorm<float4> aVertex;
    uchar spvPad4;
    packed_uchar3 aNormal;
};
static_assert(alignof(spvVertexData1) == 4, "Unexpected alignment");
static_assert(sizeof(spvVertexData1) == 8, "Unexpected size");

main0_in spvLoadVertex(const device spvVertexData1& data1)
{
    main0_in out;
    out.aVertex = unpack_unorm4x8_to_float(reinterpret_cast<const device uint&>(data1.aVertex));
    out.aNormal = float3(data1.aNormal).bgr;
    return out;
}

vertex main0_out main0(device const spvVertexData1* spvVertexBuffer1 [[buffer(1)]], constant UBO& _16 [[buffer(0)]], uint gl_VertexIndex [[vertex_id]], uint gl_BaseVertex [[base_vertex]], uint gl_InstanceIndex [[instance_id]], uint gl_BaseInstance [[base_instance]])
{
    main0_out out = {};
    main0_in in = spvLoadVertex(spvVertexBuffer1[gl_InstanceIndex]);
    out.gl_Position = _16.uMVP * in.aVertex;
    out.vNormal = in.aNormal;
    return out;
}

