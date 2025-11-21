package engine.data;

enum abstract DialogueEvents(String) from String to String {
    var CreateSprite; // [sprite id, filepath]
    var DeleteSprite; // [sprite id]
    var SetBG; // [filepath]
    var SetBGM; // [filepath]
    var PlaySound; // [filepath]
    var MoveSprite; // [sprite id, x, y]
    var ChangeSprite; // [sprite id, filepath]
    var SetDialogue; // [filepath, branch] (this loads and changes to a new dialogue file)
    var SetBranch; // [branch name]
    var Choice; // [text, event]
}

typedef DialogueEvent = {
    var name:DialogueEvents; // Event type/name
    var args:Array<Dynamic>; // Event arguments
}