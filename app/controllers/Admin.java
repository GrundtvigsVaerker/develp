/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controllers;

import java.util.List;
import models.Asset;
import models.Chapter;
import models.TextReference;
import play.mvc.Controller;

/**
 *
 * @author pe
 */
public class Admin extends Application {

    public static void uploadXmlFile() {
        render();
    }

    public static void listXmlFiles() {
        List<Asset> assets = Asset.find("SELECT a FROM Asset a ORDER BY a.name").fetch();
        System.out.println("Assets: " + assets.size());
        render(assets);
    }

    public static void removeXmlFile(long fileId) {
        Asset asset = Asset.findById(fileId);
        Chapter.delete("asset = ?", asset);
        asset.delete();
        render();
    }

    public static void removeAllData() {
        Chapter.deleteAll();
        TextReference.deleteAll();
        Asset.deleteAll();
        Controller.renderHtml("All data removed");
    }

}
