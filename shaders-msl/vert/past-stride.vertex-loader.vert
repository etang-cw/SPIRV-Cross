#version 310 es

layout(location = 7) in uint aUInt;
layout(location = 8) in float aUNorm;

void main()
{
    gl_Position = vec4(float(aUInt) / 64.0, aUNorm, 0.0, 1.0);
}
