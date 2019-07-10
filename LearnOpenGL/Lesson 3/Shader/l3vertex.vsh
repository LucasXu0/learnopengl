// l3vertex.vsh
attribute vec4 a_position;
attribute vec4 a_color;

varying lowp vec4 frag_color;

void main(void) {
  frag_color = a_color;
  gl_Position = a_position;
}
