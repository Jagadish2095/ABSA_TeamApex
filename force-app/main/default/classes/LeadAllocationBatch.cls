/**
* @description This class gets all the records from the Lead_Allocation_Staging__c
* object. It then does the following
* 1 -
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2020-05-08
*/

global class LeadAllocationBatch implements Database.Batchable<Lead_Allocation_Staging__c>{

    /**
    * @description Batch Start
    * @param BC
    * @return Iterable
    **/
    global Iterable<Lead_Allocation_Staging__c> start(Database.BatchableContext BC) {

        List<Lead_Allocation_Staging__c> stagingLeads = new LeadAllocationStagingSelector().selectByProcessStatus('New');

        return stagingLeads;

    }

    /**
    * @description Batch Execute method
    * @param BC
    * @param scope
    **/
    global void execute(Database.BatchableContext BC, List<Lead_Allocation_Staging__c> scope){

        //Get RecordTypeId for Retail Sales Lead
        Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Retail_Sales_Lead').getRecordTypeId();

        //Add all the values to sets for queries later
        Set<String> roleNames = new Set<String>();
        Set<String> groupNames = new Set<String>();
        Set<String> campaignIds = new Set<String>();
        Set<String> productNames = new Set<String>();
        Map<String, String> groupRoleMap = new Map<String, String>();
        Set<Id> batchOwnerIds = new Set<Id>();

        Map<Id, Lead_Allocation_Staging__c> updateStagingData = new  Map<Id, Lead_Allocation_Staging__c>();

        for(Lead_Allocation_Staging__c rec :scope ){

            roleNames.add( rec.Role__c );
            groupNames.add( rec.Service_Group__c );
            campaignIds.add( rec.Campaign_Name__c );
            productNames.add( rec.Product_Interest__c );
            batchOwnerIds.add(rec.OwnerId);

            if(String.isNotBlank(rec.Role__c) && String.isNotBlank(rec.Service_Group__c)){
                groupRoleMap.put( rec.Service_Group__c, rec.Role__c);
            }
            
            if(rec.Product_Interest_2__c != null && String.isNotBlank(rec.Product_Interest_2__c)){
                productNames.add( rec.Product_Interest_2__c );
            }
            
            if(rec.Product_Interest_2__c != null && String.isNotBlank(rec.Product_Interest_3__c)){
                productNames.add( rec.Product_Interest_3__c );
            }

            updateStagingData.put(rec.Id, rec);
        
        }

        //Map products
        Map<String, Id> productMap = new Map<String, Id>();

        //for(Financial_Product__c prod :[Select Id, Name From Financial_Product__c Where Name IN :productNames]){
        for(Financial_Product__c prod :[Select Id, Name From Financial_Product__c Where Id IN :productNames]){
            //productMap.put(prod.Name, prod.Id);
            String recordId = String.valueOf(prod.Id).left(15);
			productMap.put(recordId, prod.Id);
        }
        //Map Service Groups
        Map<String, Id> serviceGroupMap = new Map<String, Id>();

        for(Service_Group__c sGroup :[Select Id, Name From Service_Group__c Where Name IN :groupNames]){

            serviceGroupMap.put(sGroup.Name, sGroup.Id);

        }

        //Map active and available users in roles
        Map<String, Set<Id>> roleUserMap = new Map<String, Set<Id>>();
        Map<String, Set<Id>> roleUserAllocationMap = new Map<String, Set<Id>>();

        for(User u :[Select Id, UserRole.Name From User Where UserRole.Name IN :roleNames AND isActive = true AND Is_Absent__c = false]){

            if( !roleUserMap.containsKey(u.UserRole.Name)){
                roleUserMap.put(u.UserRole.Name, new Set<Id>());
                roleUserAllocationMap.put(u.UserRole.Name, new Set<Id>());
            }

            if( roleUserMap.containsKey(u.UserRole.Name) ){
                roleUserMap.get(u.UserRole.Name).add(u.Id);
                roleUserAllocationMap.get(u.UserRole.Name).add(u.Id);
            }

        }
  

        //get all active and available group members for all public groups
        Set<Id> activeGroupMembers = new Set<Id>();

        for(User u :[Select Id, Is_Absent__c From User Where Id IN (Select UserOrGroupId From GroupMember Where Group.Name IN :groupNames) AND isActive = true AND Is_Absent__c = false]){
            activeGroupMembers.add(u.Id);
        }

        //Map users in public groups
        Map<String, Set<Id>> groupUserMap = new Map<String, Set<Id>>();
        Map<String, Set<Id>> groupPriorityUserMap = new Map<String, Set<Id>>();
        Map<String, Set<Id>> groupPriorityUserAllocationMap = new Map<String, Set<Id>>();
        Map<String, Set<Id>> groupUserAllocationMap = new Map<String, Set<Id>>();

        for(GroupMember gm :[Select Group.Name, UserOrGroupId From GroupMember Where UserOrGroupId IN :activeGroupMembers AND Group.Name IN :groupNames]){

            if( !groupUserMap.containsKey(gm.Group.Name)){

                groupUserMap.put(gm.Group.Name, new Set<Id>());
                groupUserAllocationMap.put(gm.Group.Name, new Set<Id>());

                //priority bankers
                groupPriorityUserMap.put(gm.Group.Name, new Set<Id>());
                groupPriorityUserAllocationMap.put(gm.Group.Name, new Set<Id>());
            }

            if( groupUserMap.containsKey(gm.Group.Name) ){

                groupUserMap.get(gm.Group.Name).add(gm.UserOrGroupId);
                groupUserAllocationMap.get(gm.Group.Name).add(gm.UserOrGroupId);

                //priority bankers based on Role / group - Group priority bakers to their corresponding public group
                if( groupRoleMap.containsKey(gm.Group.Name) ){

                    if(roleUserMap.containsKey(groupRoleMap.get(gm.Group.Name))){
                        
                        if( roleUserMap.get( groupRoleMap.get(gm.Group.Name)).contains(gm.UserOrGroupId) ){
    
                            groupPriorityUserMap.get(gm.Group.Name).add(gm.UserOrGroupId);
                            groupPriorityUserAllocationMap.get(gm.Group.Name).add(gm.UserOrGroupId);
    
                        }
                    }
                   
                }
            }

        }
        
        //get current Lead assigment count per user in order to proportionally assign the Leads according to
        //relevant work load
        Map<Id, Integer> userLeadCounter = new Map<Id, Integer>();

        List<AggregateResult> resultList = [Select COUNT(Id) cnt, OwnerId 
                                            From Lead 
                                            Where OwnerId IN :activeGroupMembers 
                                            GROUP By OwnerId 
                                            ORDER BY count(Id)];

        for (AggregateResult ar: resultList){

            userLeadCounter.put( (Id)ar.get('OwnerId'), (Integer)ar.get('cnt') );

        } 

        //Give zero count for active users that are not part of the result set from our aggregated query as they have no leads
        //allocated to them
        for(String uId :activeGroupMembers){
            
            if(!userLeadCounter.containsKey(uId)){

                userLeadCounter.put( (Id)uId, 1);

            }

        }


        //Create Leads and assign proportionally to the relevant users base on currect lead allocation counts
        List<Lead_Allocation_Staging__c> recFailedValidation = new List<Lead_Allocation_Staging__c>();
        List<Lead> leadList = new List<Lead>();

        for(Lead_Allocation_Staging__c rec :scope ){

            Lead newLead = new Lead();

            newLead.FirstName = rec.First_Name__c;
            newLead.LastName = rec.Last_Name__c;
            newLead.ID_Number__c = rec.ID_Number__c;
            newLead.MobilePhone = rec.Cell_Phone_Number__c;
            newLead.Email = rec.Email_Address__c;
            newLead.Phone = rec.Phone_Number__c;
            newLead.CIF__c = rec.CIF__c;
            newLead.LeadSource = rec.Lead_Source__c;
            
			if(productMap.containsKey(rec.Product_Interest__c)){
                //newLead.Financial_Product__c = productMap.get(rec.Product_Interest__c);
                newLead.Product_Interest_1__c = productMap.get(rec.Product_Interest__c);
            }
            
            if(productMap.containsKey(rec.Product_Interest_2__c)){
                newLead.Product_Interest_2__c = productMap.get(rec.Product_Interest_2__c);
            }
            
            if(productMap.containsKey(rec.Product_Interest_3__c)){
                newLead.Product_Interest_3__c = productMap.get(rec.Product_Interest_3__c);
            }

            if(serviceGroupMap.containsKey(rec.Service_Group__c)){
                newLead.Service_Group_Search__c = serviceGroupMap.get(rec.Service_Group__c);
                newLead.sd_Service_Group_Id__c =  serviceGroupMap.get(rec.Service_Group__c);
            }

            if(rec.Campaign_Name__c InstanceOf ID) {  
                newLead.Campaign__c = rec.Campaign_Name__c;
            }

            newLead.sd_Service_Group__c = rec.Service_Group__c;
            newLead.sd_Original_Service_Group__c = rec.Service_Group__c;
            newLead.Data_Staging_Record_Id__c = rec.Id;
            newLead.Source_Business_Unit__c = rec.Business_Unit__c; 
            
            //Defaults
            newLead.Status = 'Allocated';
            newLead.Allocated_Time__c = system.now();
            newLead.Lead_Category__c = 'Bulk Upload Leads';
            //newLead.Nationality__c = 'South Africa';
            newLead.Bypass_Validation_Rules__c = false;

            //Lead owner allocation
            //records have a role specified. We have to assign Leads to these priority bankers
            //in the role that is also in the public group for a record

            if(String.isNotBlank(rec.Role__c)){
                
                if(roleUserMap.containsKey(rec.Role__c)){

                    String userId = '';

                    /** DO NOT DELETE - MIGHT USE THIS FOR EQUAL ASSIGMENT IN A ROUND ROBIN FASHION
                    if( !groupPriorityUserAllocationMap.get(rec.Service_Group__c).isEmpty() ){
                    
                        userId = new List<Id>(groupPriorityUserAllocationMap.get(rec.Service_Group__c))[0];

                    }else{

                        groupPriorityUserAllocationMap.get(rec.Service_Group__c).addAll(groupPriorityUserMap.get(rec.Service_Group__c));

                        if(!groupPriorityUserAllocationMap.get(rec.Service_Group__c).isEmpty()){
                            userId = new List<Id>(groupPriorityUserAllocationMap.get(rec.Service_Group__c))[0];
                            
                        }
                       
                    } 
                    */
                    if(groupPriorityUserMap.containsKey(rec.Service_Group__c)){

                        if( !groupPriorityUserMap.get(rec.Service_Group__c).isEmpty() ){

                            Integer smallesCount = 0;

                            for(Id uid :groupPriorityUserMap.get(rec.Service_Group__c)){

                                if(userLeadCounter.containsKey(uid) ){

                                    if( ( userLeadCounter.get(uid) <= smallesCount ) || ( smallesCount == 0 )){
                                        
                                        userId = uid;

                                        smallesCount = userLeadCounter.get(uid);
                                    }

                                   
                                } 
                            }

                            if( userId != '' ){

                                newLead.OwnerId = userId;
                                
                                //Increment Lead allocation count for this user
                                userLeadCounter.put((Id)userId, ( (Integer)userLeadCounter.get(userId) + 1));
                                
                                //remove Id from set
                                //DO NOT DELETE - MIGHT USE THIS FOR EQUAL ASSIGMENT IN A ROUND ROBIN FASHION
                                //groupPriorityUserAllocationMap.get(rec.Service_Group__c).remove(userId);
        
                            }
        
                            leadList.add(newLead);

                        }else{

                            rec.Process_Status__c = 'Error';
                            rec.Process_Date__c = System.now();
                            //rec.Process_Information__c = 'There are no users for Lead assignment, in the public group ' + rec.Service_Group__c;
                            rec.Process_Information__c = 'There are no users for Lead assignment in this branch ' + rec.Service_Group__c + 
                        						 		 ', or not configured correctly, please ask your admisitrator for help!';
                            recFailedValidation.add(rec);
                        }

                    }else{
                        rec.Process_Status__c = 'Error';
                        rec.Process_Date__c = System.now();
                        /*rec.Process_Information__c = 'The Service Group value in the upload file, did NOT match any Public Group Name in Salesforce.\n' +
                                                      'File Service Group Name Value = ' + rec.Service_Group__c;*/
                        rec.Process_Information__c = 'There are no users for Lead assignment in this branch ' + rec.Service_Group__c + 
                        						 	 ', or not configured correctly, please ask your admisitrator for help!';
                        recFailedValidation.add(rec);
                    }
                    
                }else{

                    rec.Process_Status__c = 'Error';
                    rec.Process_Date__c = System.now();
                    /*rec.Process_Information__c = 'The Role value in the upload file, did NOT match any Role Name in Salesforce.\n' +
                                                  'File Role Name Value = ' + rec.Role__c;*/
                    rec.Process_Information__c = 'There are no users for Lead assignment in this branch ' + rec.Service_Group__c + 
                        						 ', or not configured correctly, please ask your admisitrator for help!';
                    recFailedValidation.add(rec);
                }

            }else{
                if(groupUserMap.containsKey(rec.Service_Group__c)){
          
                    String userId = '';

                   /**  /** DO NOT DELETE - MIGHT USE THIS FOR EQUAL ASSIGMENT IN A ROUND ROBIN FASHION
                    if( !groupUserAllocationMap.get(rec.Service_Group__c).isEmpty() ){
                        userId = new List<Id>(groupUserAllocationMap.get(rec.Service_Group__c))[0];
                    }else{

                        groupUserAllocationMap.get(rec.Service_Group__c).addAll(groupUserMap.get(rec.Service_Group__c));

                        if(!groupUserAllocationMap.get(rec.Service_Group__c).isEmpty()){
                            userId = new List<Id>(groupUserAllocationMap.get(rec.Service_Group__c))[0];
                        }
                       
                    }*/
                    
                    if( !groupUserMap.get(rec.Service_Group__c).isEmpty() ){
                        
                        Integer smallesCount = 0;

                        for(Id uid :groupUserMap.get(rec.Service_Group__c)){

                            if(userLeadCounter.containsKey(uid) ){

                                if( ( userLeadCounter.get(uid) <= smallesCount ) || ( smallesCount == 0 )){

                                    userId = uid;

                                    smallesCount = userLeadCounter.get(uid);
                                }

                            } 
                        }

                        if( userId != '' ){

                            newLead.OwnerId = userId;
                            
                            //Increment Lead allocation count for this user

                            userLeadCounter.put((Id)userId, ( (Integer)userLeadCounter.get(userId) + 1));
    
                            //remove Id from set
                            //DO NOT DELETE - MIGHT USE THIS FOR EQUAL ASSIGMENT IN A ROUND ROBIN FASHION
                            //groupUserAllocationMap.get(rec.Service_Group__c).remove(userId);
                        }
                        
                        leadList.add(newLead);

                    }else{

                        rec.Process_Status__c = 'Error';
                        rec.Process_Date__c = System.now();
                        //rec.Process_Information__c = 'There are no users for Lead assignment, in the public group ' + rec.Service_Group__c;
                        rec.Process_Information__c = 'There are no users for Lead assignment in this branch ' + rec.Service_Group__c + 
                        						 ', or not configured correctly, please ask your admisitrator for help!';
                        recFailedValidation.add(rec);
                    }

                }else{
                    rec.Process_Status__c = 'Error';
                    rec.Process_Date__c = System.now();
                    /*rec.Process_Information__c = 'The Service Group value in the upload file, did NOT match any Public Group Name in Salesforce.\n' +
                                                  'File Service Group Name Value = ' + rec.Service_Group__c;*/
                    rec.Process_Information__c = 'There are no users for Lead assignment in this branch ' + rec.Service_Group__c + 
                        						 ', or not configured correctly, please ask your admisitrator for help!';
                    recFailedValidation.add(rec);
                }

            }
            
        }
       
        //Insert new Leads and catch all success and failed inserts into collections 
        //to use for updating teh staging record
        Map<Id, String> errorLeads = new Map<Id, String>();
        Set<Id> succesfulLeads = new Set<Id>();

        try{

            Database.SaveResult[] saveRes = Database.insert(leadList, false);

            for(Integer i = 0; i < saveRes.size(); i++){

                if (saveRes.get(i).isSuccess()){

                    succesfulLeads.add( saveRes.get(i).getId() );
                
                }else if (!saveRes.get(i).isSuccess()){
                    
                    Database.Error error = saveRes.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    //errorLeads.put(leadList.get(i).Id, failedDML);
                    errorLeads.put(leadList.get(i).Data_Staging_Record_Id__c, failedDML);            
                }
            
            }

        }catch(DmlException ex){
            throw ex;
        }

        
       

        //Success
        for ( Lead l :[Select Id, OwnerId, Data_Staging_Record_Id__c From Lead Where Id IN :succesfulLeads]){

            updateStagingData.get(l.Data_Staging_Record_Id__c).Process_Date__c = System.now();
            updateStagingData.get(l.Data_Staging_Record_Id__c).Process_Status__c = 'Completed';
            updateStagingData.get(l.Data_Staging_Record_Id__c).Process_Information__c = 'Lead created successfully and assigned';
        }

        //Failed
        for ( Lead_Allocation_Staging__c la :[Select Id, OwnerId, Process_Date__c, Process_Status__c, Process_Information__c,
                                              Email_Address__c, First_Name__c, Last_Name__c    
                                              From Lead_Allocation_Staging__c Where Id IN :errorLeads.keySet()]){
            
            la.Process_Date__c = System.now();
            la.Process_Status__c = 'Error';
            la.Process_Information__c = errorLeads.get(la.Id);
            
            recFailedValidation.add(la);

        }

        
        try{
            update updateStagingData.values();
        }catch(DmlException ex){
            throw ex;
        }

        try{
            update recFailedValidation;
        }catch(DmlException ex){
            throw ex;
        }

        //Email out the stats for this batch to the record owner

        String pdfContents = '<html><body>';

        pdfContents += '<div>';
        pdfContents += '<table style="font-family:Trebuchet MS, Arial, Helvetica, sans-serif;">';

        pdfContents += '<tr>';
        pdfContents += '<td colspan="2" >Your Lead import is complete. Here are your results. Any errors will show in the below table:</td>';
        pdfContents += '</tr>';
        pdfContents += '<tr>';
        pdfContents += '<td width="10%" style="padding-top: 12px;padding-bottom: 12px;">Leads Created</td>';
        pdfContents += '<td width="90%" style="padding-top: 12px;padding-bottom: 12px;font-weight:bold">' + succesfulLeads.size() + '</td>';
        pdfContents += '</tr>';
        pdfContents += '<tr>';
        pdfContents += '<td width="10%" style="padding-top: 12px;padding-bottom: 12px;">Leads Failed</td>';
        pdfContents += '<td width="90%" style="padding-top: 12px;padding-bottom: 12px;font-weight:bold">' + recFailedValidation.size() + '</td>';
        pdfContents += '</tr>';
        pdfContents += '</table>';
        pdfContents += '</div>';
        pdfContents += '&nbsp;&nbsp;&nbsp;';
        pdfContents += '<div>';
        pdfContents += '<table style="border: 1px solid black;border-collapse: collapse;font-family:Trebuchet MS, Arial, Helvetica, sans-serif;">';
        pdfContents += '<thead style="font-size: 14px;">';
        pdfContents += '<tr>';
        pdfContents += '<th style="border: 1px solid black;background-color: #66c2ff;padding: 8px;">Record Id</th>';
        pdfContents += '<th style="border: 1px solid black;background-color: #66c2ff;padding: 8px;">Process Date</th>';
        pdfContents += '<th style="border: 1px solid black;background-color: #66c2ff;padding: 8px;">Process Status</th>';
        pdfContents += '<th style="border: 1px solid black;background-color: #66c2ff;padding: 8px;">Process Information</th>';
        pdfContents += '<th style="border: 1px solid black;background-color: #66c2ff;padding: 8px;">Lead Name</th>';
        pdfContents += '<th style="border: 1px solid black;background-color: #66c2ff;padding: 8px;">Lead Surname</th>';
        pdfContents += '<th style="border: 1px solid black;background-color: #66c2ff;padding: 8px;">Lead Email</th>';
        pdfContents += '</tr>';
        pdfContents += '</thead>';
        pdfContents += '<tbody style="font-size: 12px;font-family:Trebuchet MS, Arial, Helvetica, sans-serif">';

        for(Lead_Allocation_Staging__c ld :recFailedValidation) {

            pdfContents += '<tr>';

            pdfContents += '<td style="border: 1px solid black;padding: 8px;">' + ld.Id + '</td>';
            pdfContents += '<td style="border: 1px solid black;padding: 8px;">' + ld.Process_Date__c + '</td>';
            pdfContents += '<td style="border: 1px solid black;padding: 8px;">' + ld.Process_Status__c + '</td>';
            pdfContents += '<td style="border: 1px solid black;padding: 8px;">' + ld.Process_Information__c + '</td>';
            pdfContents += '<td style="border: 1px solid black;padding: 8px;">' + ld.First_Name__c + '</td>';
            pdfContents += '<td style="border: 1px solid black;padding: 8px;">' + ld.Last_Name__c + '</td>';
            pdfContents += '<td style="border: 1px solid black;padding: 8px;">' + ld.Email_Address__c + '</td>';

            pdfContents += '</tr>';
        }

        pdfContents += '</tbody>';
        pdfContents += '</table>';
        pdfContents += '</div>';
        pdfContents += '</body>';
        pdfContents += '</html>';

        list<String> toAddress = new list<String>();

        for(User u :[Select Email From User Where Id IN :batchOwnerIds]){
            toAddress.add(u.Email);
        }

        List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();

        Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();
        emailOut.setSubject('Lead Upload Results');
        emailOut.setToAddresses(toAddress);
        emailOut.setHtmlBody(pdfContents);

        emailsOutList.add(emailOut);

        try{
            Messaging.sendEmail(emailsOutList);
        }catch(Exception ex){
            throw ex;
        }
    
    }

    /**
    * @description Finish method
    * @param BC 
    **/
    global void finish(Database.BatchableContext BC){

        
    }

}