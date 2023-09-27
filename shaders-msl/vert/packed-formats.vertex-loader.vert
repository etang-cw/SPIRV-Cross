#version 310 es

layout(std140) uniform UBO
{
    uniform mat4 uMVP;
};

layout(location = 4) in vec4 aVertex;
layout(location = 5) in vec3 aNormal;
layout(location = 6) in vec3 aExtra;

layout(location = 0) out vec3 vNormal;
layout(location = 1) out vec3 vExtra;

void main()
{
    gl_Position = uMVP * aVertex;
    vNormal = aNormal;
    vExtra = aExtra;
}
