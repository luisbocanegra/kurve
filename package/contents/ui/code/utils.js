
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
    color = scaleSaturation(color, saturation);
  }
  if (lightnessEnabled) {
    color = scaleLightness(color, lightness);
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
    gradient = ctx.createLinearGradient(0, height, 0, 0);
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

function getColors(barColorsCfg, barCount, themeColor) {
  let colorSourceType = barColorsCfg.sourceType;
  let colors = [];
  let color = null;
  if (colorSourceType === 0) {
    color = hexToQtColor(barColorsCfg.custom);
  } else if (colorSourceType === 1) {
    color = themeColor;
  }
  if (color) {
    color = alterColor(color, barColorsCfg.saturationEnabled, barColorsCfg.saturation, barColorsCfg.lightnessEnabled, barColorsCfg.lightness, barColorsCfg.alpha);
    colors.push(color);
  }
  if (colorSourceType === 2) {
    colors = barColorsCfg.list.map(c => {
      c = hexToQtColor(c);
      return alterColor(c, barColorsCfg.saturationEnabled, barColorsCfg.saturation, barColorsCfg.lightnessEnabled, barColorsCfg.lightness, barColorsCfg.alpha);
    });
  } else if (colorSourceType === 3) {
    for (let i = 0; i < barCount; i++) {
      colors.push(alterColor(getRandomColor(null, 0.8, 0.7, null), barColorsCfg.saturationEnabled, barColorsCfg.saturation, barColorsCfg.lightnessEnabled, barColorsCfg.lightness, barColorsCfg.alpha));
    }
  } else if (colorSourceType === 7) {
    for (let i = 0; i < barCount; i++) {
      let c = Qt.hsla(i / barCount, 0.8, 0.7, 1.0);
      colors.push(alterColor(c, barColorsCfg.saturationEnabled, barColorsCfg.saturation, barColorsCfg.lightnessEnabled, barColorsCfg.lightness, barColorsCfg.alpha));
    }
  }
  return colors;
}

// https://stackoverflow.com/questions/28507619/how-to-create-delay-function-in-qml
function delay(interval, callback, parentItem) {
  let timer = Qt.createQmlObject("import QtQuick; Timer {}", parentItem);
  timer.interval = interval;
  timer.repeat = false;
  timer.triggered.connect(callback);
  timer.triggered.connect(function release() {
    timer.triggered.disconnect(callback);
    timer.triggered.disconnect(release);
    timer.destroy();
  });
  timer.start();
}

function makeEven(n) {
  return n - (n % 2);
}
