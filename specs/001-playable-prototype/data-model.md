# Data Model: Playable Bounce Combat Prototype

## Player State

- `HP`: Current player health, max 100.
- `MP`: Spell resource, max 100 in current prototype.
- `SP`: Shot Points, starts at 1 and controls number of balls launched per shot.
- `Status Effects`: Floor invulnerability, ward, reraise, and detrimental effects.
- `Spell Cooldowns`: Mapping of spell id to turns remaining.

## Board

- `Grid Size`: Number of columns and rows.
- `Board Origin`: Pixel origin for cell conversion.
- `Cell Size`: Pixel width/height for grid cells.
- `Player Row`: Current launcher row at the right side of the board.
- `Obstacles`: Cell-aligned blocking/bounce rectangles.

## Ball Projectile

- `Position`: Current world position.
- `Velocity`: Current movement vector.
- `Bounce Count`: Number of board-wall bounces.
- `Damage`: Damage applied to enemies on hit.
- `Active`: Whether it is processed.

## Enemy

- `Enemy Type`: Identifier from enemy type data.
- `Grid Cell`: Initial cell placement.
- `HP / Max HP`: Health values.
- `Score Value`: Base score granted on hit/defeat.
- `Movement Flag`: Whether enemy has simple idle movement.

## SP Node

- `Grid Cell`: Placement in level data.
- `SP Value`: Amount added to player SP on collection.
- `Collected`: Prevents duplicate collection.

## Spell

- `ID`: Stable spell identifier.
- `Name`: Display name.
- `MP Cost`: MP consumed on cast.
- `Recast Turns`: Cooldown turns after cast.
- `Availability`: Minimum and maximum stage.
- `Effect`: Gameplay outcome such as damage, healing, cleanse, barrier, or revival.

## Level Data

```json
{
  "id": "level_001",
  "grid_size": [10, 8],
  "ball_start": [5, 7],
  "obstacles": [[1, 3]],
  "sp_nodes": [{ "cell": [5, 3], "value": 1 }],
  "enemies": [{ "type": "basic_slime", "cell": [3, 2] }]
}
```
