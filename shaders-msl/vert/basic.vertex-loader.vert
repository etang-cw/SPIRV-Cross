#version 310 es

layout(location = 0) in vec4 aVertex;
layout(location = 1) in vec3 aNormal;

layout(location = 0) out vec3 vNormal;

void main()
{
    gl_Position = aVertex;
    vNormal = aNormal;
}
