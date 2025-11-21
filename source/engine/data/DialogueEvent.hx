package engine.data;

enum abstract DialogueEvents(String) from String to String {
	var CreateSprite; // [sprite id, filepath] (creates sprite and assigns it an id)
	var DeleteSprite; // [sprite id] (delete sprite)
	var SetBG; // [filepath] (set bg)
	var SetBGM; // [filepath] (set bgm)
	var PlaySound; // [filepath] (play a sound)
	var MoveSprite; // [sprite id, x, y] (move a sprite)
	var ChangeSprite; // [sprite id, filepath] (change a sprite's graphic)
	var SetDialogue; // [filepath, branch] (loads and changes to a new dialogue file)
	var SetBranch; // [branch name] (set dialogue branch)
	var Choice; // [text, branch] (create choice)
}

typedef DialogueEvent = {
    var name:DialogueEvents; // Event type/name
    var args:Array<Dynamic>; // Event arguments
}