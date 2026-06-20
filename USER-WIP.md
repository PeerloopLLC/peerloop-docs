# USER-WIP

> **User-authored.** This is the one file in the dual-repo (and the otherwise read-only folders)
> that the user edits directly, without CC involvement. CC treats it as **read-only** unless
> explicitly asked to touch it.
>
> Purpose: the user's running track of what they want to do as a conv progresses.
> Carry-over between convs is expected — entries may persist across `/r-start` → `/r-end` cycles.

---
## June 20
- RG-COMMS (/communities and /community)

## June 19
- upgraded to Max 200 at 09:40
- RTMIG-4
	- COURSES-FIXES
- SPACING-4px-SWEEP
- SWEEP-SPACING-GREP
## June 18
- [ ] setup Peerloop-docs for OBSIDIAN
- [ ] #next-step .scratch rename to _scratch on M4 (M4Pro done)  
    ▎ Set up the .scratch → _scratch Obsidian alias on this machine (M4), same as I did on MacMiniM4Pro.  
    ▎  
    ▎ Context: ~/projects/peerloop-docs is an Obsidian vault; Obsidian hides dot-folders, so we make _scratch the real  
    ▎ folder and .scratch a symlink to it. The .gitignore already ignores both (.scratch + _scratch/) — that change  
    ▎ synced via git, so don't touch .gitignore. Only the rename + symlink is machine-local and needs doing here.  
    ▎  
    ▎ Steps:  
    ▎ 1. First confirm current state: ls -ld ~/projects/peerloop-docs/.scratch ~/projects/peerloop-docs/_scratch. If .scratch is  
    ▎ already a symlink or _scratch already exists, STOP and tell me — it's already done.  
    ▎ 2. If .scratch is a real directory and there's no _scratch: cd ~/projects/peerloop-docs && mv .scratch _scratch && ln  
    ▎ -s _scratch .scratch  
    ▎ 3. Verify: readlink .scratch shows _scratch; git check-ignore -v .scratch _scratch shows both ignored; git  
    ▎ status --short shows no scratch content leaking in.  

## Notes / parking lot

