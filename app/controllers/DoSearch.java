
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import models.Asset;
import models.Chapter;
import play.modules.search.Query;
import play.modules.search.Search;

/**
 *
 * @author pe
 */
public class DoSearch extends Application {

    public static void doSearch() {
        String lookfor = Application.params.get("lookfor");
        System.out.println("Searching for: " + lookfor);
        Query qChapter = Search.search("htmlAsText:" + lookfor, Chapter.class);
        List<Chapter> chapters = qChapter.fetch();
        System.out.println("Chapters found: " + chapters.size());
        Query qAsset = Search.search("htmlAsText:" + lookfor, Asset.class);
        List<Asset> assets = qAsset.fetch();
        System.out.println("Assets found: " + chapters.size());

        System.out.println("Total assets: " + assets.size());
        List<Asset> allAssets = Asset.findAll();
        for (Asset asset : assets) {
            System.out.println("Asset file match: " + asset.fileName);
        }

        ArrayList<Asset> renderAssets = new ArrayList<Asset>();
        for (Asset asset: assets) {
            if (asset.type.equals(Asset.introType) || asset.type.equals(Asset.variantType) || asset.type.equals(Asset.manusType) ||  asset.type.equals(Asset.rootType)) {
                try {
                    long _id = asset.getCorrespondingRootId();
                    renderAssets.add(asset);
                } catch (Exception _e) {
                    
                }
            }
        }

        int totalHits = renderAssets.size() + chapters.size();
        System.out.println("Total hits: " + renderAssets.size());
        render(renderAssets, chapters, lookfor, totalHits);
    }

    public static String createTeaser(String str, String lookfor) {
        return createTeaser(str, lookfor, 70);
    }

    // add caching if slow later
    public static String createTeaser(String str, String lookforOrig, int len) {
        String lookfor = lookforOrig.toLowerCase();
        int lookforStart = str.indexOf(lookfor) + 1;
        Pattern findWordsPattern = Pattern.compile("(\\s" + lookfor + "|^" + lookfor +")" +"[ ,;!.]", Pattern.CASE_INSENSITIVE);
        Matcher matcher = findWordsPattern.matcher(str);
        if (matcher.find()) {
           lookforStart = matcher.start();
        } else return "";
        int lookforEnd = lookforStart + lookfor.length();
        int start = lookforStart;
        int stop = lookforEnd;
        while (stop < str.length() && ((stop - lookforEnd) < len)) {
            stop++;
        }

        while (stop < str.length() && !str.substring(stop, stop + 1).equals(" ")) {
            stop++;
        }

        // del kun ved hele ord
        while (start > 0 && ((lookforStart - start) < len)) {
            start--;
        }

        while (start > 0 && !str.substring(start, start + 1).equals(" ")) {
            start--;
        }

        String s = replaceAll(str.substring(start, stop), "(\\s" + lookfor + "|^" + lookfor +")" +"[ ,;!.]", " <span class='lookedfor'> $1 </span> ");

        if (start != 0) {
            s = "..." + s;
        }
        if (stop != str.length()) {
            s += "...";
        }
        return s;
    }

    static private String replaceAll(String string, String regex, String replaceWith) {
        Pattern myPattern = Pattern.compile(regex, Pattern.CASE_INSENSITIVE);
        /*for space,new line, tab checks*/
        //Pattern myPattern = Pattern.compile(regex+"[ /n/t/r]", Pattern.CASE_INSENSITIVE);
        string = myPattern.matcher(string).replaceAll(replaceWith);
        return string;
    }
}
