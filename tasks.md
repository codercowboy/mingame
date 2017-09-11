# Tasks / Project Plan

# Bugs

 * Need a way to restart level when user gets stuck
 * crashes when user attempts to go off screen when level has player outside of screen
 * level editor shouldnt erase blocks in the middle of new box of blocks while dragging on screen

# Features

 * After user completes tutorial, fade to menu screen
 * don't show user menu screen until they have completed tutorial
 * every launch after tutorial completed goes to level 1, then after completing level 1 goes to main screen
 * main screen: circular buttons with icons in them: play from start, level selection, credits
 * change user movement to be one smooth touches tracking rather than swipes
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
 * add license to source files 
 * add font awesome rendering into project
 * change app-wide font to typewriter 
 * add shark or my music
 * add splash screen

# Before Release

 * How does it look on a iphone plus?
 * add url to download game in share text
 * update codercowboy to have
   * animated gif of first level
   * link to book
   * logo with white wikibuy font, dot over 'i' is blue door key
   * links to linkedin, github

# Future Ideas

 * Improve rendering engine to be three-phase as described in the TODOs in GameEngine
 * level editor ability to zoom in and work at a more detailed level
 * level editor undo/redo
 * Make level editor IAP
 * allow user to copy and edit main game levels
 * document code :P
 * Create level submission email, add ability to submit levels
 * allow multiple players in level
 * make it ipad compatible
 * consider coins collected in game to unlock worlds or editor assets
