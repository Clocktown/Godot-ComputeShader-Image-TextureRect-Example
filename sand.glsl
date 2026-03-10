#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(r8, set = 0, binding = 0) restrict uniform image2D terrain;

// Push Constant will be padded to be multiple of 16 bytes
layout(push_constant, std430) uniform Params {
    int offset;
} params;

void main() {
    ivec2 id = ivec2(gl_GlobalInvocationID.xy);
    ivec2 size = imageSize(terrain);
    if(any(greaterThanEqual(id, size))) {
        return;
    }

    if(params.offset == 0) {
        imageStore(terrain, id, vec4(float(id.x) / float(size.x), 0, 0, 0));
    } else {
        imageStore(terrain, id, vec4(float(id.y) / float(size.y), 0, 0, 0));
    }
}