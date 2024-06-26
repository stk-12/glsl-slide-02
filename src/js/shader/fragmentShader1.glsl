varying vec2 vUv;
uniform float uTime;
uniform sampler2D uTexCurrent;
uniform sampler2D uTexNext;
uniform vec2 uResolution;
uniform vec2 uTexResolution;
uniform float uProgress;

uniform vec2 uDirection; // = vec2(-1.0, 1.0)

const float smoothness = 0.5;
const vec2 center = vec2(0.5, 0.5);


vec4 getFromColor(vec2 uv) {
  return texture2D(uTexCurrent, uv);
}

vec4 getToColor(vec2 uv) {
  return texture2D(uTexNext, uv);
}

vec4 transition(vec2 uv) {
  vec2 v = normalize(uDirection);
  v /= abs(v.x) + abs(v.y);
  float d = v.x * center.x + v.y * center.y;
  float m = 1.0 - smoothstep(-smoothness, 0.0, v.x * uv.x + v.y * uv.y - (d - 0.5 + uProgress * (1.0 + smoothness)));
  return mix(getFromColor((uv - 0.5) * (1.0 - m) + 0.5), getToColor((uv - 0.5) * m + 0.5), m);
}

void main() {
  vec2 uv = vUv;

  vec2 ratio = vec2(
    min((uResolution.x / uResolution.y) / (uTexResolution.x / uTexResolution.y), 1.0),
    min((uResolution.y / uResolution.x) / (uTexResolution.y / uTexResolution.x), 1.0)
  );

  uv = vec2(
    vUv.x * ratio.x + (1.0 - ratio.x) * 0.5,
    vUv.y * ratio.y + (1.0 - ratio.y) * 0.5
  );

  vec4 color = transition(uv);
  gl_FragColor = color;
}