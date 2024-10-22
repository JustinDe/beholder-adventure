import React from 'react'

type BulletProps = {
  x: number
  y: number
  size: number
}

export function Bullet({ x, y, size }: BulletProps) {
  return (
    <div 
      className="absolute bg-yellow-400 rounded-full"
      style={{
        left: `${x - size / 2}px`,
        top: `${y - size / 2}px`,
        width: `${size}px`,
        height: `${size}px`,
      }}
    />
  )
}