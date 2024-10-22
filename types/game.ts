// types/game.ts

export type GameState = {
    playerPosition: { x: number; y: number }
    playerHP: number
    playerMP: number
    playerSP: number
    score: number
    enemies: Enemy[]
    bullets: Bullet[]
    crystals: Crystal[]
    turn: number
    gameOver: boolean
    isPlayerTurn: boolean
  }
  
  export type Enemy = {
    id: number
    x: number
    y: number
    hp: number
    size: 1 | 2 | 3
  }
  
  export type Bullet = {
    id: number
    x: number
    y: number
    dx: number
    dy: number
  }
  
  export type Crystal = {
    id: number
    x: number
    y: number
  }