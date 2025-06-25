
function mergeConfigs(sourceConfig, newConfig) {
  for (var key in sourceConfig) {
    if (Array.isArray(sourceConfig[key])) {
      if (!newConfig.hasOwnProperty(key)) {
        newConfig[key] = sourceConfig[key].slice();
      }
    } else if (typeof sourceConfig[key] === "object" && sourceConfig[key] !== null) {
      if (!newConfig.hasOwnProperty(key)) {
        newConfig[key] = {};
      }
      mergeConfigs(sourceConfig[key], newConfig[key]);
    } else {
      if (!newConfig.hasOwnProperty(key)) {
        newConfig[key] = sourceConfig[key];
      }
    }
  }
  return newConfig;
}

function getRandomColor(h, s, l, a) {
  h = h ?? Math.random();
  s = s ?? Math.random();
  l = l ?? Math.random();
  a = a ?? 1.0;
  return Qt.hsla(h, s, l, a);
}

function scaleSaturation(color, saturation) {
  return Qt.hsla(color.hslHue, saturation, color.hslLightness, color.a);
}

function scaleLightness(color, lightness) {
  return Qt.hsla(color.hslHue, color.hslSaturation, lightness, color.a);
}

function alterColor(color, saturationEnabled, saturation, lightnessEnabled, lightness, alpha) {
  if (saturationEnabled) {
    color = Utils.scaleSaturation(color, saturation);
  }
  if (lightnessEnabled) {
    color = Utils.scaleLightness(color, lightness);
  }
  if (alpha !== 1.0) {
    color = Qt.hsla(color.hslHue, color.hslSaturation, color.hslLightness, alpha);
  }
  return color;
}


function hexToRgb(hex) {
  var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result
    ? {
      r: parseInt(result[1], 16),
      g: parseInt(result[2], 16),
      b: parseInt(result[3], 16),
    }
    : null;
}

function rgbToQtColor(rgb) {
  return Qt.rgba(rgb.r / 255, rgb.g / 255, rgb.b / 255, 1);
}

function hexToQtColor(hex) {
  let rgb = hexToRgb(hex);
  return rgbToQtColor(rgb);
}

function buildCanvasGradient(ctx, smooth, gradientStops, orientation, height, width) {
  let gradient;
  if (orientation === 0) {
    gradient = ctx.createLinearGradient(0, 0, width, 0);
  } else {
    gradient = ctx.createLinearGradient(0, 0, 0, height);
  }
  for (let i = 0; i < gradientStops.length; i++) {
    const stop = gradientStops[i];
    let color = stop.color ?? stop;
    let position = stop.position ?? (1 / gradientStops.length) * i;
    gradient.addColorStop(position, color);
    if (!smooth && i > 0 && i < gradientStops.length) {
      let prevStop = gradientStops[i - 1];
      let color = prevStop.color ?? prevStop;
      gradient.addColorStop(Math.max(position - 0.0001, 0), color);
    }
  }
  return gradient;
}
