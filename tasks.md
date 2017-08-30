# Tasks / Project Plan

# Bugs

 * Need a way to restart level when user gets stuck

# Levels

 * level: powerup to kill a single monster (wall of monsters must be broken through)
 * leve: two powerups to kill monster (wall of monsters blocks path, then another powerup down a path to the left, then a second wall of monsters blocks path to exit)
 * level: three powerups to kill monsters, then a triple wall of monsters
 * level: rainbow powerup to kill all monsters
 * level: moving monster moving left and right

# Features

 * Make level editor
 * Add tick to game
 * Give objects multiple sprites to animate based on ticks
 * Give objects a path of positions to move based on ticks
 * Improve rendering engine to be three-phase as described in the TODOs in the draw function
 * Add ability for blocks to be chained to other blocks and dissapear when one a position is touched
 * Allow multiple players in level
 * After user completes tutorial, fade to menu screen w/ options: play, select level, edit level, credits
 * Make level editor IAP
 * Add ability to share levels via copy/paste
 * Add ability to share levels via email
 * Create level submission email mingame@codercowboy.com, add ability to submit levels

# Cleanup / Polish

 * automatically center level in center of screen
 * When user dies, fade screen to red, then back out to reset level
 * add indicator on screen showing keys/powerups user has
 * move rendering out to GameRenderer
