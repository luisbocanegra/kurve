
function bars(ctx, canvas, circleMode = false) {
  if (circleMode) {
    barsCircle(ctx, canvas);
  } else {
    barsRect(ctx, canvas);
  }
}

function wave(ctx, canvas, circleMode = false) {
  if (circleMode) {
    if (canvas.waveMode === Enum.WaveMode.Curve) {
      waveCircle(ctx, canvas);
    } else {
      triangleSquareCircle(ctx, canvas);
    }
  } else {
    waveRect(ctx, canvas);
  }
}

function blocks(ctx, canvas, circleMode = false) {
  if (circleMode) {
    blocksCircle(ctx, canvas);
  } else {
    blocksRect(ctx, canvas);
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
    const norm = value / maxValue;

    let barHeight;
    let yBottom;
    let yTop;
    if (centeredBars) {
      if (roundedBars) {
        barHeight = norm * ((canvasHeight - barWidth) / 2);
      } else {
        barHeight = norm * (centerY);
      }
      yBottom = centerY - barHeight;
      yTop = yBottom + (barHeight * 2);
    } else {
      if (roundedBars) {
        barHeight = norm * (canvasHeight - barWidth);
        yBottom = canvasHeight - radiusOffset;
      } else {
        barHeight = norm * canvasHeight;
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
  const barWidth = canvas.barWidth;
  const centeredBars = canvas.centeredBars && !canvas.waveform;
  const fillWave = canvas.fillWave;
  const values = canvas.values;
  const waveMode = canvas.waveMode;
  const waveSimulateWaveform = canvas.waveSimulateWaveform && !canvas.waveform;
  const invMax = 1 / maxValue;

  if (barCount < 2) {
    return;
  }

  ctx.lineWidth = barWidth;

  let step = canvasWidth / (barCount - 1);
  if (waveMode === Enum.WaveMode.Square) {
    step -= barWidth / barCount;
  }

  const yBottom = centeredBars && !waveform ? canvasHeight / 2 : canvasHeight - barWidth / 2;
  const fillYBottom = centeredBars
    ? (waveSimulateWaveform && !waveform ? canvasHeight / 2 : yBottom)
    : canvasHeight;

  canvas.gradientHeight = yBottom;

  let prevX = 0;
  let prevY = yBottom - values[0] * invMax * yBottom;

  ctx.beginPath();
  ctx.moveTo(prevX, prevY);

  for (let i = 1; i < barCount; i++) {
    let norm = values[i] * invMax;
    if (centeredBars && waveSimulateWaveform && !waveform) {
      norm *= (i % 2 === 0 || i === barCount - 1) ? -1 : 1;
    }

    const x = i * step;
    const y = yBottom - norm * yBottom;
    const midX = (prevX + x) / 2;
    const midY = (prevY + y) / 2;

    switch (waveMode) {
      case Enum.WaveMode.Curve:
        ctx.quadraticCurveTo(prevX, prevY, midX, midY);
        break;
      case Enum.WaveMode.Square:
        ctx.lineTo(x, prevY);
        ctx.lineTo(x, y);
        break;
      case Enum.WaveMode.Triangle:
        ctx.lineTo(x, y);
        break;
    }

    prevX = x;
    prevY = y;
  }

  if (waveMode === Enum.WaveMode.Curve) {
    ctx.quadraticCurveTo(prevX, prevY, prevX + x, prevY + y);
  }


  ctx.stroke();

  if (fillWave) {
    ctx.lineTo(prevX, fillYBottom);
    ctx.lineTo(0, fillYBottom);
    ctx.closePath();
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
  const values = canvas.values;
  const barRadiusOffset = canvas.radiusOffset * 2;
  const circleSize = canvas.circleModeSize;
  const spacing = canvas.spacing;

  const centerX = canvasWidth / 2;
  const centerY = canvasHeight / 2;
  const angleStep = (2 * Math.PI) / barCount;
  const innerRadius = (Math.min(canvasWidth, canvasHeight) / 2) * circleSize - barRadiusOffset;

  const gapAngle = spacing / innerRadius;

  for (let i = 0; i < barCount; i++) {
    const value = Math.max(1, Math.min(maxValue, values[i]));
    const norm = value / maxValue;
    const barLength = norm * (maxValue - 2) * (1 - circleSize);

    const halfAngle = (angleStep - gapAngle) / 2;
    const angle = (i + 0.5) * angleStep - Math.PI / 2;

    const angle1 = angle - halfAngle;
    const angle2 = angle + halfAngle;

    const outerRadius = innerRadius + barLength;

    // FIXME: maybe guard against this earlier
    if (innerRadius < 0 || outerRadius < 0) {
      return;
    }

    ctx.beginPath();
    ctx.arc(centerX, centerY, innerRadius, angle1, angle2, false);
    ctx.arc(centerX, centerY, outerRadius, angle2, angle1, true);
    ctx.closePath();
    ctx.fill();
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
  const values = canvas.values;
  const circleModeFill = canvas.circleModeFill;

  if (barCount < 2) {
    return;
  }

  ctx.lineWidth = barWidth;

  const centerX = canvasWidth / 2;
  const centerY = canvasHeight / 2;
  const angleStep = (2 * Math.PI) / barCount;

  canvas.gradientHeight = maxValue - innerRadius;

  ctx.beginPath();

  // averaged with last to allow a more seamless connection at end
  let val0 = Math.max(0, Math.min(maxValue, ((values[0] + values[barCount - 1]) / 2)));
  let radial0 = val0 * (1 - circleSize);
  let angle0 = - Math.PI / 2;
  let startX = centerX + Math.cos(angle0) * (innerRadius + radial0);
  let startY = centerY + Math.sin(angle0) * (innerRadius + radial0);

  ctx.moveTo(startX, startY);

  let prevX = startX;
  let prevY = startY;

  for (let i = 0; i < barCount; i++) {
    let val = 0;

    if (i === 0 || i === barCount - 1) {
      val = val0;
    } else {
      val = Math.max(0, Math.min(maxValue, values[i]));
    }

    const radial = val * (1 - circleSize);
    const angle = (i + 0.5) * angleStep - Math.PI / 2;
    const curX = centerX + Math.cos(angle) * (innerRadius + radial);
    const curY = centerY + Math.sin(angle) * (innerRadius + radial);

    const midX = (prevX + curX) / 2;
    const midY = (prevY + curY) / 2;
    ctx.quadraticCurveTo(prevX, prevY, midX, midY);

    prevX = curX;
    prevY = curY;
  }

  // back to the beginning
  let midX = (prevX + startX) / 2;
  let midY = (prevY + startY) / 2;
  ctx.quadraticCurveTo(midX, midY, startX, startY);

  if (fillWave) {
    ctx.fill();
  }
  ctx.stroke();
  ctx.closePath();

  // inner circle
  if (!circleModeFill) {
    ctx.globalCompositeOperation = "destination-out";
    ctx.beginPath();
    ctx.arc(centerX, centerY, innerRadius - (barWidth / 2), 0, 2 * Math.PI);
    if (ctx.fillStyle !== "black") ctx.fillStyle = "black";
    ctx.fill();
    ctx.globalCompositeOperation = "source-over";
    ctx.closePath();
  }
}

/**
 * Blocks
 * @param {Context2D} ctx QML Type (canvas.getContext('2d'))
 * @param {Canvas} canvas QML Type
 */
function blocksRect(ctx, canvas) {
  const canvasHeight = canvas.height;
  const barCount = canvas.barCount;
  const blockWidth = canvas.barWidth;
  const blockHeight = canvas.blockHeight;
  const blockSpacing = canvas.blockSpacing;
  const rowStep = blockHeight + blockSpacing;
  let totalRows = Math.floor((canvasHeight + blockSpacing) / rowStep);
  const centeredBars = !!canvas.centeredBars;
  const columnSpacing = canvas.spacing;
  const values = canvas.values || [];

  // ensure odd row count for symmetry
  if (totalRows > 1 && totalRows % 2 === 0) {
    totalRows--;
  }

  const centerY = canvasHeight / 2;

  for (let col = 0; col < barCount; col++) {
    const value = values[col];
    const activeRows = Math.floor((value / canvasHeight) * totalRows);
    const x = col * (blockWidth + columnSpacing);

    if (centeredBars) {
      const halfRows = Math.floor(totalRows / 2);
      for (let row = -halfRows; row <= halfRows; row++) {
        const y = centerY + row * rowStep - blockHeight / 2;

        // active rows are symmetric around center
        if (Math.abs(row) < Math.ceil(activeRows / 2)) {
          if (ctx.fillStyle !== canvas.gradient) ctx.fillStyle = canvas.gradient;
          ctx.fillRect(x, y, blockWidth, blockHeight);
        } else if (canvas.drawInactiveBlocks) {
          if (ctx.fillStyle !== canvas.inactiveBlockGradient) ctx.fillStyle = canvas.inactiveBlockGradient;
          ctx.fillRect(x, y, blockWidth, blockHeight);
        }
      }
    } else {
      for (let row = 0; row < totalRows; row++) {
        const y = canvasHeight - (row + 1) * blockHeight - row * blockSpacing;
        if (row < activeRows) {
          if (ctx.fillStyle !== canvas.gradient) ctx.fillStyle = canvas.gradient;
          ctx.fillRect(x, y, blockWidth, blockHeight);
        } else if (canvas.drawInactiveBlocks) {
          if (ctx.fillStyle !== canvas.inactiveBlockGradient) ctx.fillStyle = canvas.inactiveBlockGradient;
          ctx.fillRect(x, y, blockWidth, blockHeight);
        }
      }
    }
  }
}

/**
 * Blocks in circle mode
 * @param {Context2D} ctx QML Type (canvas.getContext('2d'))
 * @param {Canvas} canvas QML Type
 */
function blocksCircle(ctx, canvas) {
  const canvasWidth = canvas.width;
  const canvasHeight = canvas.height;
  const maxValue = Math.min(canvasWidth, canvasHeight) / 2;
  const barCount = canvas.barCount;
  const values = canvas.values;
  const barRadiusOffset = canvas.radiusOffset * 2;
  const circleSize = canvas.circleModeSize;
  const spacing = canvas.spacing;
  const blockHeight = canvas.blockHeight;
  const blockSpacing = canvas.blockSpacing;

  const centerX = canvasWidth / 2;
  const centerY = canvasHeight / 2;
  const angleStep = (2 * Math.PI) / barCount;
  const innerRadius = (Math.min(canvasWidth, canvasHeight) / 2) * circleSize - barRadiusOffset;

  const gapAngle = spacing / innerRadius;

  const maxBarLength = (maxValue - 2) * (1 - circleSize);
  const maxRows = Math.floor(maxBarLength / (blockHeight + blockSpacing));

  for (let col = 0; col < barCount; col++) {
    const value = Math.max(1, Math.min(maxValue, values[col]));
    const norm = value / maxValue;
    const barLength = norm * maxBarLength;

    const halfAngle = (angleStep - gapAngle) / 2;
    const angle = (col + 0.5) * angleStep - Math.PI / 2;

    const angle1 = angle - halfAngle;
    const angle2 = angle + halfAngle;

    const activeRows = Math.floor(barLength / (blockHeight + blockSpacing));

    for (let row = 0; row < maxRows; row++) {
      const r1 = innerRadius + row * (blockHeight + blockSpacing);
      const r2 = r1 + blockHeight;

      ctx.beginPath();
      ctx.arc(centerX, centerY, r1, angle1, angle2, false);
      ctx.arc(centerX, centerY, r2, angle2, angle1, true);
      ctx.closePath();

      if (row < activeRows) {
        if (ctx.fillStyle !== canvas.gradient) ctx.fillStyle = canvas.gradient;
      } else if (canvas.drawInactiveBlocks) {
        if (ctx.fillStyle !== canvas.inactiveBlockGradient) ctx.fillStyle = canvas.inactiveBlockGradient;
      } else {
        if (ctx.fillStyle !== "transparent") ctx.fillStyle = "transparent";
      }
      ctx.fill();
    }
  }
}

/**
 * Triangle or square waveform that forms a circle
 * @param {Context2D} ctx QML Type (canvas.getContext('2d'))
 * @param {Canvas} canvas QML Type
 */
function triangleSquareCircle(ctx, canvas) {
  const canvasWidth = canvas.width;
  const canvasHeight = canvas.height;
  const barCount = canvas.barCount;
  const barWidth = canvas.barWidth;
  const fillWave = canvas.fillWave;
  const values = canvas.values;
  const waveMode = canvas.waveMode;

  if (barCount < 2) {
    return;
  }

  const centerX = canvasWidth / 2;
  const centerY = canvasHeight / 2;
  const innerRadius = Math.min(canvasWidth, canvasHeight) / 2 * canvas.circleModeSize;
  const angleStep = (2 * Math.PI) / barCount;

  ctx.lineWidth = barWidth;

  const maxRadius = Math.min(canvasWidth, canvasHeight) / 2;
  const maxValue = maxRadius - innerRadius;

  canvas.gradientHeight = maxValue;

  const valueAt = (index) => Math.max(0, Math.min(maxValue, values[index]));
  const radiusAt = (index) => innerRadius + valueAt(index);
  const pointAt = (index, radius) => {
    const angle = index * angleStep - Math.PI / 2;
    return {
      x: centerX + Math.cos(angle) * radius,
      y: centerY + Math.sin(angle) * radius
    };
  };

  const firstRadius = (radiusAt(0) + radiusAt(barCount - 1)) / 2;
  const first = pointAt(0, firstRadius);
  ctx.beginPath();
  ctx.moveTo(first.x, first.y);

  switch (waveMode) {
    case Enum.WaveMode.Triangle:
      for (let i = 1; i <= barCount; i++) {
        const index = i === barCount ? 0 : i;
        const radius = i === barCount ? firstRadius : radiusAt(index);

        const atRadius = pointAt(index, radius);
        ctx.lineTo(atRadius.x, atRadius.y);
      }
      break;
    case Enum.WaveMode.Square:
      for (let i = 1; i <= barCount; i++) {
        const index = i === barCount ? 0 : i;
        const radius = i === barCount ? firstRadius : radiusAt(index);

        const along = pointAt(index, radiusAt(i - 1));
        const atRadius = pointAt(index, radius);
        ctx.lineTo(along.x, along.y);
        ctx.lineTo(atRadius.x, atRadius.y);
      }
      break;
    default:
      break;
  }

  ctx.closePath();
  ctx.stroke();

  if (fillWave) {
    ctx.fill();
  }

  // inner circle
  if (!circleModeFill) {
    ctx.globalCompositeOperation = "destination-out";
    ctx.beginPath();
    ctx.arc(centerX, centerY, innerRadius - (barWidth / 2), 0, 2 * Math.PI);
    if (ctx.fillStyle !== "black") ctx.fillStyle = "black";
    ctx.fill();
    ctx.globalCompositeOperation = "source-over";
    ctx.closePath();
  }
}
