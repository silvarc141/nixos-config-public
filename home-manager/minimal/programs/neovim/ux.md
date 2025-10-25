# UX plan
## Compatibility vs UX
- basic default vim compatibility, don't unbind everything
- lots of overlap in default vim keymaps, replace keys or merge them to get better possibilities
## Sane completion
- completion ui should be super fast
- completion ui does not need a lot of items
- completion ui should appear automatically everywhere where applicable
- NO completion keymap should overlay existing keymap
- NO using enter/space to finish completion
- dedicated completion key: <Tab>
- dedicated completion prev/next: <C-P>, <C-N>
## Core actions
- dedicated (in all modes) quit window/buffer key: <C-c> (mode stays the same)
- dedicated (in all modes) quit mode key: <C-[> (window stays the same)
## Command window
- instead of command mode, always use command window
- bind : to "q:i"
- eventually make a simple reimplementation, default is limited
## Predictable keymaps
- pickers that can open buffers, can open in splits, vsplits or tabs with the same keybind
## Non-default useful core actions
### Surround
- perfect example of a super useful set of basic operations
- map to s
### Subword
- move by subword back and forth would be useful
- if we can unmap <C-W> (wincmd), then maybe:
    - by default subword motion
    - with ctrl, regular word motion
    - with shift, WORD motion
### Multicursor
- is it needed?
- maybe on x?
### Moving objects
- would be cool to be able to move or swap stuff in a syntax aware fashion
- research treesitter-objects moving and swapping
## Non-operator, non-leader keys (as in, only one purpose, limited usability)
### \ {free}
- free real estate
- not that close though
### x {free}
- encourages key spamming
- whole key near homerow to do "dl"
- find something cool to replace it
### s {free} {surround}
- whole key on homerow to do "cl"
- perfect place for surround, a super useful set of operators
### w, e, b, (ge) {potentially free e}
- used for moving around by spamming
- used for operators
    - for equal or longer than word, textobjects can be used instead
    - for smaller than word, f/t can be used instead
- can they be merged?
- lets try it if there is a good keymap in place of e
### f, t {potentially free t}
- important
- can they be merged? maybe
- t often used with d
- f often used to navigate
- would it work if we made f go back one character when used by an operator?
### ; {potentially free ;}
- improves f, but a jumping plugin can do the same
- is also kind of spammy by nature
- only reason is to be compatible with defaults
- could be bound to : if using a lot of cmdline
### a, i {potentially free a, but not really}
- important
- can they be merged? mhm
### h, j, k, l
- encourage key spamming (or holding)
- good for small movements and choosing direction
- arrowy, intuitive, let them stay
### r
- r is similar to s and x but actually useful in practice
- good for fixing typos
### o, p
- important, useful, don't remap
### q, m, ", ', ], [, 1-9
- core vim stuff
## minor QoL ideas
- after deleting with textobjects like diw, merge double spaces near
- map 0 ^ -> 0 is accessible, ^ works better
## Tab in normal?
- can't use tab in normal, it's the same as <C-I> for terminals, and <C-I> is the default for jump forward
