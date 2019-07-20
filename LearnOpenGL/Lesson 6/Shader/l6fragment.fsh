// l4fragment.fsh
varying lowp vec4 frag_color;
varying lowp vec2 frag_texCoord;

uniform sampler2D u_texture;

void main(void) {
  gl_FragColor = texture2D(u_texture, frag_texCoord);
//    gl_FragColor = texture2D(u_texture, frag_texCoord);
//    gl_FragColor = frag_color;
}
