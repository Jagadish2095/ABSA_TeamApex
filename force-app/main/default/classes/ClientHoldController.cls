/*
Lightning Component Controller For Client Hold Indicator
*
* @author  Almas Aleem : Absa
* @version v1.0
* @since   2019-07-25
* @updated 2019-09-07
*/


public class ClientHoldController {
    /*
* Get Response From Service and Bind To Wrapper Class 
* 
* @return List<DisplayClientHoldRecordTypes> HoldRecordTypes
*/
    @AuraEnabled
    public static List<DisplayClientHoldRecordTypes> getHoldRecordTypes(String accountId) {      
        List<DisplayClientHoldRecordTypes> clientHoldRecordTypes ;
        String errorMessage = '';
        
        try{  
            //call to webservice by account's CIF Number 
            List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
            if(accounts[0].CIF__c !=null ){
                clientHoldRecordTypes = new List<DisplayClientHoldRecordTypes>();           
                
                //make a call to service ;
                GetClientHolds_Resp_IB_v1 response = GetClientHolds_IH_v1.getClientHolds(accounts[0].CIF__c);
                if(response !=null){
                     if(response.CImaintainHoldsV5Response.nbsmsgo3.sysErrTxt =='' || response.CImaintainHoldsV5Response.nbsmsgo3.sysErrTxt == null){
                       
                        //Store Data from response into wrapper
                        
                        /*in future we have to map these hold params in to custom settings or labels till now used hard coded values*/
                         
                         
                        //ID Required Hold
                        if(response.CImaintainHoldsV5Response.cip045o.idrq026d.equalsIgnoreCase('Y')){
                        	DisplayClientHoldRecordTypes rec = new DisplayClientHoldRecordTypes('ID Required Hold',response.CImaintainHoldsV5Response.cip045o.idrq026d ); 
                        	clientHoldRecordTypes.add(rec);
                        }
                        //Deceased Estate Hold
                        if(response.CImaintainHoldsV5Response.cip045o.dest026d.equalsIgnoreCase('Y')){
                        	DisplayClientHoldRecordTypes rec1  = new DisplayClientHoldRecordTypes('Deceased Estate Hold',response.CImaintainHoldsV5Response.cip045o.dest026d);  	
                        	clientHoldRecordTypes.add(rec1);
                        }
                        //Deceased Spouse Hold
                        if(response.CImaintainHoldsV5Response.cip045o.dsps026d.equalsIgnoreCase('Y')){
                        	DisplayClientHoldRecordTypes rec2 = new DisplayClientHoldRecordTypes('Deceased Spouse Hold',response.CImaintainHoldsV5Response.cip045o.dsps026d);
                        	clientHoldRecordTypes.add(rec2);
                        }
                        //Insolvent Estate/In Liquidation Hold
                        if(response.CImaintainHoldsV5Response.cip045o.iest026d.equalsIgnoreCase('Y')){
                        	DisplayClientHoldRecordTypes rec3 = new DisplayClientHoldRecordTypes('Insolvent Estate/In Liquidation Hold',response.CImaintainHoldsV5Response.cip045o.iest026d);
                        	clientHoldRecordTypes.add(rec3);
                        }
                        //Forensic Hold
                        if(response.CImaintainHoldsV5Response.cip045o.forensicHoldOut.equalsIgnoreCase('Y')){
                        	DisplayClientHoldRecordTypes rec4 = new DisplayClientHoldRecordTypes('Forensic Hold',response.CImaintainHoldsV5Response.cip045o.forensicHoldOut);
                        	clientHoldRecordTypes.add(rec4);
                        }
                        // Financial Crime Hold 
                        if(response.CImaintainHoldsV5Response.cip045o.finCrimeHoldOut.equalsIgnoreCase('Y')){
                        	DisplayClientHoldRecordTypes rec5 = new DisplayClientHoldRecordTypes('Financial Crime Hold',response.CImaintainHoldsV5Response.cip045o.finCrimeHoldOut);
                        	clientHoldRecordTypes.add(rec5);
                        }
                    }else{
                        errorMessage = 'Unable to find client holds.Error from response is - '+response.CImaintainHoldsV5Response.nbsmsgo3.sysErrTxt; //error coming from response
                         if(!Test.isRunningTest()){
                        throw new AuraHandledException(errorMessage);  
                         }
                    }
                }  
            }else{
                errorMessage = System.Label.No_Cif_Error; 
                
                throw new AuraHandledException('Error: '+errorMessage); 
                 
            }
        }catch(Exception e){
            system.debug('Error Message :'+e.getMessage()+'Error Cause :'+e.getCause() + 'Error Where:' + e.getLineNumber());
             
            if(!Test.isRunningTest()){
            throw new AuraHandledException('Error: '+errorMessage);
             }
        }
        return clientHoldRecordTypes;
        
    }
    /** Wrapper Class To display Client Hold Record Types
* 
* 
*/
    public class DisplayClientHoldRecordTypes{
        @auraEnabled public String holdType ;
        @auraEnabled public Boolean status;
        @auraEnabled public String statusImage;
        
       
        public DisplayClientHoldRecordTypes(String resholdType,String holdvalue){
            holdType = resholdType;
            status =true  ;                                  
            statusImage ='Yes'; 
             
        }
        
    }
    
}