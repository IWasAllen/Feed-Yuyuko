**You may read the warnings and things that might happen during the game, that may have effects in your device.**<br>

* External Processing
  * Dropping a file to the game will move it to the stomach folder, where it will be deleted after 8 hours.
  * Feeding a lot files will make Yuyuko puke out most of the file in the stomach folder, the puked out files will be moved to Deskop and might fill up the entire thing.
  * Memory is saved externally every second, it is compressed and decompress during writing and loading. This is tested and should have no affect on performance or anything, However it is unsure what might happen when the program is killed or closed midway during the memory saving or loading.
  * The stomach files will get deleted after 8 hours

* Internal Processing
  * The spritesheets contains transparency, with a resolution of 6400x1280, between the size of 1 to 2 megabytes.
  * Each time Yuyuko changes emotion state, it loads a specific spritesheet which may spike the fps for few seconds.
  * Centering and scaling resolution works really great, but I did not gave too much effort so it is really messy.
 
  * <details>
    <summary>Spoiler</summary>
    When Yuyuko reaches hunger level of zero, the yuyuko assets folder contents gets deleted, except for the stomach folder.
    </details>
  
 <br><br>

The assets can be found by renaming the file extension from .exe to .zip
