
function bars(ctx, canvas, circleMode = false) {
  if (circleMode) {
    barsCircle(ctx, canvas);
  } else {
    barsRect(ctx, canvas);
  }
}

function wave(ctx, canvas, circleMode = false) {
  if (circleMode) {
    waveCircle(ctx, canvas);
  } else {
    waveRect(ctx, canvas);
  }
}

/**
 * Bars
 * @param {Context2D} ctx QML Type (canvas.getContext('2d'))
 * @param {Canvas} canvas QML Type
 */
function barsRect(ctx, canvas) {
  const canvasHeight = canvas.height;
  const maxValue = canvasHeight;
  const barCount = canvas.barCount;
  const roundedBars = canvas.roundedBars;
  const barWidth = canvas.barWidth;
  const centeredBars = canvas.centeredBars;
  const values = canvas.values;
  const radiusOffset = canvas.radiusOffset;
  const spacing = canvas.spacing;
  ctx.lineCap = roundedBars ? "round" : "butt";
  ctx.lineWidth = barWidth;

  let x = barWidth / 2;

  const centerY = canvasHeight / 2;
  for (let i = 0; i < barCount; i++) {
    const value = Math.max(1, Math.min(maxValue, values[i]));

    let barHeight;
    let yBottom;
    let yTop;
    if (centeredBars) {
      if (roundedBars) {
        barHeight = (value / maxValue) * ((canvasHeight - barWidth) / 2);
      } else {
        barHeight = (value / maxValue) * (canvasHeight / 2);
      }
      yBottom = centerY - barHeight;
      yTop = yBottom + (barHeight * 2);
    } else {
      if (roundedBars) {
        barHeight = (value / maxValue) * (canvasHeight - barWidth);
        yBottom = canvasHeight - radiusOffset;
      } else {
        barHeight = (value / maxValue) * canvasHeight;
        yBottom = canvasHeight;
      }
      yTop = yBottom - barHeight;
    }

    ctx.beginPath();
    ctx.moveTo(x, yBottom);
    ctx.lineTo(x, yTop);
    ctx.stroke();
    x += barWidth + spacing;
  }
}

/**
 * Wave
 * @param {Context2D} ctx QML Type (canvas.getContext('2d'))
 * @param {Canvas} canvas QML Type
 */
function waveRect(ctx, canvas) {
  const canvasWidth = canvas.width;
  const canvasHeight = canvas.height;
  const maxValue = canvasHeight;
  const barCount = canvas.barCount;
  const roundedBars = canvas.roundedBars;
  const barWidth = canvas.barWidth;
  const centeredBars = canvas.centeredBars;
  const fillWave = canvas.fillWave;
  const waveFillGradient = canvas.waveFillGradient;
  const values = canvas.values;

  if (barCount < 2)
    return;

  ctx.lineCap = roundedBars ? "round" : "butt";
  ctx.lineWidth = barWidth;

  const step = canvasWidth / (barCount - 1);
  const yBottom = centeredBars ? (canvasHeight / 2) : (canvasHeight - barWidth / 2);

  canvas.gradientHeight = yBottom;

  ctx.beginPath();
  let prevX = 0;
  let prevY = yBottom - Math.max(0, Math.min(maxValue, values[0])) / maxValue * yBottom;
  ctx.lineTo(prevX - 0.5, prevY);

  for (let i = 1; i < barCount; i++) {
    const norm = Math.max(0, Math.min(maxValue, values[i])) / maxValue;
    const x = i * step;
    const y = yBottom - norm * yBottom;
    const midX = (prevX + x) / 2;
    const midY = (prevY + y) / 2;
    ctx.quadraticCurveTo(prevX, prevY, midX, midY);
    prevX = x;
    prevY = y;
  }

  ctx.lineTo(canvasWidth + 0.5, prevY);
  ctx.stroke();

  if (fillWave && waveFillGradient) {
    const yBottom = centeredBars ? (canvasHeight / 2 + barWidth / 2) : canvasHeight;
    ctx.beginPath();
    ctx.moveTo(0, yBottom);

    prevX = 0;
    prevY = yBottom - Math.max(0, Math.min(maxValue, values[0])) / maxValue * yBottom;
    ctx.lineTo(prevX, prevY);

    for (let i = 1; i < barCount; i++) {
      const norm = Math.max(0, Math.min(maxValue, values[i])) / maxValue;
      const x = i * step;
      const y = yBottom - norm * yBottom;
      const midX = (prevX + x) / 2;
      const midY = (prevY + y) / 2;
      ctx.quadraticCurveTo(prevX, prevY, midX, midY);
      prevX = x;
      prevY = y;
    }

    ctx.lineTo(canvasWidth, prevY);
    ctx.lineTo(canvasWidth, yBottom);
    ctx.closePath();
    ctx.fillStyle = waveFillGradient;
    ctx.fill();
  }
}

/**
 * Bars in circle mode
 * @param {Context2D} ctx QML Type (canvas.getContext('2d'))
 * @param {Canvas} canvas QML Type
 */
function barsCircle(ctx, canvas) {
  const canvasWidth = canvas.width;
  const canvasHeight = canvas.height;
  const maxValue = Math.min(canvasWidth, canvasHeight) / 2;
  const barCount = canvas.barCount;
  const roundedBars = canvas.roundedBars;
  const barWidth = canvas.barWidth;
  const values = canvas.values;
  const barRadiusOffset = canvas.radiusOffset * 2;
  const circleSize = canvas.circleModeSize;
  ctx.lineCap = roundedBars ? "round" : "butt";
  ctx.lineWidth = barWidth;

  const centerX = canvasWidth / 2;
  const centerY = canvasHeight / 2;
  const angleStep = (2 * Math.PI) / barCount;
  const innerRadius = (Math.min(canvasWidth, canvasHeight) / 2) * circleSize - barRadiusOffset;

  for (let i = 0; i < barCount; i++) {
    const value = Math.max(1, Math.min(maxValue, values[i]));
    const norm = value / maxValue;
    const barLength = norm * (maxValue - barWidth / 2) * (1 - circleSize);
    const angle = i * angleStep - Math.PI / 2;

    const xStart = centerX + Math.cos(angle) * innerRadius;
    const yStart = centerY + Math.sin(angle) * innerRadius;
    const xEnd = centerX + Math.cos(angle) * (innerRadius + barLength);
    const yEnd = centerY + Math.sin(angle) * (innerRadius + barLength);

    ctx.beginPath();
    ctx.moveTo(xStart, yStart);
    ctx.lineTo(xEnd, yEnd);
    ctx.stroke();
  }
}

/**
 * Wave in circle mode
 * @param {Context2D} ctx QML Type (canvas.getContext('2d'))
 * @param {Canvas} canvas QML Type
 */
function waveCircle(ctx, canvas) {
  const canvasWidth = canvas.width;
  const canvasHeight = canvas.height;
  const maxValue = Math.min(canvasWidth, canvasHeight) / 2;
  const barCount = canvas.barCount;
  const circleSize = canvas.circleModeSize;
  const innerRadius = (Math.min(canvasWidth, canvasHeight) / 2) * circleSize;
  const barWidth = canvas.barWidth;
  const fillWave = canvas.fillWave;
  const waveFillGradient = canvas.waveFillGradient;
  const values = canvas.values;

  if (barCount < 2) {
    return;
  }

  ctx.lineWidth = barWidth;

  const centerX = canvasWidth / 2;
  const centerY = canvasHeight / 2;
  const angleStep = (2 * Math.PI) / barCount;

  canvas.gradientHeight = maxValue - innerRadius;

  const outerPoints = new Array(barCount + 1);
  for (let i = 0; i <= barCount; i++) {
    const idx = i % barCount;
    const val = Math.max(0, Math.min(maxValue, values[idx]));
    const radial = val * (1 - circleSize);
    const angle = idx * angleStep - Math.PI / 2;
    outerPoints[i] = {
      x: centerX + Math.cos(angle) * (innerRadius + radial),
      y: centerY + Math.sin(angle) * (innerRadius + radial)
    };
  }

  // wave line
  ctx.beginPath();
  ctx.moveTo(outerPoints[0].x, outerPoints[0].y);
  let prev = outerPoints[0];
  for (let i = 1; i < outerPoints.length; i++) {
    const cur = outerPoints[i];
    const midX = (prev.x + cur.x) / 2;
    const midY = (prev.y + cur.y) / 2;
    ctx.quadraticCurveTo(prev.x, prev.y, midX, midY);
    prev = cur;
  }
  // back to start
  ctx.quadraticCurveTo(prev.x, prev.y, (prev.x + outerPoints[0].x) / 2, (prev.y + outerPoints[0].y) / 2);
  ctx.stroke();

  if (fillWave && waveFillGradient) {
    ctx.beginPath();
    ctx.moveTo(outerPoints[0].x, outerPoints[0].y);
    prev = outerPoints[0];
    for (let i = 1; i < outerPoints.length; i++) {
      const cur = outerPoints[i];
      const midX = (prev.x + cur.x) / 2;
      const midY = (prev.y + cur.y) / 2;
      ctx.quadraticCurveTo(prev.x, prev.y, midX, midY);
      prev = cur;
    }
    ctx.quadraticCurveTo(prev.x, prev.y, (prev.x + outerPoints[0].x) / 2, (prev.y + outerPoints[0].y) / 2);

    const startAngle = -Math.PI / 2;
    const innerStartX = centerX + Math.cos(startAngle) * innerRadius;
    const innerStartY = centerY + Math.sin(startAngle) * innerRadius;
    ctx.lineTo(innerStartX, innerStartY);
    ctx.arc(centerX, centerY, innerRadius, startAngle, startAngle + 2 * Math.PI, false);

    ctx.closePath();
    ctx.fillStyle = waveFillGradient;
    ctx.fill();
  }
}
