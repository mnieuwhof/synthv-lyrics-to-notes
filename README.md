# synthv-lyrics-to-notes
A Synthesizer V script to convert lyrics to notes

This script creates random notes in a notegroup based on given lyrics.

I think Synthesizer V should have this functionality out of the box but it hasn't.

I'm not good a LUA, this was my first attempt so don't bomb me with requests.

This is a public GIT so everyone with a Github account can make it a better script.

The script does the following:

![dialog](https://github.com/user-attachments/assets/42d41cf8-b7dd-4c81-b2d9-de924e0dc96b)

Name of notegroup: Name of the note group (scale en speed will be added to the name)

Lyrics: Texbox where the lyrics can be typed or pasted.

I want the following rootnote: Rootnote (the first word starts at the rootnote)

In the following scale: Musical scale

I want tight pitches: When checked the script will use max 4 intervals starting from the rootnote, when unchecked all intertvals will be used.

I want the singing speed set to: Makes the notes longer, shorter or normal.

Ok to create the notegroup.

NOTE: The new notegroup is not put on the time line automatically. You have to drag it from your library to the timeline:

![addnotegroup](https://github.com/user-attachments/assets/05adb99e-2497-469c-8a21-d9cc2f4f334a)

I did choose for notegroups because you can make different ones based on verses, choruses and other scales.


Enjoy!
