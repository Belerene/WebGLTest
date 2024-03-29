package com.genome2d.components.renderable.tilemap;

import com.dinox.model.tile.Tile;
import com.genome2d.tilemap.GTile;
import com.genome2d.input.GMouseInput;
import com.genome2d.context.GBlendMode;
import com.genome2d.geom.GRectangle;
import com.genome2d.context.GCamera;
import com.genome2d.debug.GDebug;

class GTileMap extends GComponent implements IGRenderable
{
    public var blendMode:GBlendMode;

    private var g2d_width:Int;
    private var g2d_height:Int;
    private var g2d_tiles:Array<Tile>;
    public function getTiles():Array<Tile> {
        return g2d_tiles;
    }

    private var mustRenderTiles:Array<GTile>;

    private var g2d_tileWidth:Int = 0;
    private var g2d_tileHeight:Int = 0;
    private var g2d_iso:Bool = false;

    public var horizontalMargin:Float = 0;
    public var verticalMargin:Float = 0;

    override public function init():Void {
        blendMode = GBlendMode.NORMAL;
    }

    public function setTiles(p_mapWidth:Int, p_mapHeight:Int, p_tileWidth:Int, p_tileHeight:Int, p_tiles:Array<Tile> = null,  p_iso:Bool = false):Void {
        if (p_tiles != null && p_mapWidth*p_mapHeight != p_tiles.length) GDebug.error("Incorrect number of tiles provided for that map size.");

        g2d_width = p_mapWidth;
        g2d_height = p_mapHeight;
        g2d_tileWidth = p_tileWidth;
        g2d_tileHeight = p_tileHeight;
        if (p_tiles != null) {
            g2d_tiles = p_tiles;
        } else {
            g2d_tiles = new Array<Tile>();
            for (i in 0...g2d_width*g2d_height) g2d_tiles.push(null);
        }
        g2d_iso = p_iso;
    }

    public function getTile(p_tileIndex:Int):Tile {
        if (p_tileIndex < 0 || p_tileIndex >= g2d_tiles.length) GDebug.error("Tile index out of bounds.");
        return g2d_tiles[p_tileIndex];
    }

    public function setTile(p_tileIndex:Int, p_tile:Tile):Void {
        if (p_tileIndex<0 || p_tileIndex>= g2d_tiles.length) GDebug.error("Tile index out of bounds.");
        if (p_tile != null && (p_tile.getGTile().mapX!=-1 || p_tile.getGTile().mapY!=-1) && (p_tile.getGTile().mapX+p_tile.getGTile().mapY*g2d_width != p_tileIndex)) GDebug.error("Tile map position doesn't match its index. MapX: " + p_tile.getGTile().mapX + " mapY: " +p_tile.getGTile().mapY + " p_index: " + p_tileIndex + " calculated Index: " + Std.string(p_tile.getGTile().mapX+p_tile.getGTile().mapY*g2d_width));

        if (p_tile != null) {
            if (g2d_tiles[p_tileIndex] != null) {
                removeTile(p_tileIndex);
            }
            g2d_tiles[p_tileIndex] = p_tile;
        } else {
            removeTile(p_tileIndex);
        }
    }

    public function removeTile(p_tileIndex:Int):Void {
        if (p_tileIndex<0 || p_tileIndex>= g2d_tiles.length) GDebug.error("Tile index out of bounds.");
        var tile:Tile = g2d_tiles[p_tileIndex];
        if (tile != null) {
            if (tile.getGTile().mapX != -1 && tile.getGTile().mapY != -1) {
                if (g2d_tiles[p_tileIndex] == tile) g2d_tiles[p_tileIndex] = null;
            } else {
                g2d_tiles[p_tileIndex] = null;
            }
        }
    }

    public function render(p_camera:GCamera, p_useMatrix:Bool):Void {
        if (g2d_tiles == null) return;

        var mapHalfWidth:Float = g2d_tileWidth * g2d_width * .5;
        var mapHalfHeight:Float = g2d_tileHeight * g2d_height * (g2d_iso ? .25 : .5);

        // Position of top left visible tile from 0,0
        var viewRect:GRectangle = node.core.getContext().getStageViewRect();
        var cameraWidth:Float = viewRect.width*p_camera.normalizedViewWidth / p_camera.scaleX;
        var cameraHeight:Float = viewRect.height*p_camera.normalizedViewHeight / p_camera.scaleY;
        var startX:Float =	p_camera.x - g2d_node.g2d_worldX - cameraWidth *.5 - horizontalMargin;
        var startY:Float = p_camera.y - g2d_node.g2d_worldY - cameraHeight *.5 - verticalMargin;
        // Position of top left tile from map center
        var firstX:Float = -mapHalfWidth + (g2d_iso ? g2d_tileWidth/2 : 0);
        var firstY:Float = -mapHalfHeight + (g2d_iso ? g2d_tileHeight/2 : 0);

        // Index of top left visible tile
        var indexX:Int = Std.int((startX - firstX) / g2d_tileWidth);
        if (indexX<0) indexX = 0;
        var indexY:Int = Std.int((startY - firstY) / (g2d_iso ? g2d_tileHeight/2 : g2d_tileHeight));
        if (indexY<0) indexY = 0;

        // Position of bottom right tile from map center
        var endX:Float = p_camera.x - g2d_node.g2d_worldX + cameraWidth * .5 - (g2d_iso ? g2d_tileWidth/2 : g2d_tileWidth) + horizontalMargin;
        var endY:Float = p_camera.y - g2d_node.g2d_worldY + cameraHeight * .5 - (g2d_iso ? 0 : g2d_tileHeight) + verticalMargin;

        var indexWidth:Int = Std.int((endX - firstX) / g2d_tileWidth - indexX+2);
        if (indexWidth>g2d_width-indexX) indexWidth = g2d_width - indexX;

        var indexHeight:Int = Std.int((endY - firstY) / (g2d_iso ? g2d_tileHeight / 2 : g2d_tileHeight) - indexY + 2);
        if (indexHeight > g2d_height - indexY) indexHeight = g2d_height - indexY;

        // Added fix for large camera position numbers when both width/height are negative and will result in positive number
        var tileCount:Int = (indexWidth<0 || indexWidth<0) ? 0 : indexWidth*indexHeight;
        for (i in 0...tileCount) {
            var row:Int = Std.int(i / indexWidth);
            var x:Float = g2d_node.g2d_worldX + (indexX + (i % indexWidth)) * g2d_tileWidth - mapHalfWidth + (g2d_iso && (indexY+row)%2 == 1 ? g2d_tileWidth : g2d_tileWidth/2);
            var y:Float = g2d_node.g2d_worldY + (indexY + row) * (g2d_iso ? g2d_tileHeight/2 : g2d_tileHeight) - mapHalfHeight + g2d_tileHeight/2;

            var index:Int = indexY * g2d_width + indexX + Std.int(i / indexWidth) * g2d_width + i % indexWidth;
            var tile:Tile = g2d_tiles[index];
            // TODO: All transforms
            if (tile != null && tile.getGTile().texture != null) {
                var frameId:Int = node.core.getCurrentFrameId();
                var time:Float = node.core.getRunTime();
                if (tile.getGTile().sizeX != 1 || tile.getGTile().sizeY != 1) {
                    if (tile.getGTile().lastFrameRendered != frameId) {
                        tile.render(node.core.getContext(), x, y, frameId, time, blendMode);
                    }
                } else {
                    tile.render(node.core.getContext(), x, y, frameId, time, blendMode);
                }
            }
        }
    }

    /**
    * return Map of "x" and "y" coordinates on GTileMap from world coordinates
     */
    public function getMapCoordinatesAt(p_x: Float, p_y: Float, p_camera:  GCamera = null): Map<String, Float> {
        if (p_camera == null) p_camera = node.core.getContext().getDefaultCamera();

        var viewRect:GRectangle = node.core.getContext().getStageViewRect();
        var cameraX:Float = viewRect.width*p_camera.normalizedViewX;
        var cameraY:Float = viewRect.height*p_camera.normalizedViewY;
        var cameraWidth:Float = viewRect.width*p_camera.normalizedViewWidth;
        var cameraHeight:Float = viewRect.height*p_camera.normalizedViewHeight;
        p_x -= cameraX + cameraWidth*.5;
        p_y -= cameraY + cameraHeight*.5;
        var tx:Float = (p_camera.x - g2d_node.g2d_worldX + p_x);
        var ty:Float = (p_camera.y - g2d_node.g2d_worldY + p_y);

        var res: Map<String, Float> = new Map<String, Float>();
        res.set("x", p_x);
        res.set("y", p_y);
        return res;
    }

    /**
    * return Map of screen coordinates from "x" and "y" coordinates on GTileMap
    **/
    public function getScreenCoordsFromMapCoords(p_x: Float, p_y: Float, p_camera:  GCamera = null): Map<String, Float> {
        if (p_camera == null) p_camera = node.core.getContext().getDefaultCamera();

        var nodeOffsetX: Float = (g2d_width / 2) * g2d_tileWidth;
        var nodeOffsetY: Float = (g2d_height / 2) * g2d_tileHeight;

        var viewRect:GRectangle = node.core.getContext().getStageViewRect();
        var cameraWidth:Float = (viewRect.width*p_camera.normalizedViewWidth) / p_camera.scaleX;
        var cameraHeight:Float = (viewRect.height*p_camera.normalizedViewHeight) / p_camera.scaleY;

        var adjustedX: Float = (-node.x + nodeOffsetX - cameraWidth*0.5) * p_camera.scaleX;
        var adjustedY: Float = (-node.y + nodeOffsetY - cameraHeight*0.5) * p_camera.scaleY;

        var tileWorldX: Float = (p_x * g2d_tileWidth) * p_camera.scaleX;
        var tileWorldY: Float = (p_y * g2d_tileHeight) * p_camera.scaleY;

        var res: Map<String, Float> = new Map<String, Float>();
        res.set("x", tileWorldX - adjustedX);
        res.set("y", tileWorldY - adjustedY);
        return res;
    }

    public function getTileAt(p_x:Float, p_y:Float, p_camera:GCamera = null):Tile {
        var coords: Map<String, Float> = getMapCoordinatesAt(p_x, p_y, p_camera);
        /////////////////
        var viewRect:GRectangle = node.core.getContext().getStageViewRect();
        var cameraX:Float = viewRect.width*p_camera.normalizedViewX;
        var cameraY:Float = viewRect.height*p_camera.normalizedViewY;
        var cameraWidth:Float = viewRect.width*p_camera.normalizedViewWidth;
        var cameraHeight:Float = viewRect.height*p_camera.normalizedViewHeight;
        p_x -= cameraX + cameraWidth*.5;
        p_y -= cameraY + cameraHeight*.5;
        /////////////////
//        var x: Float = coords.get("x");
//        var y: Float = coords.get("y");


        var mapHalfWidth:Float = (g2d_tileWidth) * g2d_width * .5;
        var mapHalfHeight:Float = (g2d_tileHeight) * g2d_height * (g2d_iso ? .25 : .5);

        var firstX:Float = -mapHalfWidth + (g2d_iso ? (g2d_tileWidth) / 2 : 0);
        var firstY:Float = -mapHalfHeight + (g2d_iso ? (g2d_tileHeight) / 2 : 0);
////////////////////////
        var tx:Float = (p_camera.x - g2d_node.g2d_worldX + p_x);
        var ty:Float = (p_camera.y - g2d_node.g2d_worldY + p_y);
////////////////////////
//        GDebug.info(" X: " + x + " Y: " + y + " FIRST X: " + firstX + " FIRST Y: " + firstY);
        var indexX:Int = Math.floor((tx - firstX) / (g2d_tileWidth ));
//        var indexX:Int = Math.floor((tx - firstX) / (g2d_tileWidth ));
        var indexY:Int = Math.floor((ty - firstY) / (g2d_tileHeight ));
//        var indexY:Int = Math.floor((ty - firstY) / (g2d_tileHeight ));

        if (indexX<0 || indexX>=g2d_width || indexY<0 || indexY>=g2d_height) return null;
        return g2d_tiles[indexY*g2d_width+indexX];
    }

    public function getBounds(p_bounds:GRectangle = null):GRectangle {
        return null;
    }

    public function hitTest(p_x:Float, p_y:Float):Bool {
        p_x = p_x / (g2d_width * g2d_tileWidth) + .5;
        p_y = p_y / (g2d_height * g2d_tileHeight) + .5;

        return (p_x >= 0 && p_x <= 1 && p_y >= 0 && p_y <= 1);
    }

    @:dox(hide)
    public function captureMouseInput(p_input:GMouseInput):Void {
        p_input.captured = p_input.captured || hitTest(p_input.localX, p_input.localY);
    }
}