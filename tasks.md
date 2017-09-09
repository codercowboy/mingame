# Tasks / Project Plan

# Bugs

 * editor: when user adds level, automatically place player and end in level 
 * editor: when user places player, remove other player objs
 * Need a way to restart level when user gets stuck
 * How does it look on a iphone plus?
 * crashes when user attempts to go off screen when level has player outside of screen

# Features

 * After user completes tutorial, fade to menu screen
 * don't show user menu screen until they have completed tutorial
 * every launch after tutorial completed goes to level 1, then after completing level 1 goes to main screen
 * main screen: circular buttons with icons in them: play from start, level selection, credits
 * change monster level up to have a key in it so it's clear the level is being reset
 * level selection screen tab bar at top with three level sets: world (preconfigured) levels, my levels, friends levels - friends level unlocks when one is shared to you
 * add monster pathing (and thus game clock)
 * when new level is added, prompt user with chance to play it, or error if it is corrupt

# Cleanup / Polish

 * allow user to rearrange their levels 
 * level serializer should auto trim empty rows and columns leading and trailing the level (leave one blank row/column on every side though)
 * automatically center level in center of screen
 * When user dies, fade screen to red, then back out to reset level
 * make walls have a white or grey border
 * add indicator on screen showing keys user has
 * move rendering out to GameRenderer
 * reorganize project layout on disk
 * mention usage of font awesome in about section


# future ideas

 * Improve rendering engine to be three-phase as described in the TODOs in GameEngine
 * level editor ability to zoom in and work at a more detailed level
 * level editor undo/redo
 * Make level editor IAP
 * allow user to copy and edit main game levels
 * document code :P
 * Create level submission email, add ability to submit levels
 * allow multiple players in level
