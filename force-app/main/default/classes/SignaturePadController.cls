/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-11-08
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//Saurabh
//User Story :W-003805, W-003804
//Discription : Controller to manage the signature capture and send the data to siqv

public class SignaturePadController {
   
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 2021-11-08 
    * @param oppId 
    * @return Map<string, Id> 
    **/
    @AuraEnabled
    public static Map<string,Id> loadrelatedData(Id oppId){
        
        //Get AccountId from Opp
        Opportunity Opp = [Select AccountId,Entity_Type__c from Opportunity where id =: oppId];  
        Id accId = Opp.AccountId ; 
        Map<string,Id> relatedConNames = new  Map<string,Id>();
        List<Id> relatedConIdList = new List<Id>();
        List<AccountContactRelation> acr = [Select ContactId from AccountContactRelation where AccountId =:accId and IsDirect = False]; //get related contacts for Acc, Crieria needs to be given yet for filtering
        for(AccountContactRelation getCon:acr ){
            relatedConIdList.add(getCon.ContactId);
        }
      
        List<contact> relatedConObj = [Select Name from Contact where Id IN : relatedConIdList];
        for (Contact con : relatedConObj){
            relatedConNames.put(con.Name,con.Id);
        }
        
        // pulling the Main customer if Sole trader without a related parties - Signatories
        if(opp.Entity_Type__c == 'Sole Trader'){
        //if(opp.Entity_Type__c == 'Sole Trader' && relatedConNames.isEmpty()){
            Account primaryAccObj = [Select PersonContactId From Account Where Id = :accId];
            Contact primaryConObj = [Select Name from Contact where Id = : primaryAccObj.PersonContactId];
                relatedConNames.put(primaryConObj.Name,primaryConObj.Id);
                
           
        }
      
        return relatedConNames;
    }
    
    
  
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 2021-11-08 
    * @param signatureBody 
    * @param oppId 
    * @param conId 
    * @param conName 
    * @return string 
    **/
    @AuraEnabled
    public static string saveSignature(String signatureBody,Id oppId, Id conId,String conName ){
        
        
        Attachment att = new Attachment();
        att.ParentId = oppId; // Relating the attachment to Opp it is being submited for .
        att.Body = EncodingUtil.base64Decode(signatureBody);
        att.ContentType = 'image/png';
        att.Name = conName+'.png';  //Name will be as per the name of the submited person
        try{
            
            

            //Loading translator map from Integration Translation for translating the values
            
            Map<string,string> translationMap = new Map<string,string>();
            List<Integration_Translation__c>  integrationValueList =   [SELECT Id, OwnerId, IsDeleted, Name, Direction__c, External_Value__c, Internal_Value__c, System_Name__c, Value_Type__c FROM Integration_Translation__c where System_Name__c = 'CIF'];
            for(Integration_Translation__c ict : integrationValueList){
                translationMap.put(ict.Internal_Value__c,ict.External_Value__c);
            }
            //gather info from all objects to generate data 
            //move to selector once field mapping is finalised
            List<Address__c> conAddress = [SELECT Id, Address_Type__c, Billing_City__c, Billing_Country__c, Billing_State_Province__c, Billing_Street__c, Billing_Suburb__c, Billing_Zip_Postal_Code__c, Account__c,Contact__c, Shipping_City__c, Shipping_Country__c, Shipping_State_Province__c, Shipping_Street__c, 
                                           Shipping_Suburb__c, Shipping_Zip_Postal_Code__c, Address1__c, Address2__c, Address3__c, Address4__c, Address5__c FROM Address__c where contact__c =:conId]; 
            Contact con = [Select id, FirstName, LastName,ID_Number__c,HomePhone,Email,Gender__c, BirthDate,ID_Type__c,Date_Issued__c, CASA_Reference_Number__c  from Contact where id =:conId];
            Opportunity opp = [Select id, Site__r.Site_Code__c,(Select Policy_Number__c from OpportunityLineItems), Account.CASA_Reference_Number__c,Account.LastName, Account.FirstName,Account.Salutation, Account.AccountNumber from Opportunity where id =:oppId  ];
            string accnumber = '';
           
            for(OpportunityLineItem oli : opp.OpportunityLineItems){
             if(oli.Policy_Number__c != null) {
                accnumber= oli.Policy_Number__c;
             } 
            
               } 
            User user = [SELECT Id, Teller_Operator_Code__c FROM User where id =: UserInfo.getUserId()]; 
            
            
            //creating the request bean for sigv service
            //mapping is not given properly, hence we have lot of dirty hard code
            CIupdSigningInstructionsV5_Req_IB_v1 requestBean = new CIupdSigningInstructionsV5_Req_IB_v1();
            requestBean.CIupdSigningInstructionsV5 = new CIupdSigningInstructionsV5_Req_IB_v1.CIupdSigningInstructionsV5();
            requestBean.CIupdSigningInstructionsV5.nbsapdpi = new CIupdSigningInstructionsV5_Req_IB_v1.Nbsapdpi();
            requestBean.CIupdSigningInstructionsV5.nbsmsgi = new CIupdSigningInstructionsV5_Req_IB_v1.Nbsmsgi();
            requestBean.CIupdSigningInstructionsV5.cip202i = new CIupdSigningInstructionsV5_Req_IB_v1.Cip202i();
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable = new CIupdSigningInstructionsV5_Req_IB_v1.InputTable();
            
            requestBean.CIupdSigningInstructionsV5.nbsapdpi.channel = 'ESP';
            requestBean.CIupdSigningInstructionsV5.nbsapdpi.application = 'ESP';
            requestBean.CIupdSigningInstructionsV5.nbsapdpi.trace = 'N';
            
            requestBean.CIupdSigningInstructionsV5.nbsmsgi.msgLanguage = 'E';
            requestBean.CIupdSigningInstructionsV5.nbsmsgi.msgTarget = 'STD';
            
            requestBean.CIupdSigningInstructionsV5.cip202i.accountNumber = accnumber ; //'9051254302';
            requestBean.CIupdSigningInstructionsV5.cip202i.option = 'N';
            requestBean.CIupdSigningInstructionsV5.cip202i.siteCode = opp.Site__r.Site_Code__c ;               //'8198';
            requestBean.CIupdSigningInstructionsV5.cip202i.siteType = '0';
            requestBean.CIupdSigningInstructionsV5.cip202i.tellerNumber = '993';//user.Teller_Operator_Code__c; //'993';
            requestBean.CIupdSigningInstructionsV5.cip202i.agencyCode = '0';
            requestBean.CIupdSigningInstructionsV5.cip202i.supervisorOverride = '111';
            requestBean.CIupdSigningInstructionsV5.cip202i.nbrRecord = '1';
            requestBean.CIupdSigningInstructionsV5.cip202i.chgSpecialCondition = '';
            requestBean.CIupdSigningInstructionsV5.cip202i.nbrSignOperAccNew = '0001';
            requestBean.CIupdSigningInstructionsV5.cip202i.specialConditionNew = '';
            
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.changeOption = 'N';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.csaRefNbr = con.CASA_Reference_Number__c;  //'888';//;
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.titleNew = '01';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.initialsNew = con.FirstName.substring(0,1) ; //'s'
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.surnameNew = con.LastName; //'SAM';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.nameNew =  con.FirstName;   //'FANIE';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.idTypeNew = translationMap.get(con.ID_Type__c);//'03';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.idNbrNew =  con.ID_Number__c;    //'HHJJJ080';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.dateIssuedNew = '19990919'; //(string.valueof(con.Date_Issued__c)).replace('-','');//'19990919';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.compulsorySignNew = 'N';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.idTypeOld = '0';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.idNbrOld = '';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.physicalAdd1 = '100 WEST STREET';  //conAddress[0].Address1__c;
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.physicalAdd2 =   '';  //conAddress[0].Address2__c;
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.physicalSuburb = 'JHB'; //conAddress[0].Address3__c;//
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.physicalTown = 'JHB';  //conAddress[0].Address4__c;//
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.physicalPostal = '2001';  //conAddress[0].Address5__c ;
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.clientNationality = 'SOU01'; //Not mapping as per the instruction from SA and BA
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.countryOfOrigin = 'SO003';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.countryResAddress = 'SO003';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.birthOpCountry = 'SO003';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.homeTelCode =   '011';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.homeTelephone = con.HomePhone;   //'5079259';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.emailAddress = con.Email;
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.gender = translationMap.get(con.Gender__c);//'1';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.birthDate =  (string.valueof(con.Birthdate)).replace('-',''); //'19320101';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.occupationStatus = '01';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.occupationCode = '02';
            requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.designation = '02';
            string status;  //for returing the submittion status to controller
            
            // Sending request Bean to sigv
            Map<CIupdSigningInstructionsV5_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIupdSigningInstructionsV5_IH_v1.CIupdSigningInstructionsV5(requestBean);
              
            //Insert the logs of service
            List<Sys_Log_Integration__c>logList = new List<Sys_Log_Integration__c>();
             for(List<Sys_Log_Integration__c> currentLogList : responseMap.values()) {
              
               logList.addAll(currentLogList);
                 
                }
                if (!logList.isEmpty()){
                    Insert logList ; }  
            
            
            CIupdSigningInstructionsV5_Resp_IB_v1 responseBean = (new List<CIupdSigningInstructionsV5_Resp_IB_v1>(responseMap.keySet()))[0];
            
            if(responseBean.statusCode == 200) {
                status = 'Signature Processed Successfully for '+conName+'';
                insert att; // insert attachment once request is successfull
            }
            else{
                status = 'Signature could not be Processed for '+conName+''; 
            }
            return status;
            

        }
        
        catch (QueryException e) {
            // "Convert" the exception into an AuraHandledException
            throw new AuraHandledException('Something went wrong: '+ e.getMessage()); 
        }        
    }
    
    
}