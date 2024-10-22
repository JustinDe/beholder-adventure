import React, { useRef, useEffect } from 'react'

type AimGuideProps = {
  start: { x: number; y: number }
  end: { x: number; y: number }
  gridWidth: number
  gridHeight: number
  cellSize: number
}

export function AimGuide({ start, end, gridWidth, gridHeight, cellSize }: AimGuideProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null)

  useEffect(() => {
    const canvas = canvasRef.current
    if (!canvas) return

    const ctx = canvas.getContext('2d')
    if (!ctx) return

    ctx.clearRect(0, 0, canvas.width, canvas.height)
    
    // Draw dotted line (aim guide)
    ctx.beginPath()
    ctx.moveTo(start.x * cellSize + cellSize / 2, start.y * cellSize + cellSize / 2)
    ctx.lineTo(end.x, end.y)
    ctx.setLineDash([5, 5])
    ctx.strokeStyle = 'yellow'
    ctx.lineWidth = 2
    ctx.stroke()

    // Draw solid line (shot direction)
    ctx.beginPath()
    ctx.moveTo(start.x * cellSize + cellSize / 2, start.y * cellSize + cellSize / 2)
    const dx = end.x - (start.x * cellSize + cellSize / 2)
    const dy = end.y - (start.y * cellSize + cellSize / 2)
    const length = Math.sqrt(dx * dx + dy * dy)
    const unitX = dx / length
    const unitY = dy / length
    ctx.lineTo(
      start.x * cellSize + cellSize / 2 + unitX * cellSize * 3,
      start.y * cellSize + cellSize / 2 + unitY * cellSize * 3
    )
    ctx.setLineDash([])
    ctx.strokeStyle = 'yellow'
    ctx.lineWidth = 3
    ctx.stroke()
  }, [start, end, gridWidth, gridHeight, cellSize])

  return (
    <canvas 
      ref={canvasRef} 
      width={gridWidth * cellSize} 
      height={gridHeight * cellSize} 
      className="absolute top-0 left-0 pointer-events-none"
    />
  )
}