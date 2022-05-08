public class ROTSchedulerHandler {
     
     public static void caseROTStartDateUpdate(Id caseId){
        
        List<RestrictionGroup__c> caseRestrictionIdsLists = [select id, GroupID__c, Name, GroupRestrictionClusterID__c 
                                                             from RestrictionGroup__c where Case__c = :caseId];
      	system.debug('caseRestrictionIdsLists size.....' +caseRestrictionIdsLists.size());
        List<RestrictionGroupAccount__c> rgAccountIDsLists = [select id, Name, EffectiveEndDate__c, EffectiveStartDate__c
                                                              from RestrictionGroupAccount__c where RestrictionGroupId__c in :caseRestrictionIdsLists];
        system.debug('rgAccountIDsLists size.....' +rgAccountIDsLists.size());
        List<RestrictionGroupCustomer__c> rgCustomerIDsLists = [select id, Name, EffectiveEndDate__c, EffectiveStartDate__c
                                                              from RestrictionGroupCustomer__c where RestrictionGroupId__c in :caseRestrictionIdsLists];
        system.debug('rgCustomerIDsLists size.....' +rgCustomerIDsLists.size());
        List<RestrictionGroupTransactionType__c> rgTransTypeIDsLists = [select id, Name, Effective_End_Date__c, Effective_Start_Date__c
                                                              from RestrictionGroupTransactionType__c where Restriction_Group_ID__c in :caseRestrictionIdsLists];
      	system.debug('rgTransTypeIDsLists size.....' +rgTransTypeIDsLists.size());
        List<Object> prelapseODate = new List<Object>();
        List<Date> prelapseSDate = new List<Date>();
        List<Date> lapseEDate = new List<Date>();
        try{
       
            if(rgAccountIDsLists.size() != 0 && rgAccountIDsLists.size() != null){
                for(Integer akey = 0; akey<rgAccountIDsLists.size(); akey++){                    
                    prelapseSDate.add(rgAccountIDsLists.get(akey).EffectiveStartDate__c);
                    lapseEDate.add(rgAccountIDsLists.get(akey).EffectiveEndDate__c);
                }
            }
            
            if(rgCustomerIDsLists.size() != 0 && rgCustomerIDsLists.size() != null){
                for(Integer akey = 0; akey<rgCustomerIDsLists.size(); akey++){                   
                    prelapseSDate.add(rgCustomerIDsLists.get(akey).EffectiveStartDate__c);
                    lapseEDate.add(rgCustomerIDsLists.get(akey).EffectiveEndDate__c);
                }
            }
            
            if(rgTransTypeIDsLists.size() != 0 && rgTransTypeIDsLists.size() != null){
                for(Integer akey = 0; akey<rgTransTypeIDsLists.size(); akey++){                   
                    prelapseSDate.add(rgTransTypeIDsLists.get(akey).Effective_Start_Date__c);
                    lapseEDate.add(rgTransTypeIDsLists.get(akey).Effective_End_Date__c);
                }
            }           
            prelapseSDate.sort();           
            lapseEDate.sort();
            //system.debug('Sorted list of prelapseSDate index 0....' +prelapseSDate.get(0));
           // system.debug('Sorted list of lapseEDate index 0....' +lapseEDate.get(0));
            Date sDate = prelapseSDate.get(0);
            system.debug('least date sDate...................' +sDate);
            Date eDate = lapseEDate.get(0);
            system.debug('least end eDate...................' +eDate);
            Case rotCase = new Case(Id = caseId);
            if(rotCase.Id == caseId){
                rotCase.ROT_Start_Date__c = sDate;
                rotCase.ROT_End_Date__c = eDate;
            }
            update rotCase;
        }
        catch(Exception e){
            system.debug('Error for................' +e.getMessage());
        }
        
    }
    
    public static void lapseCaseUpdate(Id caseId){
        
        try{
        Case rotCase = [select id, Status from Case where id = :caseId];
        rotCase.Status = 'Closed';
      
            update rotCase;
        }catch(Exception e){
            system.debug('Error.......' +e.getMessage());
            system.debug('Error line.....' +e.getLineNumber());
        }
    }
    
    public static void preLapseStartDateEmailContext(Id schCaseId){
        
        try{
            Case rotCase = [select id, Account.Name, Account.OwnerId, CreatedBy.Name, OwnerId, ROT_Start_Date__c, CaseNumber
                            from Case where id = :schCaseId];
           // User rotUserMB = [select id, Name from User where Email like 'Manish.Battu@absa.africa'];
          //  User rotUserRB = [select id, Name from User where Email like 'Bhanumurty.Rayala@absa.africa'];        
          
            Id accOwnerId = rotCase.Account.OwnerId;
            Id csOwnerId = rotCase.OwnerId;       
           // Id usM = rotUserMB.Id;
           // Id usRB = rotUserRB.Id;
            List<Id> idLists = new List<Id>();
            for(User grpMember : [Select Id, Email from User where Id IN (Select UserOrGroupId From GroupMember where Group.Name = 'ROT Approvers Queue')]){
                idLists.add(grpMember.Id);                
            }
            idLists.add(csOwnerId);
           // String[] rotIds = new String[]{accOwnerId,csOwnerId,usM,usRB};
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	//mail.setToAddresses(rotIds);
            mail.setToAddresses(idLists);
            mail.setSubject('Restriction Of Transactions - Instruction Lapse Notification for' +rotCase.CaseNumber);
           // mail.setPlainTextBody('ROT Notification');
            mail.setHtmlBody('<p>ROT Notification</p>'+'<p>A Restriction Of Transactions Instruction is going to Lapse</p>'+'<p>Dear User</p>'+
				'<p>The relevant Restriction Of Transactions Instruction will Lapse in 48 Hours. Please close or complete the instruction.</p>'+
                '<p>Instruction information: </p>'+
                '<p>• Customer Key:' +rotCase.Account.Name+'</br>'+
                '• Instruction ID:'+ rotCase.CaseNumber+'</br>'+
                '• Type: Maintenance - Restriction Of Transactions</br>'+
                '• Created By:'+rotCase.CreatedBy.Name+'</br>'+
                '• Date:' +rotCase.ROT_Start_Date__c+'</br>'+
                '</p>'+
                '<p>For additional information:'+
                '<a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+rotCase.Id+'>'+ rotCase.CaseNumber+'</a></p>'+
                '<p>Please do not respond to this email address as this is a system generated email.</p>'+ 
                '<p>Sincerely,</p>'+
                '<p>The ROT Team</p>');
                                        
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('Email was send sucessfully!!!!!!!!!!!!!!!!!!!!!');
        }catch(Exception e){
            system.debug('Error.......' +e.getMessage());
            system.debug('Error line.....' +e.getLineNumber());
        }
    }
    
     public static void lapseStartDateEmailContext(Id schCaseId){
        
        try{
            Case rotCase = [select id, Account.Name, Account.OwnerId, CreatedBy.Name, OwnerId, ROT_Start_Date__c, CaseNumber
                            from Case where id = :schCaseId];
           // User rotUserMB = [select id, Name from User where Email like 'Manish.Battu@absa.africa'];
           // User rotUserRB = [select id, Name from User where Email like 'Bhanumurty.Rayala@absa.africa'];
          
            Id accOwnerId = rotCase.Account.OwnerId;
            Id csOwnerId = rotCase.OwnerId;       
           // Id usM = rotUserMB.Id;
           // Id usRB = rotUserRB.Id;
           // String[] rotIds = new String[]{accOwnerId,csOwnerId,usM,usRB};
            
            List<Id> idLists = new List<Id>();
            for(User grpMember : [Select Id, Email from User where Id IN (Select UserOrGroupId From GroupMember where Group.Name = 'ROT Approvers Queue')]){
                idLists.add(grpMember.Id);
            }
            idLists.add(csOwnerId);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	mail.setToAddresses(idLists);
            mail.setSubject('Restriction Of Transactions - Instruction Lapse Notification for' +rotCase.CaseNumber);
            mail.setPlainTextBody('ROT Notification');
            mail.setHtmlBody('<p>ROT Notification</p>'+
				'<p>Restriction Of Transactions Instruction Automatically Terminated</p>'+
				'<p>Dear User</p>'+
				'<p>The Restriction Of Transactions instruction has been automatically terminated from the workflow due to the instruction lapsing.</p>'+
                '<p>Instruction information: </p>'+
                '<p>• Customer Key:' +rotCase.Account.Name+'</br>'+
                '• Instruction ID:'+ rotCase.CaseNumber+'</br>'+
                '• Type: Maintenance - Restriction Of Transactions</br>'+
				'• Team: Restriction Of Transactions Approver</br>'+
                '• Created By:'+rotCase.CreatedBy.Name+'</br>'+
				'• Step: Restriction Of Transactions Approval</br>'+
                '• Date:' +rotCase.ROT_Start_Date__c+'</br>'+
                '</p>'+
                '<p>For additional information:'+
                '<a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+rotCase.Id+'>'+ rotCase.CaseNumber+'</a></p>'+
                '<p>Please do not respond to this email address as this is a system generated email.</p>'+ 
                '<p>Sincerely,</p>'+
                '<p>The ROT Team</p>');
                            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('Email was send sucessfully!!!!!!!!!!!!!!!!!!!!!');
			ROTSchedulerHandler.lapseCaseUpdate(schCaseId);
            system.debug('Check case record!!!!!!!!!!!!!!!!!!!!!');
        }catch(Exception e){
            system.debug('Error.......' +e.getMessage());
            system.debug('Error line.....' +e.getLineNumber());
        }
    }
    
     public static void preLapseEndDateEmailContext(Id schCaseId){
        
        try{
            Case rotCase = [select id, Account.Name, Account.OwnerId, CreatedBy.Name, OwnerId, ROT_End_Date__c, CaseNumber
                            from Case where id = :schCaseId];
           // User rotUserMB = [select id, Name from User where Email like 'Manish.Battu@absa.africa'];
           // User rotUserRB = [select id, Name from User where Email like 'Bhanumurty.Rayala@absa.africa'];
          
            Id accOwnerId = rotCase.Account.OwnerId;
            Id csOwnerId = rotCase.OwnerId;       
           // Id usM = rotUserMB.Id;
          //  Id usRB = rotUserRB.Id;
          //  String[] rotIds = new String[]{accOwnerId,csOwnerId,usM,usRB};
            List<Id> idLists = new List<Id>();
            for(User grpMember : [Select Id, Email from User where Id IN (Select UserOrGroupId From GroupMember where Group.Name = 'ROT Approvers Queue')]){
                idLists.add(grpMember.Id);
            }
            idLists.add(csOwnerId);    
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	mail.setToAddresses(idLists);
            mail.setSubject('Restriction Of Transactions - Instruction Lapse Notification for' +rotCase.CaseNumber);
            //mail.setPlainTextBody('ROT Notification');
            mail.setHtmlBody('<p>ROT Notification</p>'+'<p>A Restriction Of Transactions Instruction is going to Lapse</p>'+'<p>Dear User</p>'+
				'<p>The relevant Restriction Of Transactions Instruction will Lapse in 48 Hours. Please close or complete the instruction.</p>'+
                '<p>Instruction information: </p>'+
                '<p>• Customer Key:' +rotCase.Account.Name+'</br>'+
                '• Instruction ID:'+ rotCase.CaseNumber+'</br>'+
                '• Type: Maintenance - Restriction Of Transactions</br>'+
                '• Created By:'+rotCase.CreatedBy.Name+'</br>'+
                '• Date:' +rotCase.ROT_End_Date__c+'</br>'+
                '</p>'+
                '<p>For additional information:'+
                '<a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+rotCase.Id+'>'+ rotCase.CaseNumber+'</a></p>'+
                '<p>Please do not respond to this email address as this is a system generated email.</p>'+ 
                '<p>Sincerely,</p>'+
                '<p>The ROT Team</p>');
                            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('Email was send sucessfully!!!!!!!!!!!!!!!!!!!!!');
        }catch(Exception e){
            system.debug('Error.......' +e.getMessage());
            system.debug('Error line.....' +e.getLineNumber());
        }
    }
    
     public static void lapseEndDateEmailContext(Id schCaseId){
        
        try{
            Case rotCase = [select id, Account.Name, Account.OwnerId, CreatedBy.Name, OwnerId, ROT_End_Date__c, CaseNumber
                            from Case where id = :schCaseId];
          //  User rotUserMB = [select id, Name from User where Email like 'Manish.Battu@absa.africa'];
          //  User rotUserRB = [select id, Name from User where Email like 'Bhanumurty.Rayala@absa.africa'];
          
            Id accOwnerId = rotCase.Account.OwnerId;
            Id csOwnerId = rotCase.OwnerId;
            
           // Id usM = rotUserMB.Id;
           // Id usRB = rotUserRB.Id;
           // String[] rotIds = new String[]{accOwnerId,csOwnerId,usM,usRB};
            List<Id> idLists = new List<Id>();
            for(User grpMember : [Select Id, Email from User where Id IN (Select UserOrGroupId From GroupMember where Group.Name = 'ROT Approvers Queue')]){
                idLists.add(grpMember.Id);
            }
            idLists.add(csOwnerId);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	mail.setToAddresses(idLists);
            mail.setSubject('Restriction Of Transactions - Instruction Lapse Notification for' +rotCase.CaseNumber);
            mail.setPlainTextBody('ROT Notification');
            mail.setHtmlBody('<p>ROT Notification</p>'+
				'<p>Restriction Of Transactions Instruction Automatically Terminated</p>'+
				'<p>Dear User</p>'+
				'<p>The Restriction Of Transactions instruction has been automatically terminated from the workflow due to the instruction lapsing.</p>'+
                '<p>Instruction information: </p>'+
                '<p>• Customer Key:' +rotCase.Account.Name+'</br>'+
                '• Instruction ID:'+ rotCase.CaseNumber+'</br>'+
                '• Type: Maintenance - Restriction Of Transactions</br>'+
				'• Team: Restriction Of Transactions Approver</br>'+
                '• Created By:'+rotCase.CreatedBy.Name+'</br>'+
				'• Step: Restriction Of Transactions Approval</br>'+
                '• Date:' +rotCase.ROT_End_Date__c+'</br>'+
                '</p>'+
                '<p>For additional information:'+
                '<a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+rotCase.Id+'>'+ rotCase.CaseNumber+'</a></p>'+
                '<p>Please do not respond to this email address as this is a system generated email.</p>'+ 
                '<p>Sincerely,</p>'+
                '<p>The ROT Team</p>');
                            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            system.debug('Email was send sucessfully!!!!!!!!!!!!!!!!!!!!!');
			ROTSchedulerHandler.lapseCaseUpdate(schCaseId);
            system.debug('Check the case record!!!!!!!!!!!!!!!!!!!!!');
        }catch(Exception e){
            system.debug('Error.......' +e.getMessage());
            system.debug('Error line.....' +e.getLineNumber());
        }
    }
    
    

}