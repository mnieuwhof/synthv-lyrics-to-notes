--  Lyrics to Notes
function getClientInfo()
    return {
        name = "Lyrics To Notes",
        author = "TCAS (Marc Nieuwhof)",
        versionNumber=1,
        minEditorVersion=65540
  }
end

function main()

    -- Init some stuff
    local noteGroup = {}
    local newNote = {}
    local noteCounter = 1
    local firstNote = true
    local noteOnset = 0
    local noteDivider = 2
    local defaultPitch = 48
    local maxInterval = 8

    local lyrics = "The something went wrong song"
    local singingSpeedCb = {"Normal","Slow","Fast"}
    local singingSpeed = 0
    local noteGroupName = ""
    
    local scales = {}
    local intervals = {}
    local selectedScale = 0
    local selectedInterval = 0
    local rootNotes = {"c","c#","d","d#","e","f","f#","g","g#","a","a#","b"}
    local selectScales = {"Major","Natural Minor","Melodic Minor","Harmonic Minor","Dorian","Locrian","Lydian","Mixolydian","Phrygian","No scale"}
    
    -- Setup scales and intervals
    -- Major
    intervals[1]={0,2,4,5,7,9,11,12}
    -- Natural Minor
    intervals[2]={0,2,3,5,7,8,10,12}
    -- Melodic Minor
    intervals[3]={0,2,3,5,7,9,11,12}
    -- Harmonic Minor
    intervals[4]={0,2,3,5,7,8,11,12}
    -- Dorian
    intervals[5]={0,2,3,5,7,9,10,12}
    -- Locrian
    intervals[6]={0,1,3,5,6,8,10,12}
    -- Lydian
    intervals[7]={0,2,4,6,7,9,11,12}
    -- Mixolydian
    intervals[8]={0,2,4,5,7,9,10,12}
    -- Phrygian
    intervals[9]={0,1,3,5,7,8,10,12}
    -- No scale
    intervals[10]={0,0,0,0,0,0,0,0}

    -- Create a note group
    noteGroup=SV:create("NoteGroup")

    -- Define the form to enter the lyrics
    local MainForm = {
        title = "Lyrics To Notes",
        message = "Type in lyrics to be converted to notes",
        buttons = "OkCancel",
        widgets = {
            {
                name = "tb1",
                type = "TextBox",
                label = "Name of notegroup",
                default = "Verse"
            },
            {
                name = "ta1",
                type = "TextArea",
                label = "Lyrics",
                height = 100,
                default = "Type or paste lyrics here..."
            },
            {
                name = "cbr",
                type = "ComboBox",
                label = "I want the following rootnote",
                choices = rootNotes,
                default = 0
            },
            {
                name = "cbs",
                type = "ComboBox",
                label = "In the following scale",
                choices = selectScales,
                default = 9
            },
            {
                name = "check1",
                type = "CheckBox",
                text = "I want to use tight pitches",
                default = true
            },
            {
                name = "cb3",
                type = "ComboBox",
                label = "I want the singing speed set to",
                choices = singingSpeedCb,
                default = 0
            }
        }
    }
    
    -- Bring up the form
    local formResult = SV:showCustomDialog(MainForm)
    if formResult.status == true then
        lyrics = tostring(formResult.answers.ta1)
        if formResult.answers.cb3 == 1 then
            noteDivider=1
            singingSpeed=2
        elseif formResult.answers.cb3 == 2 then
            noteDivider=4
            singingSpeed=3
        else
            noteDivider=2
            singingSpeed=1
        end

        -- Extract lyrics to words
        for word in
            string.gmatch(lyrics, "%w+")
        do
            -- create a new note for each word
            newNote[noteCounter] = SV:create("Note")
            newNote[noteCounter]:setLyrics(word)
            newNote[noteCounter]:setDuration(SV:quarter2Blick(word:len()) / noteDivider)
            
            -- Get selected scale and interval
            selectedScale = formResult.answers.cbs+1

            -- Check if tight pitches is set. If so, then max interval will be set to 4
            if formResult.answers.check1 == true then
                maxInterval = 4
            end
            selectedInterval = math.random(1,maxInterval)
            
            -- Get de rootnote as default pitch from C3
            defaultPitch=48+formResult.answers.cbr

            -- Add note based on scale selection
            if firstNote == true then
                newNote[noteCounter]:setPitch(defaultPitch)
                firstNote = false
            else
                newNote[noteCounter]:setPitch(defaultPitch + intervals[selectedScale][selectedInterval])
            end

            -- Set the new note onset based on previous note lenghts          
            if noteCounter == 1 then
                noteOnset = 0
            else
                noteOnset = noteOnset + newNote[noteCounter - 1]:getDuration()
            end
            newNote[noteCounter]:setOnset(noteOnset)

            -- Add the note to the note group
            noteGroup:addNote(newNote[noteCounter])

            -- Increase note counter
            noteCounter = noteCounter + 1
        end

        -- Set the note group name including speed/scale tag
        if string.len(tostring(formResult.answers.tb1))>0 then
            noteGroupName = tostring(formResult.answers.tb1)
        else
            noteGroupName = "Notegroup"
        end
        noteGroup:setName(noteGroupName .. string.lower(" (" .. rootNotes[formResult.answers.cbr+1] .. " " .. selectScales[formResult.answers.cbs+1] .. "/" .. singingSpeedCb[formResult.answers.cb3+1] .. ")"))

        -- Add the note group to the project
        SV:getProject():addNoteGroup(noteGroup)

    end

    -- Clean up
    SV:finish()

end