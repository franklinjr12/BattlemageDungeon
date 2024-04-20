shader_type canvas_item;
uniform sampler2D tex;
void vertex() {
	COLOR = COLOR + COLOR * texture(tex, UV);
}