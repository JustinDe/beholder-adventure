import React from 'react'

type PlayerProps = {
  position: { x: number; y: number }
}

export default function Player({ position }: PlayerProps) {
  return (
    <div 
      className="absolute w-10 h-10 bg-blue-500 rounded-full"
      style={{
        left: `${position.x * 60}px`,
        top: `${position.y * 60}px`,
      }}
    />
  )
}