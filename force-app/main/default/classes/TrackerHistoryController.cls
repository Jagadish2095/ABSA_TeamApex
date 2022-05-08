/**
* Controller for Refresh Tracker History
* Calling RetreiveTracker service 
* @author  Himanshu Nimje (Mphatek)
* @created 2019-03-13
*/


public class TrackerHistoryController {
    
    /**
* Method that call Retrieve Tracker Service to get the Latest Tracker history  
*
* @param Opp Id -opportunity Id
* 
* @return String.
*/
    @AuraEnabled
    public static String refreshTrackerHistoryRecords(Id oppId) {
        
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        List<Asset> Asset =new AssetsSelector().selectAssetByAccId(account.Id);
        
        
        if(asset.size() >0){
            
            RetrieveTrackerStatus_Resp_IB_v1 RefreshTrackerResponse = RetrieveTrackerStatus_IH_v1.getRetrieveTrackerStatus('WILLS', 'WILLS', 'N', 'E', 'STD',Asset.get(0).Name);
            System.debug('RefreshTrackerResponse'+RefreshTrackerResponse);
            System.debug('JSON.serialize(RefreshTrackerResponse.awp035o.trackerRecord, true);' +JSON.serialize(RefreshTrackerResponse.awp035o.trackerRecord, true) );
            
            return JSON.serialize(RefreshTrackerResponse.awp035o.trackerRecord, true);
            
        }
        else 
        {
            return 'No Asset' ;
        }  
        
    }
}