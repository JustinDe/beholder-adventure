import React from 'react'

type CrystalProps = {
  x: number
  y: number
  cellSize: number
}

export function Crystal({ x, y, cellSize }: CrystalProps) {
  return (
    <div 
      className="absolute w-6 h-6 bg-purple-400 rotate-45"
      style={{
        left: `${x * cellSize + cellSize / 2 - 12}px`,
        top: `${y * cellSize + cellSize / 2 - 12}px`,
      }}
    />
  )
}