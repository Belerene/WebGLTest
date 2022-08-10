package com.dinox;

@:expose
class Resizer {
    var name:String;

    public function new(name:String) {
        this.name = name;
    }

    public function foo() {
        return 'Greetings from $name!';
    }
}