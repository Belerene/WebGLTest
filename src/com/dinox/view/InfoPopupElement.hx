package com.dinox.view;
import com.genome2d.debug.GDebug;
import haxe.format.JsonParser;
import com.genome2d.ui.skin.GUITextureSkin;
import com.genome2d.textures.GTextureManager;
import com.genome2d.assets.GAsset;
import haxe.Http;
import com.dinox.model.tile.TileSizeType;
import com.dinox.model.tile.TileRarityType;
import com.dinox.model.tile.Land;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.ui.element.GUIElement;
class InfoPopupElement {

    private static var MAX_OWNER_NAME_LEN: Int = 10;
    private var popupXml: Xml = GStaticAssetManager.getXmlAssetById("popup_element").xml;
    private var popupElement: GUIElement;
    private var land: Land;
    private var request: Http = null;
    private var canClaimSelectedLand: Bool = false;


    public function new(p_land: Land) {
        popupElement = new GUIElement();
        popupElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(popupXml.toString());
        invalidate(p_land);
    }

    public function invalidate(p_land: Land): Void {
        land = p_land;
        popupElement.getChildByName("info_popup_title", true).model = "X:" + land.getX() + "      Y:" + land.getY();
        popupElement.getChildByName("info_popup_title_id", true).model = "ID: #" + land.getId();
        popupElement.getChildByName("info_popup_rarity", true).model = land.getRarityAsString().charAt(0).toUpperCase() + land.getRarityAsString().substr(1);
        popupElement.getChildByName("info_popup_rarity", true).skin.color = TileRarityType.getColorForRarity(land.getRarityAsString());
        popupElement.getChildByName("info_popup_size", true).model = TileSizeType.sizeToString(land.getSize());

        request = new Http("https://api.dinox.io/land/metadata/" + land.getId());
        request.onData = onLandOwnerReceived;
        request.request(false);

        popupElement.getChildByName("info_popup_owner", true).model = processOwnerName("...");
        if(Main.IS_DEV) popupElement.setState("dev");
        popupElement.flushBatch = true;
        var url: String = "http://storage.googleapis.com/dinox-static-prod/lands/land_" + land.getId() + ".png";
        if(GTextureManager.getTexture("land_" + land.getId()) == null) {
            var asset: GAsset = GStaticAssetManager.addFromUrl(url, "land_" + land.getId());
            GStaticAssetManager.loadQueue(assetsLoaded);
        } else {
            var texture: GUITextureSkin = new GUITextureSkin("land_" + land.getId(), GTextureManager.getTexture("land_" + land.getId()));
            texture.scaleY = texture.scaleX = 0.5;
            popupElement.getChildByName("info_popup_land_asset", true).skin = texture;
        }
        var texture: GUITextureSkin = new GUITextureSkin("claim_button", GTextureManager.getTexture('assets/atlas.png_claim_button'));
        popupElement.getChildByName("info_popup_claim_land_btn", true).skin = texture;
        resolveClaimableSelectedLand();
        if(canClaimSelectedLand) {
            popupElement.setState("claimable");
        } else {
            popupElement.setState("owned");
        }
    }

    private function resolveClaimableSelectedLand() {
        if(Main.userTickets.indexOf(land.getTicket()) >= 0 &&
            land.getOwner() == "Claimable") {
            canClaimSelectedLand = true;
        } else {
            canClaimSelectedLand = false;
        }
    }

    private function processOwnerName(p_name: String): String {
        if(p_name.length > MAX_OWNER_NAME_LEN) {
            return p_name.substr(0, 5) + "..." + p_name.substr(p_name.length-3, p_name.length);
        }
        return p_name;
    }

    public function landClaimed(): Void {
        canClaimSelectedLand = false;
//        land.setOwner("Owned");
        popupElement.setState("owned");
    }

    public function getCanClaimSelectedLand(): Bool {
        return canClaimSelectedLand;
    }

    public function getLand(): Land {
        return land;
    }

    public function getGuiElement(): GUIElement {
        return  popupElement;
    }

    private function assetsLoaded(): Void {
        GTextureManager.createTexture(GStaticAssetManager.getImageAssetById("land_" + land.getId()).id, cast GStaticAssetManager.getImageAssetById("land_" + land.getId()));
        var texture: GUITextureSkin = new GUITextureSkin("land_" + land.getId(), GTextureManager.getTexture("land_" + land.getId()));
        texture.scaleY = texture.scaleX = 0.5;
        popupElement.getChildByName("info_popup_land_asset", true).skin = texture;
    }

    private function onLandOwnerReceived(p_data: String): Void {
        var json: Dynamic  = JsonParser.parse(p_data);

        var owned: String = Reflect.getProperty(json, "owned");
        if(owned == "0") {
            popupElement.getChildByName("info_popup_owner", true).model = "Claimable";
        } else {
            popupElement.getChildByName("info_popup_owner", true).model = "Owned";
        }
    }
}
