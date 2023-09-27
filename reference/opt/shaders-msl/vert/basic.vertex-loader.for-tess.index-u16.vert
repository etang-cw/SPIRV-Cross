#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct main0_out
{
    float3 vNormal;
    float4 gl_Position;
};

struct main0_in
{
    float4 aVertex [[attribute(0)]];
    float3 aNormal [[attribute(1)]];
};

struct spvVertexData0
{
    packed_half4 aVertex;
    packed_short4 aNormal;
};
static_assert(alignof(spvVertexData0) == 2, "Unexpected alignment");
static_assert(sizeof(spvVertexData0) == 16, "Unexpected size");

main0_in spvLoadVertex(const device spvVertexData0& data0)
{
    main0_in out;
    out.aVertex = float4(half4(data0.aVertex));
    out.aNormal = max(float4(short4(data0.aNormal)) * (1.f / 32767), -1.f).rgb;
    return out;
}

kernel void main0(device const spvVertexData0* spvVertexBuffer0 [[buffer(0)]], uint3 gl_GlobalInvocationID [[thread_position_in_grid]], uint3 spvStageInputSize [[grid_size]], uint3 spvDispatchBase [[grid_origin]], device main0_out* spvOut [[buffer(28)]], const device ushort* spvIndices [[buffer(21)]])
{
    device main0_out& out = spvOut[gl_GlobalInvocationID.y * spvStageInputSize.x + gl_GlobalInvocationID.x];
    if (any(gl_GlobalInvocationID >= spvStageInputSize))
        return;
    uint gl_VertexIndex = spvIndices[gl_GlobalInvocationID.x] + spvDispatchBase.x;
    uint gl_BaseVertex = spvDispatchBase.x;
    uint gl_InstanceIndex = gl_GlobalInvocationID.y + spvDispatchBase.y;
    uint gl_BaseInstance = spvDispatchBase.y;
    main0_in in = spvLoadVertex(spvVertexBuffer0[gl_VertexIndex]);
    out.gl_Position = in.aVertex;
    out.vNormal = in.aNormal;
}

