/*
Lightning Component Controller For Customer Portfolio Controller Class
*
* @author  Muvhuso Nekhubvi : Absa
* @version v1.0
* @since   2020-01-22
*
*/
public class CustomerPortfolioController {

    @AuraEnabled
    public static String getControlOfficers(String accountId) {

        List<DisplayControlOfficers> displayControlOfficers = new List<DisplayControlOfficers>();

        String errorMessage = '';

        //call to webservice by account's CIF Number
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{accountId}, 1);
        if(accounts[0].CIF__c != null &&  accounts.size() > 0){

        	Map<CMSGetBankerInfo_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CMSGetBankerInfo_IH_v1.getBankerDeatils('SALESFORCE', accounts[0].CIF__c);
        	CMSGetBankerInfo_Resp_IB_v1 response = (new List<CMSGetBankerInfo_Resp_IB_v1>(responseMap.keySet()))[0];
			 //insert logs
        	if(responseMap.get(response) != null){
            	insert responseMap.get(response);
        	}
        	if(response != null){
        		if(response.statusCode == 200){
                    if(response.Body != null){
                        if(response.Body.GBlistCmsContOffPerClntV2Response != null){

                            CMSGetBankerInfo_Resp_IB_v1.GBlistCmsContOffPerClntV2Response wrapper = response.Body.GBlistCmsContOffPerClntV2Response;

                	        if(wrapper.gsp019o != null){
                    	          if(wrapper.gsp019o.contOffDet != null || wrapper.gsp019o.contOffDet.size() > 0){
                        	            for(Integer i = 0 ; i < wrapper.gsp019o.contOffDet.size(); i++){
                            	             DisplayControlOfficers controlOfficer = new DisplayControlOfficers(wrapper.gsp019o.contOffDet[i].contOffType, wrapper.gsp019o.contOffDet[i].coEmployeeNum);
                            	             displayControlOfficers.add(controlOfficer);

                        }
                    }

                }
               return JSON.serialize(displayControlOfficers);
                        }
                    }


        	  }
        	}
        }
        return null;
    }
     public class DisplayControlOfficers{

        @auraEnabled public String name;
        @auraEnabled public String role;
        @auraEnabled public String Id;
        @auraEnabled public String email;
        @auraEnabled public String mobileNumber;
        @auraEnabled public String branchSite;
        @auraEnabled public String tellNumber;


         public DisplayControlOfficers(String contOffType , String coEmployeeNum){
             role = getOfficerRole(contOffType);

             if (coEmployeeNum != null && coEmployeeNum != '') {
                    system.debug('cmsEmpNo in user'+coEmployeeNum);
                    List<User> userList = new UsersSelector().userwithEmployeeNumber(coEmployeeNum);
                    system.debug('usr-----debug  test'+userList );

                    if(userList !=null && !userList.isEmpty() && !String.isEmpty(userList[0].Id)){
                        Id = string.valueOf(userList[0].Id);
                        name = string.valueOf(userList[0].name);
                        mobileNumber = string.valueOf(userList[0].MobilePhone);
                        email = string.valueOf(userList[0].Email);
                        branchSite = getSiteName(userList[0].sitecode__C);
                        tellNumber = string.valueOf(userList[0].Phone);
                    } else{
                        Id = '';
                        name = '';
                        mobileNumber = '';
                        email = '';
                        branchSite = '';
                        tellNumber = '';
                    }


                }
         }

         public String getOfficerRole(String role){
             if(role == 'BB'){
                 return 'Business Banker';
             }else if(role == 'RM'){
                 return 'Relationship Manager';
             }else if(role == 'BM'){
                 return 'Bank Manager';
             }else if(role == 'CM'){
                 return 'Credit Manager';
             }else if(role == 'CA'){
                 return 'Credit Analyst';
             }else if(role == 'TB'){
                 return 'Transactional Banker';
             }else if(role == 'PB'){
                 return 'Private Banker';
             }else if(role == 'FP'){
                 return 'Financial Planner';
             }else if(role == 'WP'){
                 return 'Wealth Planner';
             }else if(role == 'WSO'){
                 return 'Wealth Support Officer';
             }else if(role == 'AS'){
                 return 'AGRI Specialist';
             }else if(role == 'SBBM'){
                 return 'Small Business';
             }else if(role == 'SBRM'){
                 return 'Small Buss Relationship Manager';
             }
             return '';
         }
     }

    public static String getSiteName(String siteCode){
        if(String.isNotEmpty(siteCode)){
        	List<Site__c> site = new SitesSelector().selectBySiteCode(siteCode);
            if(site != null && site.size() > 0){
            	if(String.isNotEmpty(site[0].Name)){
                	return site[0].Name;
            	}
             }
        }
        return null;
    }

    @AuraEnabled
    public static String sendEmail(String emailAddress, Id caseRecordId , String name , String tellNumber , String cellNumber , String bankerEmail , String branchSite){
        System.debug('-----name----'+name);
        System.debug('-----tellNumber----'+tellNumber);
        System.debug('-----cellNumber----'+cellNumber);
        System.debug('-----bankerEmail----'+bankerEmail);
        System.debug('-----branchSite----'+branchSite);

        String returnString = 'success';

         try{

                Case currentCase = [SELECT Id, CaseNumber, AccountId, Account.Name FROM Case WHERE Id =: caseRecordId];

                String contactId = [Select PersonContactId From Account Where Id = :currentCase.AccountId].PersonContactId;

                if( String.isNotBlank(contactId) ){

                    Contact con = [Select Email From Contact Where Id =:contactId];

                    if(String.isBlank(con.email)){

                        con.email = emailAddress;

                        try{
                            update con;
                        }catch(DMLException ex){
                            throw ex;
                        }
                    }

                }else{

                    List<Contact> contList = [Select Id, Email From Contact Where Email = :emailAddress and AccountId = :currentCase.AccountId];

                    if(contList.size() > 0){

                        if(String.isBlank( contList[0].Email )){

                            contList[0].Email = emailAddress;

                            try{
                                update contList[0];
                            }catch(DmlException ex){
                                throw ex;
                            }
                        }

                        contactId = contList[0].Id;

                    }else{

                        String[] contNames = emailAddress.split('@');

                        Contact newCon = new Contact();
                        newCon.Email = emailAddress;
                        newCon.LastName = contNames[0];
                        newCon.AccountId = currentCase.AccountId;

                        try{

                            insert newCon;
                            contactId = newCon.Id;

                        }catch(DmlException ex){

                            throw ex;
                        }
                    }

                }

                List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseRecordId, contactId, emailAddress,'Relationship_Banker_Details');
                Messaging.SingleEmailMessage email = constructEmail.get(0);

                String htmlBody = email.getHTMLBody();
                htmlBody = htmlBody.replace('[name]', name).replace('[tellphone]', tellNumber).replace('[cellphone]', cellNumber).replace('[email]', bankerEmail).replace('[branchSite]', branchSite);
                email.setHtmlBody(htmlBody);

                sendTravelNoticeEmail(email, emailAddress,htmlBody);

            }catch(exception ex){
                system.debug(ex);
                system.debug(ex.getMessage());
                returnString = '' + ex.getMessage();
                throw ex;
            }



        try{

            if(caseRecordId!=null){
                Case caseObj = new Case(Id=caseRecordId);
                caseObj.Email__c = emailAddress;
                caseObj.Status = 'Closed';
                Update caseObj;
            }

        }catch(DmlException ex){
            throw ex;
        }

        return returnString;

    }

    private static void sendTravelNoticeEmail(Messaging.SingleEmailMessage constructEmail, String emailAddress, string emailBody){


        System.debug('RN## To Addresses : ' + constructEmail.getToAddresses());

        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { constructEmail });
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
    }
}