package com.dinox.model;
import com.genome2d.callbacks.GCallback.GCallback1;
class DevHandler {
    private static var  instance: DevHandler = null;
    private var _onJsonEdited: GCallback1<Bool>;


    private function new() {
        instance = this;

        _onJsonEdited = new GCallback1<Bool>();
    }

    inline static public function getInstance(): DevHandler {
        if(instance == null) {
            instance = new DevHandler();
        }
        return instance;
    }

    public function saveEditsToJson(): Void {
        // TO-DO implement this
    }

    public var onJsonEdited(get, never):GCallback1<Bool>;
    inline private function get_onJsonEdited():GCallback1<Bool> {
        return _onJsonEdited;
    }

    public function dispose():Void {
        _onJsonEdited.removeAll();
    }
}
