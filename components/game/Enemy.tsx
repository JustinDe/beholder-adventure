import React from 'react'

type EnemyProps = {
  x: number
  y: number
  hp: number
  size: 1 | 2 | 3
  cellSize: number
}

export function Enemy({ x, y, hp, size, cellSize }: EnemyProps) {
  const sizeClass = size === 1 ? 'w-10 h-10' : size === 2 ? 'w-20 h-20' : 'w-30 h-20'
  
  return (
    <div 
      className={`absolute ${sizeClass} bg-red-500 flex items-center justify-center`}
      style={{
        left: `${x * cellSize}px`,
        top: `${y * cellSize}px`,
      }}
    >
      <span className="text-white font-bold">{hp}</span>
    </div>
  )
}