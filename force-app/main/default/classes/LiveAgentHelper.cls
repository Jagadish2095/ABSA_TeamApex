/**
* @author  Peter Guest - CloudSmiths
* @since   2018-09-27
*/
public class LiveAgentHelper {
    
    private List<Live_Agent_Setting__mdt> liveAgentSettings;
    private Map<String, List<String>> assets = new Map<String, List<String>>();

    /*
    * Constructor.
    */
    public LiveAgentHelper() {

        //Get the name of requested page.
        String pageName = ApexPages.currentPage().getUrl().substringAfter('/apex/').substringBefore('?');

        //Fetch metadata records.
        liveAgentSettings = new List<Live_Agent_Setting__mdt>([
            SELECT 
                Id, 
                Visualforce_Page__c, 
                Asset_URL__c, 
                Asset_Type__c 
            FROM Live_Agent_Setting__mdt
            WHERE
                Visualforce_Page__c = :pageName 
                OR Visualforce_Page__c = 'All'
        ]);

        //Build map of asset types to list of asset URL's.
        if(!liveAgentSettings.isEmpty()) {

            for(Live_Agent_Setting__mdt setting : liveAgentSettings) {

                if(assets.containsKey(setting.Asset_Type__c)) {
                    List<String> existingAssets = assets.get(setting.Asset_Type__c);
                    existingAssets.add(setting.Asset_URL__c);
                    assets.put(setting.Asset_Type__c, existingAssets);
                } 
                else {
                    assets.put(setting.Asset_Type__c, new List<String> { setting.Asset_URL__c } );
                }
            }
        }
    }

    /*
    * Returns a list of stylesheet names.
    * @return List<String>
    */
    public List<String> getStylesheets() {
        if(assets.containsKey('Stylesheet')) {
            return assets.get('Stylesheet');
        } 
        return null;
    }

    /*
    * Returns a list of javascript names.  
    * @return List<String>
    */
    public List<String> getScripts() {
        if(assets.containsKey('Javascript')) {
            return assets.get('Javascript');
        }
        return null; 
    }
}