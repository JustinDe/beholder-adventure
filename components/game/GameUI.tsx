import React from 'react'

type GameUIProps = {
  hp: number
  mp: number
  sp: number
}

export function GameUI({ hp, mp, sp }: GameUIProps) {
  const actions = [
    { icon: '🔥', cost: 30 },
    { icon: '💥', cost: 40 },
    { icon: '☄️', cost: 80 },
    { icon: '❄️', cost: 10 },
    { icon: '⚡', cost: 20 },
    { icon: '🌪️', cost: 20 },
    { icon: '🌊', cost: 30 },
    { icon: '🌈', cost: 50 },
  ]

  return (
    <div className="flex justify-between items-center p-4 bg-[#0f3460]">
      <div className="grid grid-cols-4 gap-2">
        {actions.map((action, index) => (
          <button
            key={index}
            className="w-12 h-12 bg-[#16213e] rounded flex items-center justify-center text-2xl relative"
          >
            {action.icon}
            <span className="absolute bottom-0 right-0 text-xs bg-[#e94560] rounded-full px-1">
              {action.cost}
            </span>
          </button>
        ))}
      </div>
      <div className="flex flex-col items-end">
        <div className="flex items-center mb-2">
          <span className="mr-2">HP</span>
          <div className="w-32 h-4 bg-[#16213e] rounded-full overflow-hidden">
            <div
              className="h-full bg-[#e94560]"
              style={{ width: `${(hp / 100) * 100}%` }}
            ></div>
          </div>
          <span className="ml-2">{hp}/100</span>
        </div>
        <div className="flex items-center mb-2">
          <span className="mr-2">MP</span>
          <div className="w-32 h-4 bg-[#16213e] rounded-full overflow-hidden">
            <div
              className="h-full bg-[#4e9eff]"
              style={{ width: `${(mp / 100) * 100}%` }}
            ></div>
          </div>
          <span className="ml-2">{mp}/100</span>
        </div>
        <div className="flex items-center">
          <div className="w-12 h-12 bg-[#16213e] rounded-full flex items-center justify-center text-2xl font-bold text-[#e94560]">
            {sp}
          </div>
        </div>
      </div>
    </div>
  )
}