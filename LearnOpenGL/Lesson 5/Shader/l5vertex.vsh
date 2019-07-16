// l5vertex.vsh
attribute vec4 a_position;
attribute vec4 a_color;
attribute vec2 a_texCoord;

varying lowp vec4 frag_color;
varying lowp vec2 frag_texCoord;

uniform highp mat4 model_matrix;

void main(void) {
  frag_color = a_color;
  frag_texCoord = a_texCoord;
  gl_Position = model_matrix * a_position;
}
