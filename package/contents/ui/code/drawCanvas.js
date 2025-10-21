/**
 * Bars
 * @param {Context2D} ctx QML Type (canvas.getContext('2d'))
 * @param {Canvas} canvas QML Type
 */
function bars(ctx, canvas) {
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
function wave(ctx, canvas) {
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
