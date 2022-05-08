/**
* @author  Peter Guest - CloudSmiths
* @since   2018-09-27
*/
@IsTest
private class LiveAgentHelperTest {
    
    @IsTest
    static void testAssets() {

        Test.startTest();

        //Fetch a random live agent prechat VF page name.
        String pageName = [SELECT Name FROM ApexPage WHERE Name LIKE 'LiveAgentPreChatForm%' LIMIT 1].Name;

        //Set page.
        PageReference pageRef = new PageReference('/apex/'+pageName);
        Test.setCurrentPage(pageRef);

        //Call controller.
        LiveAgentHelper helper = new LiveAgentHelper();
        
        //Asset Methods - Stylesheet.
        List<String> styles = new List<String>(helper.getStylesheets());
        System.assert(!styles.isEmpty(), 'No LiveAgent Settings (Custom Metadata Type) records of type "Stylesheet" are defined in the organisation.');

        //Asset Methods - Javascript - There may not always be a javascript file, so cannot assert.
        helper.getScripts();

        Test.stopTest();
    } 
}