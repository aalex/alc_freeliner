### Version 0.4 ###
 * New command system
 * Masking, hitting `ctrl-m` will make a mask. Any pixels with some green will be transparent.
 * Fragment shaders. `p` to enable disable set shader.

### Version 0.3.2 ###
 * Substantial changes, testing encouraged.
 * Effects of animationMode are transfered into the more versatile enterpolator, use the `e` key to change it.
 * Painters have a array of Interpolators and a getPosition(Segment) to use them.
 * Saving geometry and templates (finaly) is now with ctrl-s and loading with ctrl-o

### Version 0.3.1 ###
* You can copy and paste templates now, ctrl-c still works the same, but you can paste with ctrl-v if you have a template selected.
* Group add template changed, check README. (works with ctrl-b)
-------
* Enabler `e` mode 0 now really disables, even disable triggering. Replaced with 2, which prevents looping but allows triggering.
* `>` for sequencer, check README.md
* Added `FreelinerConfig.pde` check it out for a bunch of settings.
