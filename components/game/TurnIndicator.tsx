import React from 'react'

type TurnIndicatorProps = {
  isPlayerTurn: boolean
}

export function TurnIndicator({ isPlayerTurn }: TurnIndicatorProps) {
  return (
    <div className="absolute top-2 left-2 bg-gray-800 border border-gray-600 rounded px-3 py-1 text-sm">
      {isPlayerTurn ? (
        <span className="text-green-400">Player&apos;s Turn</span>
      ) : (
        <span className="text-red-400">Enemies&apos; Turn</span>
      )}
    </div>
  )
}