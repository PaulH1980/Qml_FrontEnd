#ifndef _OCTAHEDRON_GLSL_
#define _OCTAHEDRON_GLSL_

// For each component of v, returns -1 if the component is < 0, else 1
vec2 sign_not_zero(vec2 v) {
    #if 1
        // Branch-Less version
        return fma(step(vec2(0.0), v), vec2(2.0), vec2(-1.0));
    #else
        // Version with branches (for GLSL < 4.00)
        return vec2(
            v.x >= 0 ? 1.0 : -1.0,
            v.y >= 0 ? 1.0 : -1.0
        );
    #endif
}

vec3 unpack_normal_octahedron(vec2 packed_nrm) {
    #if 1
        
		vec2 norm = packed_nrm * 2.0 - 1.0;
		// Version using newer GLSL capatibilities
        vec3 v = vec3(norm.xy, 1.0 - abs(norm.x) - abs(norm.y));
        #if 1
            // Version with branches, seems to take less cycles than the
            // branch-less version
            if (v.z < 0) v.xy = (1.0 - abs(v.yx)) * sign_not_zero(v.xy);
        #else
            // Branch-Less version
            v.xy = mix(v.xy, (1.0 - abs(v.yx)) * sign_not_zero(v.xy), step(v.z, 0));
        #endif

        return normalize(v);
    #else
        // Version as proposed in the paper. 
        vec3 v = vec3(packed_nrm, 1.0 - dot(vec2(1), abs(packed_nrm)));
        if (v.z < 0)
            v.xy = (vec2(1) - abs(v.yx)) * sign_not_zero(v.xy);
        return normalize(v);
    #endif
}

#endif 
