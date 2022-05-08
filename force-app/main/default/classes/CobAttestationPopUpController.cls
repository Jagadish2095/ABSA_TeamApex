/**
 * @description       : Controller class for Attestation Popup
 * @author            : Saurabh
 * @group             :
 * @last modified on  : 06-09-2021
 * @last modified by  : Saurabh
 * Modifications Log
 * Ver   Date         Author    Modification
 * 1.0   06-09-2021   Saurabh   Initial Version
**/
public class CobAttestationPopUpController {


    /**
    * @description : Method to load credit opp record
    * @author Saurabh | 06-09-2021
    * @param oppId
    * @return Opportunity
    **/
    @AuraEnabled
    public static Opportunity loadOppRecord(string oppId){
        OpportunitiesSelector optSelector = new OpportunitiesSelector();
        Opportunity currentOpp = optSelector.selectByOppId(oppId);
        if(currentOpp != null){
            return currentOpp;
        }
        else{
            return null;
        }
    }


    /**
    * @description : Method to close the opportunity When banker Declines the Attestation
    * @author Saurabh | 06-09-2021
    * @param oppId
    * @return Opportunity
    **/
    @AuraEnabled
    public static Opportunity closeOppRecord(string oppId){
        OpportunitiesSelector optSelector = new OpportunitiesSelector();
        Opportunity currentOpp = optSelector.selectByOppId(oppId);
        try{
            currentOpp.StageName = 'Closed';
            update currentOpp;
            return currentOpp;
        }
        catch(Exception e){
            throw new AuraHandledException('Something Went Wrong while Saving the Opportunity');
        }

    }

}