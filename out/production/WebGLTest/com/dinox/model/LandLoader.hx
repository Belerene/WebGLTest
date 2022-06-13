package com.dinox.model;
import haxe.io.Bytes;
import com.genome2d.debug.GDebug;
import haxe.Http;
class LandLoader {
    public static var LandJsonPath: String = "./tmp_lands.json";

    private var request: Http = null;
    public function new(p_url: String) {
        request = new Http(p_url);
    }

    public function makeRequest(p_post: Bool = false): Void {
        request.request(p_post);
    }

    public function addOnDataReceived(p_handler: String->Void = null) {
        request.onData = p_handler;

        //TMP
        if(p_handler == null) {
            request.onData = onDataReceived;
        }
    }

    public function addOnErrorReceived(p_handler: String->Void = null) {
        request.onError = p_handler;

        //TMP
        if(p_handler == null) {
            request.onError = onErrorReceived;
        }
    }

    public function addOnStatusReceived(p_handler: Int->Void = null) {
        request.onStatus = p_handler;

        //TMP
        if(p_handler == null) {
            request.onStatus = onStatusReceived;
        }
    }

    public function addOnBytesReceived(p_handler: Bytes->Void = null) {
        request.onBytes = p_handler;

        //TMP
        if(p_handler == null) {
            request.onBytes = onBytesReceived;
        }
    }

    private function onDataReceived(p_data: String): Void {
        GDebug.info("Data received: " + p_data);
    }

    private function onErrorReceived(p_msg: String): Void {
        GDebug.warning("Error received: " + p_msg);
    }

    private function onStatusReceived(p_status: Int): Void {
        GDebug.info("Status received: " + p_status);
    }

    private function onBytesReceived(p_data: Bytes): Void {
        GDebug.info("Bytes received: " + p_data);
    }
}
