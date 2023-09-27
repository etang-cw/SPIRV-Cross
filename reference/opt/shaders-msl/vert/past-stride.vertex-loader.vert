#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct main0_out
{
    float4 gl_Position [[position]];
};

struct main0_in
{
    uint aUInt [[attribute(7)]];
    float aUNorm [[attribute(8)]];
};

struct alignas(4) spvVertexData3
{
    uchar data[16];
};
static_assert(alignof(spvVertexData3) == 4, "Unexpected alignment");
static_assert(sizeof(spvVertexData3) == 16, "Unexpected size");

main0_in spvLoadVertex(const device spvVertexData3& data3)
{
    main0_in out;
    out.aUInt = reinterpret_cast<const device uint&>(data3.data[32]);
    out.aUNorm = float(data3.data[1]) * (1.f / 255);
    return out;
}

vertex main0_out main0(device const spvVertexData3* spvVertexBuffer3 [[buffer(3)]], uint gl_VertexIndex [[vertex_id]], uint gl_BaseVertex [[base_vertex]], uint gl_InstanceIndex [[instance_id]], uint gl_BaseInstance [[base_instance]])
{
    main0_out out = {};
    main0_in in = spvLoadVertex(spvVertexBuffer3[gl_BaseInstance + (gl_InstanceIndex - gl_BaseInstance) / 4]);
    out.gl_Position = float4(float(in.aUInt) * 0.015625, in.aUNorm, 0.0, 1.0);
    return out;
}

