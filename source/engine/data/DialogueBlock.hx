package engine.data;

typedef DialogueBlock = {
    var name:String; // Character name
    var text:String; // Dialogue text
    var typingSpeed:Float; // Text typing speed 
    var events:Array<DialogueEvent>; // Events to occur on this dialogue block
}