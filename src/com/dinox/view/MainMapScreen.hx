package com.dinox.view;
import com.genome2d.debug.GDebug;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.ui.element.GUIElement;
import com.dinox.model.Tile;
import com.genome2d.macros.MGDebug;
import com.genome2d.textures.GTextureManager;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.input.GMouseInput;
import com.genome2d.node.GNode;
class MainMapScreen {
    private static var TILE_COUNT: Int = 16; // real tile count is TILE_COUNT x TILE_COUNT

    private var tiles: Array<Array<Tile>>;
    private var ui: UIElement;
    private var map: MapElement;
    private var  uiContainer: GUI;
    private var  mapContainer: GUI;

    public function new(p_uiGui: GUI, p_mapGui: GUI) {
        uiContainer = p_uiGui;
        mapContainer = p_mapGui;
        setupUI();
        setupMap();
    }

    private function setupUI(): Void {
        ui = new UIElement();
        uiContainer.root.addChild(ui.getGuiElement());
    }

    private function setupMap(): Void {
        map = new MapElement();
        mapContainer.root.addChild(map.getGuiElement());
        setupTiles();
    }

    private function setupTiles(): Void {
        tiles = new Array<Array<Tile>>();
        var tileRow: Array<Tile>;
        var tile: Tile;
        var xOffset: Float = (TILE_COUNT / 2) * TileRenderer.BASE_TILE_SIZE;
        var yOffset: Float = xOffset;
        GDebug.info("x: " + Std.string(xOffset), "y: " + Std.string(yOffset));
        for(i in 0...TILE_COUNT) {
            tileRow = new Array<Tile>();
            for(j in 0...TILE_COUNT) {
                tile = new Tile(i * TileRenderer.BASE_TILE_SIZE - xOffset, j * TileRenderer.BASE_TILE_SIZE - yOffset, i, j);
                tileRow.push(tile);
                map.getGuiElement().addChild(tile.getTileElement());
            }
            tiles.push(tileRow);
        }
    }

    public function addMouseWheelListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseWheel.add(p_handler);
            }
        }
    }

    public function addMouseMoveListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseMove.add(p_handler);
            }
        }
    }

    public function addMouseOverListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseOver.add(p_handler);
            }
        }
    }

    public function addMouseOutListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseOut.add(p_handler);
            }
        }
    }

    public function addMouseDownListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseDown.add(p_handler);
            }
        }
    }

    public function addMouseUpListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseUp.add(p_handler);
            }
        }
    }

    public function addMouseClickListener(p_handler: GMouseInput->Void): Void {
        for(tileRow in tiles) {
            for(tile in tileRow) {
                tile.getTileElement().onMouseClick.add(p_handler);
            }
        }
    }

    public function zoomChanged(p_scale: Float): Void {
        var tileRow: Array<Tile>;
        for(i in 0...tiles.length) {
            tileRow = tiles[i];
            for(j in 0...tileRow.length) {
                tileRow[j].zoomChanged(p_scale);
            }
        }
    }
}
