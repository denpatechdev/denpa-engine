package engine.parsers;

import engine.data.Branches;
import engine.data.DialogueBlock;
import engine.data.DialogueEvent;

using StringTools;


class DialogueParser {

    static final BRANCH_SEPERATOR = '///';
    static final TEXT_SEPERATOR = ':';
    static final DIALOGUE_DATA_START_CHAR = '[';
    static final DIALOGUE_DATA_END_CHAR = ']';
    static final DIALOGUE_DATA_SEPERATOR = '|';
    static final EVENT_SEPERATOR = ';';
    static final EVENT_PARAM_SEPERATOR = ',';

    public static function read(data:String) {
        var branchesData = data.split(BRANCH_SEPERATOR);
        branchesData.shift(); // Get rid of empty string
        var branches:Branches = []; 
        for (b in branchesData) {
            var data = b.split('\n'); // split dialogue lines + branch line
            var branchName = data.shift(); // get branch name, and also remove branch line to only retain dialogue
            var dlgBlocks:Array<DialogueBlock> = [];
            for (d in data) {
                dlgBlocks.push(parseLine(d));
            }
            branches[branchName] = dlgBlocks;
        }
        return branches;
    }

    public static function parseLine(line:String):DialogueBlock {
        var text = line.substring(line.indexOf(TEXT_SEPERATOR)+1, line.length); // text is after :
        //trace(text);
        var dlgDataStart = line.indexOf(DIALOGUE_DATA_START_CHAR) + 1; // typing speed and events are between the []
        var dlgDataEnd = line.indexOf(DIALOGUE_DATA_END_CHAR);
        var dlgDataSubstr = line.substring(dlgDataStart, dlgDataEnd);
        var name = line.substring(0, dlgDataStart - 1);
        trace(dlgDataSubstr);
        var dlgData = dlgDataSubstr.split(DIALOGUE_DATA_SEPERATOR); // typing speed and events list split by |
        var evs:Array<DialogueEvent> = []; // ev = event
        var typingSpeed:Float = 1/26; // default typing speed ig
        for (i in 0...dlgData.length) {
            switch (i) {
                case 0: // typing speed
                    if (dlgData[0] != null && dlgData[0].length > 0)
                        typingSpeed = Std.parseFloat(dlgData[0]);
                    trace(typingSpeed);
                case 1: // events
                    var evData = dlgData[1].split(EVENT_SEPERATOR); // event1 params here;event2 params here
                    // trace(evData);
                    for (ev in evData) {
                        var evContents = ev.split(EVENT_PARAM_SEPERATOR); // params split by ,
                        var evName = evContents.shift(); // get event name and get rid of evName from params list 
                        evs.push(createEv(evName, evContents));
                    }
            }
        }

        return {
            name: name,
            text: text,
            typingSpeed: typingSpeed,
            events: evs
        };
    }

    private static inline function createEv(name:DialogueEvents, args:Array<Dynamic>):DialogueEvent {
        return {name: name, args: args};
    }
}