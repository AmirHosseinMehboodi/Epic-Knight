shader_type canvas_item;

uniform vec2 player_uv = vec2(0.5, 0.5);
// Radius of the light around the player (0..1)
uniform float light_radius : hint_range(0.0, 1.0) = 0.2;
// Edge softness of the light
uniform float edge_softness : hint_range(0.0, 0.5) = 0.2;
// Darkness color
uniform vec4 darkness_color = vec4(0.0, 0.0, 0.0, 0.85);
// Optional flicker intensity
uniform float flicker_intensity : hint_range(0.0, 0.05) = 0.004;

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Flicker effect (small radius variation)
    float flicker = sin(TIME * 10.0) * flicker_intensity;
    
    // Distance from player
    float d = distance(uv, player_uv);
    
    // Light alpha: 0 = fully visible (light), 1 = fully dark
    // FIXED: Swapped the parameters so close to player = 0 (light), far = 1 (dark)
    float alpha = smoothstep(light_radius - edge_softness + flicker, light_radius + flicker, d);
    
    // Output color: dark everywhere except near the player
    COLOR = vec4(darkness_color.rgb, darkness_color.a * alpha);
}