import Game from '../components/game/Game'

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-4 bg-gray-900">
      <Game />
    </main>
  )
}