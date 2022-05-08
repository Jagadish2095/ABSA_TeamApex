/**
* @description Test class for CommunicationPlanFunctions
* @since 2019-04-29
**/
@isTest
public class CommunicationPlanFunctionsTest {

    @TestSetup static void makeData(){
        //System.debug('------- makeData Start ------');
        CommunicationPlanTestDataFactory ComPlanfactory = new CommunicationPlanTestDataFactory();
        User adm = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserAdmin@testorg.com') {
                    adm=u;
                }
            }
        }
        System.runAs(adm){
            User uS = new User();
            User uA = new User();
            User uB = new User();
            User uC = new User();
            User uD = new User();
            User uE = new User();
            Set<String> uEmails = new Set<String>();
            uEmails.add('UserA@testorg.com');
            uEmails.add('UserB@testorg.com');
            uEmails.add('UserC@testorg.com');
            uEmails.add('UserD@testorg.com');
            uEmails.add('UserE@testorg.com');
            uEmails.add('User@testorg.com');
            uEmails.add('UserAdmin@testorg.com');
            List<User> uList = new UsersSelector().selectByEmail(uEmails);
            Group g1;
            Group g2;
            List <Group> gList = new List<Group>();
            gList = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name LIKE '%Complaint%' AND QueueRoutingConfigId != null LIMIT 2];
            if (gList.size()>0) {
                if (gList.size() > 0) {
                    Integer cnt = 1;
                    for (Group g : gList) {
                        if (cnt==1) {
                            g1=g;
                        }else if (cnt==2) {
                            g2=g;
                        }
                        cnt++;
                    }
                }
            }
            if (uList.size()>0) {
                for (User u : uList) {
                    if (u.Email=='UserAdmin@testorg.com') {
                        GroupMember member = new GroupMember();
                        member.UserOrGroupId = u.Id;
                        member.GroupId = g1.Id;
                        insert member;
                    }else if (u.Email=='UserA@testorg.com') {
                        uA=u;
                        GroupMember member = new GroupMember();
                        member.UserOrGroupId = u.Id;
                        member.GroupId = g1.Id;
                        insert member;
                    }else if (u.Email=='UserB@testorg.com') {
                        uB=u;
                        GroupMember member = new GroupMember();
                        member.UserOrGroupId = u.Id;
                        member.GroupId = g1.Id;
                        insert member;
                    }else if (u.Email=='UserC@testorg.com') {
                        uC=u;
                        GroupMember member = new GroupMember();
                        member.UserOrGroupId = u.Id;
                        member.GroupId = g1.Id;
                        insert member;
                    }else if (u.Email=='UserD@testorg.com') {
                        uD=u;
                        GroupMember member = new GroupMember();
                        member.UserOrGroupId = u.Id;
                        member.GroupId = g1.Id;
                        insert member;
                    }else if (u.Email=='UserE@testorg.com') {
                        uE=u;
                        GroupMember member = new GroupMember();
                        member.UserOrGroupId = u.Id;
                        member.GroupId = g1.Id;
                        insert member;
                    }else if (u.Email=='User@testorg.com') {
                        uS=u;
                        GroupMember member = new GroupMember();
                        member.UserOrGroupId = u.Id;
                        member.GroupId = g1.Id;
                        insert member;
                    }
                }
            }
            Case case1 = new Case();
            Case case2 = new Case();
            Case case3 = new Case();
            Case case4 = new Case();
            Case case5 = new Case();
            Case case6 = new Case();
            List<Account> accList = new AccountsSelector().selectByIdNumber('8107115017084',1);
            Id accId;
            if (accList.size()>0) {
                accId = accList.get(0).Id;
            }
            List<Case> caseList = [SELECT Id, Subject, Status, OwnerId, Assigned_Date__c FROM CASE WHERE AccountId = :accId];
            List<Case> cownUpdateList = new List<Case>();
            //System.debug('------- caseList : '+caseList);
            if (caseList.size()>0) {
                for (Case c : caseList) {
                    if (c.Subject=='Case 1') {
                        case1=c;
                        case1.OwnerID = uA.Id;
                        case1.Status = 'Assigned';
                        case1.Assigned_Date__c = System.now();
                        cownUpdateList.add(case1);
                    }else if (c.Subject=='Case 2') {
                        case2=c;
                        case2.OwnerID = uB.Id;
                        case2.Status = 'Assigned';
                        case2.Assigned_Date__c = System.now();
                        cownUpdateList.add(case2);
                    }else if (c.Subject=='Case 3') {
                        case3=c;
                        case3.OwnerID = uC.Id;
                        case3.Status = 'Assigned';
                        case3.Assigned_Date__c = System.now();
                        cownUpdateList.add(case3);
                    }else if (c.Subject=='Case 4') {
                        case4=c;
                        case4.OwnerID = uD.Id;
                        case4.Status = 'Assigned';
                        case4.Assigned_Date__c = System.now();
                        cownUpdateList.add(case4);
                    }else if (c.Subject=='Case 5') {
                        case5=c;
                    }else if (c.Subject=='Case 6') {
                        case6=c;
                        case6.OwnerID = uE.Id;
                        case6.Status = 'Assigned';
                        case6.Assigned_Date__c = System.now();
                        cownUpdateList.add(case6);
                    }
                }if (cownUpdateList.size()>0) {
                    update cownUpdateList;
                }
                //System.debug('------- cownUpdateList : '+cownUpdateList);
            }
            //System.debug('------- After Case Owner Update ------');
            Lead Lead1 = new Lead();
            Lead Lead2 = new Lead();
            Lead Lead3 = new Lead();
            Lead Lead4 = new Lead();
            List<Lead> leadList = [SELECT Id, Name, OwnerId, Status, Unsuccessful_Calls__c, Email FROM Lead WHERE OwnerId=:uS.Id LIMIT 4];
            List<Lead> lownUpdateList = new List<Lead>();
            //System.debug('------- leadList : '+leadList);
            if (leadList.size() > 0) {
                for (Lead l : leadList) {
                    if (l.Email == 'UserA@testorg.com') {
                        Lead1=l;
                        lead1.OwnerID = uA.Id;
                        lead1.Status = 'Assigned';
                        lead1.Unsuccessful_Calls__c = 1;
                        lownUpdateList.add(lead1);
                    }else if (l.Email == 'UserB@testorg.com') {
                        Lead2=l;
                        lead2.OwnerID = uB.Id;
                        lead2.Status = 'Assigned';
                        lead2.Unsuccessful_Calls__c = 1;
                        lownUpdateList.add(lead2);
                    }else if (l.Email == 'UserC@testorg.com') {
                        Lead3=l;
                    }else if (l.Email == 'UserD@testorg.com') {
                        Lead4=l;
                        Lead4.OwnerID = uE.Id;
                        Lead4.Status = 'Assigned';
                        Lead4.Unsuccessful_Calls__c = 1;
                        lownUpdateList.add(Lead4);
                    }
                }
                //System.debug('------- lownUpdateList : '+lownUpdateList);
                update lownUpdateList;
            }
            //System.debug('------- After Lead Owner Update ------');
        }  
        //System.debug('------- makeData End ------');
    }    
    @isTest static void commPlanFuncTestA(){
        //System.debug('------- commPlanFunTestA Start ------');
        User uA = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserA@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserA@testorg.com') {
                    uA=u;
                }
            }
        }
        System.runAs(uA){
            List<Lead> myLeadList = [SELECT Id, Status, Unsuccessful_Calls__c FROM Lead WHERE OwnerID = :uA.Id];
            Lead myLead = new Lead();
            if (myLeadList.size()>0) {
                myLead = myLeadList.get(0);
            }
            myLead.Unsuccessful_Calls__c = 4;
            myLead.Status = 'Abandoned';
            update myLead;  
            CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
            database.executeBatch(testCommunicationPlanActionBatch);
        } 
        //System.debug('------- commPlanFunTestA End ------');
    }
    @isTest static void commPlanFuncTestB(){
        //System.debug('------- commPlanFuncTestB Start ------');
        User uB = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserB@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserB@testorg.com') {
                    uB=u;
                }
            }
        }
        System.runAs(uB){
            List<Lead> myLeadList = [SELECT Id, Status, Unsuccessful_Calls__c FROM Lead WHERE OwnerID = :uB.Id];
            Lead myLead = new Lead();
            if (myLeadList.size()>0) {
                myLead = myLeadList.get(0);
            }
            myLead.Status = 'Working';
            update myLead;
            CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
            database.executeBatch(testCommunicationPlanActionBatch);
        }
        //System.debug('------- commPlanFuncTestB End ------');
    }
    @isTest static void commPlanFuncTestC(){
        //System.debug('------- commPlanFuncTestC Start ------');
        Group g2;
        List <Group> gList = new List<Group>();
        gList = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name LIKE '%Complaint%' AND QueueRoutingConfigId != null LIMIT 2];
        if (gList.size()>0) {
            if (gList.size() > 0) {
                Integer cnt = 1;
                for (Group g : gList) {
                    if (cnt==1) {

                    }else if (cnt==2) {
                        g2=g;
                    }
                    cnt++;
                }
            }
        }
        User uB = new User();
        User uS = new User();
        User adm = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserB@testorg.com');
        userEmails.add('User@testorg.com');
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        //System.debug('------- userList : '+userList);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserB@testorg.com') {
                    uB=u;
                } else if (u.Email=='User@testorg.com') {
                    uS=u;
                } else if (u.Email=='UserAdmin@testorg.com') {
                    adm=u;
                }
            }
        }
        System.runAs(adm){
            List<Case> admList = [SELECT Id, Status, Assigned_Date__c FROM Case WHERE OwnerID = :uB.Id];
            //System.debug('------- admList : '+admList);
            Case admCase = new case();
            if (admList.size()>0) {
                admCase = admList.get(0);
            }
            admCase.OwnerId = uS.Id;
            update admCase;
        }
        System.runAs(uS){
            List<Case> myCaseList = [SELECT Id, Status, Assigned_Date__c FROM Case WHERE OwnerID = :uS.Id];
            //System.debug('------- myCaseList : '+myCaseList);
            Case myCase = new case();
            if (myCaseList.size()>0) {
                myCase = myCaseList.get(0);
            }
            List<Lead> myLeadList = [SELECT Id, Status, Unsuccessful_Calls__c FROM Lead WHERE OwnerID = :uS.Id];
            Lead myLead = new Lead();
            if (myLeadList.size()>0) {
                myLead = myLeadList.get(0);
            }
            Datetime td	= System.today();
            Datetime externalEndDate =  td.addMonths(-2);
            //System.debug('----- externalEndDate : '+externalEndDate);
            myCase.OwnerId = uS.Id;
            update myCase;
            myCase.External_SLA_End_Date__c = externalEndDate;
            myCase.Assigned_Date__c = System.now();
            update myCase;
            myCase.Status = 'In Progress';
            update myCase;
            myCase.External_SLA_End_Date__c = externalEndDate.addDays(5);
            update myCase;            
            myCase.OwnerId = g2.Id;
            update myCase;            
            myLead.LeadSource = 'Phone';                
            myLead.Successful_Calls__c = 2;
            myLead.Status = 'Unqualified';
            update myLead;        
            CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
            database.executeBatch(testCommunicationPlanActionBatch);
        } 
        //System.debug('------- commPlanFuncTestC End ------');
    }
    @isTest static void commPlanFuncTestD(){
        //System.debug('------- commPlanFuncTestD Start ------');
        User uA = new User();
        User uB = new User();
        User uS = new User();
        User adm = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserA@testorg.com');
        userEmails.add('UserB@testorg.com');
        userEmails.add('User@testorg.com');
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        //System.debug('------- userList : '+userList);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserB@testorg.com') {
                    uB=u;
                } else if (u.Email=='User@testorg.com') {
                    uS=u;
                } else if (u.Email=='UserAdmin@testorg.com') {
                    adm=u;
                } else if (u.Email=='UserB@testorg.com') {
                    uA=u;
                }
            }
        }
        if (userList.size()>0) {
            for (User u : userList) {
                System.runAs(u){
                    List<Site__c> siteList = [SELECT Id FROM Site__c Limit 1];
                    Id siteId;
                    if (siteList.size()>0) {
                        siteId = siteList.get(0).Id;
                    }
                    List<Case> uCaseList = [SELECT Id, Status, Responsible_Site__c ,Resolved_in_Favour_of__c, Out_Of_SLA_Reason__c,Trade_Loss__c, 
                    Summary_of_Resolution__c, Where_Did_This_Happen__c,Who_Caused_It__c,Out_Of_SLA_Comments__c, Case_Ownership__c, 
                    Bypass_Validation_Rules__c FROM Case WHERE OwnerID = :u.Id];
                    //System.debug('------- uCaseList : '+uCaseList);
                    if (uCaseList.size()>0) {
                        for (Case uc : uCaseList) {
                            if (uc.Case_Ownership__c!='FPOC') { 
                                uc.Bypass_Validation_Rules__c = true ;
                            }
                            uc.Responsible_Site__c = siteId;
                            uc.Resolved_in_Favour_of__c = 'Bank';
                            uc.Out_Of_SLA_Reason__c = 'Account Closed';
                            uc.Trade_Loss__c = 'No';
                            uc.Summary_of_Resolution__c = 'Test';
                            uc.Where_Did_This_Happen__c = 'Test';
                            uc.Who_Caused_It__c = 'Test';
                            uc.Out_Of_SLA_Comments__c = 'Test';
                            uc.Status = 'Resolved';
                            //System.debug('--- uc : '+uc);
                            update uc;
                        }
                    }
                }
            }
            CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
            database.executeBatch(testCommunicationPlanActionBatch);
            List<Account> accList = new AccountsSelector().selectByIdNumber('8107115017084',1);
            Id accId;
            if (accList.size()>0) {
                accId = accList.get(0).Id;
            }
            List<Contact> contList = new ContactsSelector().selectCifFieldsByAccountId(accId);
            Id contId;
            if (contList.size()>0) {
                contId = contList.get(0).Id;
            }
            Set<Id> accountIds = new Set<Id>();
            accountIds.add(accId);
            List<Opportunity> oppList = new OpportunitiesSelector().selectBySetAccountIds(accountIds);
            Id oppId;
            if (oppList.size()>0) {
                oppId = oppList.get(0).Id;
            }
            CommunicationPlanFunctions.smsAction(contId, oppId, '', '', 'Test Quick Text Merge', 'Client EPP 4 Hours Before the Call SMS');
            DateTime actDate = CommunicationPlanFunctions.calculateActionDate(null, null, 'Day', 1, 'Before');
        }
        //System.debug('------- commPlanFuncTestD End ------');
    }
    @isTest static void commPlanFuncTestE(){
        //System.debug('------- commPlanFuncTestE Start ------');
        User uB = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserB@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserB@testorg.com') {
                    uB=u;
                }
            }
        }
        System.runAs(uB){
            List<Lead> myLeadList = [SELECT Id, Status, Unsuccessful_Calls__c FROM Lead WHERE OwnerID = :uB.Id];
            Lead myLead = new Lead();
            if (myLeadList.size()>0) {
                myLead = myLeadList.get(0);
            }

            myLead.Successful_Calls__c = 2;
            mylead.Company_Registration_Number__c = '123456789';
            mylead.Entity_Type__c = 'Foreign Companies';
            myLead.Status = 'Qualified';
            update myLead;
            CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
            database.executeBatch(testCommunicationPlanActionBatch);
        }
        //System.debug('------- commPlanFuncTestE End ------');
    }    
    @isTest static void commPlanFuncTestF(){
        //System.debug('------- commPlanFuncTestF Start ------');
        User uB = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserB@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserB@testorg.com') {
                    uB=u;
                }
            }
        }
        System.runAs(uB){
            List<Lead> myLeadList = [SELECT Id, Status, Unsuccessful_Calls__c FROM Lead WHERE OwnerID = :uB.Id];
            Lead myLead = new Lead();
            if (myLeadList.size()>0) {
                myLead = myLeadList.get(0);
            }
            myLead.LeadSource = 'Phone'; 
            myLead.Unsuccessful_Calls__c = 1;
            update myLead;
            myLead.Unsuccessful_Calls__c = 2;
            myLead.Status = 'Nurturing';
            update myLead;
            CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
            database.executeBatch(testCommunicationPlanActionBatch);
        }
        //System.debug('------- commPlanFuncTestF End ------');
    }
    @isTest static void commPlanFuncTestG(){
        //System.debug('------- commPlanFunTestG Start ------');
        User uA = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserA@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserA@testorg.com') {
                    uA=u;
                }
            }
        }
        System.runAs(uA){
            Group g2;
            List <Group> gList = new List<Group>();
            gList = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name LIKE '%Complaint%' AND QueueRoutingConfigId != null LIMIT 2];
            if (gList.size()>0) {
                if (gList.size() > 0) {
                    Integer cnt = 1;
                    for (Group g : gList) {
                        if (cnt==1) {

                        }else if (cnt==2) {
                            g2=g;
                        }
                        cnt++;
                    }
                }
            }
            List<Case> myCaseList = [SELECT Id, Status, Assigned_Date__c FROM Case WHERE OwnerID = :uA.Id];
            Case myCase = new Case();
            if (myCaseList.size()>0) {
                myCase = myCaseList.get(0);
            }
            myCase.OwnerId = g2.Id;
            myCase.Status = 'Routed';
            myCase.Assigned_Date__c = System.now();            
            update myCase;
            CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
            database.executeBatch(testCommunicationPlanActionBatch);
        } 
        //System.debug('------- commPlanFunTestG End ------');
    }
    @isTest static void commPlanFuncTestH(){
        //System.debug('------- commPlanFunTestH Start ------');
        User uB = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserB@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserB@testorg.com') {
                    uB=u;
                }
            }
        }
        System.runAs(uB){
            List<Case> myCaseList = [SELECT Id, Status, Assigned_Date__c FROM Case WHERE OwnerID = :uB.Id];
            Case myCase = new Case();
            if (myCaseList.size()>0) {
                myCase = myCaseList.get(0);
            }
            myCase.Status = 'In Progress';
            myCase.Assigned_Date__c = System.now();
            update myCase;
            CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
            database.executeBatch(testCommunicationPlanActionBatch);
        } 
        //System.debug('------- commPlanFunTestH End ------');
    }
    @isTest static void commPlanFuncTestI(){
        //System.debug('------- commPlanFunTestI Start ------');
        User adm = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserAdmin@testorg.com') {
                    adm=u;
                }
            }
        }
        System.runAs(adm){
            User uA = new User();
            Set<String> uEmails = new Set<String>();
            uEmails.add('UserA@testorg.com');
            List<User> uList = new UsersSelector().selectByEmail(uEmails);
            if (uList.size()>0) {
                for (User u : uList) {
                    if (u.Email=='UserA@testorg.com') {
                        uA=u;
                    }
                }
            }
            Case case5 = new Case();
            List<Account> accList = new AccountsSelector().selectByIdNumber('8107115017084',1);
            Id accId;
            if (accList.size()>0) {
                accId = accList.get(0).Id;
            }
            List<Case> caseList = [SELECT Id, Subject, Status, OwnerId, Assigned_Date__c FROM CASE WHERE AccountId = :accId];
            List<Case> cownUpdateList = new List<Case>();
            if (caseList.size()>0) {
                for (Case c : caseList) {
                    if (c.Subject=='Case 5') {
                        case5=c;
                        case5.OwnerID = uA.Id;
                        case5.Status = 'Assigned';
                        case5.Assigned_Date__c = System.now();
                        cownUpdateList.add(case5);
                    }
                }if (cownUpdateList.size()>0) {
                    update cownUpdateList;
                }
            }
            CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
            database.executeBatch(testCommunicationPlanActionBatch);
        }
        //System.debug('------- commPlanFunTestI End ------');
    }
    /*@isTest static void commPlanFuncTestJ(){
        //System.debug('------- commPlanFuncTestJ Start ------');
        Group g2;
        List <Group> gList = new List<Group>();
        gList = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name LIKE '%Complaint%' AND QueueRoutingConfigId != null LIMIT 2];
        if (gList.size()>0) {
            if (gList.size() > 0) {
                Integer cnt = 1;
                for (Group g : gList) {
                    if (cnt==1) {

                    }else if (cnt==2) {
                        g2=g;
                    }
                    cnt++;
                }
            }
        }
        User uB = new User();
        User uS = new User();
        User adm = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserB@testorg.com');
        userEmails.add('User@testorg.com');
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        //System.debug('------- userList : '+userList);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserB@testorg.com') {
                    uB=u;
                } else if (u.Email=='User@testorg.com') {
                    uS=u;
                } else if (u.Email=='UserAdmin@testorg.com') {
                    adm=u;
                }
            }
        }
        System.runAs(adm){
            List<Case> admList = [SELECT Id, Status, Assigned_Date__c, AccountId FROM Case WHERE OwnerID = :uB.Id];            
            //System.debug('------- admList : '+admList);
            Case admCase = new case();
            if (admList.size()>0) {
                admCase = admList.get(0);
                Account updateAcc = [SELECT Id, OwnerId FROM Account WHERE Id = :admList.get(0).AccountId] ;
                updateAcc.OwnerId = uS.Id;
                update updateAcc;
            }
            admCase.OwnerId = uS.Id;
            update admCase;
        }
        System.runAs(uS){
            List<Case> myCaseList = [SELECT Id, Status, Assigned_Date__c, AccountId FROM Case WHERE OwnerID = :uS.Id];
            //System.debug('------- myCaseList : '+myCaseList);
            Case myCase = new case();
            if (myCaseList.size()>0) {
                myCase = myCaseList.get(0);
                Account updateAcc = [SELECT Id, OwnerId, Preferred_Communication_Method__c FROM Account WHERE Id = :myCase.AccountId] ;
                updateAcc.Preferred_Communication_Method__c = 'SMS';
                update updateAcc;
            }
            List<Lead> myLeadList = [SELECT Id, Status, Unsuccessful_Calls__c FROM Lead WHERE OwnerID = :uS.Id];
            Lead myLead = new Lead();
            if (myLeadList.size()>0) {
                myLead = myLeadList.get(0);
            }
            Datetime td	= System.today();
            Datetime externalEndDate =  td.addMonths(-2);
            //System.debug('----- externalEndDate : '+externalEndDate);
            myCase.OwnerId = uS.Id;
            update myCase;
            myCase.External_SLA_End_Date__c = externalEndDate;
            myCase.Assigned_Date__c = System.now();
            update myCase;
            myCase.Status = 'In Progress';
            update myCase;
            myCase.External_SLA_End_Date__c = externalEndDate.addDays(5);
            update myCase;            
            myCase.OwnerId = g2.Id;
            update myCase;            
            myLead.LeadSource = 'Phone';                
            myLead.Successful_Calls__c = 2;
            myLead.Status = 'Unqualified';
            update myLead;        
            CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
            database.executeBatch(testCommunicationPlanActionBatch);
        } 
        //System.debug('------- commPlanFuncTestJ End ------');
    }*/
    @isTest static void commPlanFuncTestK(){
        //System.debug('------- commPlanFuncTestK Start ------');
        User uE = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserE@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserE@testorg.com') {
                    uE=u;
                }
            }
        }
        System.runAs(uE){
            List<Lead> myLeadList = [SELECT Id, Status, Unsuccessful_Calls__c FROM Lead WHERE OwnerID = :uE.Id];
            Lead myLead = new Lead();
            System.debug('------- myLeadList : '+myLeadList);
            if (myLeadList.size()>0) {
                myLead = myLeadList.get(0);
                myLead.LeadSource = 'Phone'; 
                myLead.Unsuccessful_Calls__c = 1;
                update myLead;
                myLead.Unsuccessful_Calls__c = 2;
                myLead.Status = 'Nurturing';
                update myLead;
                CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
                database.executeBatch(testCommunicationPlanActionBatch);
            }
        }
        //System.debug('------- commPlanFuncTestK End ------');
    }
    @isTest static void commPlanFuncTestL(){
        //System.debug('------- commPlanFuncTestL Start ------');
        User uE = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserE@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserE@testorg.com') {
                    uE=u;
                }
            }
        }
        System.runAs(uE){
            List<Lead> myLeadList = [SELECT Id, Status, Unsuccessful_Calls__c FROM Lead WHERE OwnerID = :uE.Id];
            Lead myLead = new Lead();
            if (myLeadList.size()>0) {
                myLead = myLeadList.get(0);
                myLead.Unsuccessful_Calls__c = 4;
                myLead.Status = 'Abandoned';
                update myLead;  
                CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
                database.executeBatch(testCommunicationPlanActionBatch);
            }
        } 
        //System.debug('------- commPlanFuncTestL End ------');
    }
    @isTest static void commPlanFuncTestM(){
        //System.debug('------- commPlanFuncTestM Start ------');
        User uE = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserE@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        //System.debug('------- userList : '+userList);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='UserE@testorg.com') {
                    uE=u;
                }
            }
        }
        System.runAs(uE){
            List<Site__c> siteList = [SELECT Id FROM Site__c Limit 1];
            Id siteId;
            if (siteList.size()>0) {
                siteId = siteList.get(0).Id;
            }
            List<Case> myCaseList = [SELECT Id, Status, Responsible_Site__c ,Resolved_in_Favour_of__c, Out_Of_SLA_Reason__c,Trade_Loss__c, 
            Summary_of_Resolution__c, Where_Did_This_Happen__c,Who_Caused_It__c,Out_Of_SLA_Comments__c, Case_Ownership__c, 
            Bypass_Validation_Rules__c, AccountId, Communication_Method__c FROM Case WHERE OwnerID = :uE.Id];
            //System.debug('------- myCaseList : '+myCaseList);
            Case myCase = new case();
            if (myCaseList.size()>0) {
                myCase = myCaseList.get(0);
                System.debug('------- myCase : '+myCase);
                if (myCase.Case_Ownership__c!='FPOC') { 
                    myCase.Bypass_Validation_Rules__c = true ;
                }
                myCase.Responsible_Site__c = siteId;
                myCase.Resolved_in_Favour_of__c = 'Bank';
                myCase.Out_Of_SLA_Reason__c = 'Account Closed';
                myCase.Trade_Loss__c = 'No';
                myCase.Summary_of_Resolution__c = 'Test';
                myCase.Where_Did_This_Happen__c = 'Test';
                myCase.Who_Caused_It__c = 'Test';
                myCase.Out_Of_SLA_Comments__c = 'Test';
                myCase.Status = 'Resolved';
                update myCase;
            }       
            CommunicationPlanActionBatch testCommunicationPlanActionBatch = new CommunicationPlanActionBatch();
            database.executeBatch(testCommunicationPlanActionBatch);
        } 
        //System.debug('------- commPlanFuncTestM End ------');
    }
    @isTest static void createApplRelatedTasks1(){
        sd_Communication_Plan__c commPlanCase = new sd_Communication_Plan__c(Name='Application Plan');
        insert commPlanCase;


        EmailTemplate e = new EmailTemplate();
        User runningUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( runningUser ) {
            
            e.developerName = 'test';
            e.TemplateType= 'Text';
            e.Name = 'test'; 
            e.isActive = true;
            e.FolderId = UserInfo.getUserId();
            insert e;
        }
        
        sd_Communication_Rule__c newrule = new sd_Communication_Rule__c();
        newrule.sd_Communication_Plan__c = commPlanCase.Id;
        newrule.sd_Action__c = 'Email';
        newrule.sd_Before_After__c = 'Before';
        newrule.sd_Rule_Description__c = 'Account Not Activated 7 days';
        newrule.sd_When_to_Trigger__c = 'Immediate';
        newrule.sd_Email_Template_Id__c = e.Id;
		newrule.sd_Email_Template_Id_AFR__c = e.Id;
		newrule.sd_SMS_Template_Id__c = e.Id;
		newrule.sd_SMS_Template_Id_AFR__c = e.Id;
        newrule.sd_Object__c = 'Application';
        newrule.sd_Email_Field__c = 'Owner Email';
        newrule.sd_SMS_Field__c ='Owner Mobile';
        newrule.sd_Action__c = 'Email';
        newrule.sd_Trigger_Condition__c = 'Account Not Activated 7 days';

        insert newrule;
        
        Application__c app= new Application__c();
        app.All_transaction_type__c = '';
        app.Payment__c = '';
        app.Withdrawal__c = '';
        app.Deposit__c = '';
        app.Returned_Transactions__c = '';
        app.Scheduled_transaction__c = '';
        app.Notification_time__c = Date.today();
        app.Minimum_amount__c = '';
        app.Account_to_be_debited_monthly_with_the_c__c = '';
        app.Number_of_authorisations_that_will_be_re__c = '';
        app.Number_of_main_users__c = '';
        app.Fee_Structure_code__c = '';   
        app.Absa_online_for_business_BIB__c = '';
        app.Cell_phone_banking__c = '';
        app.Telephone_banking__c = '';
        app.Notifyme__c = '';
        app.Funds_transfer__c = '';
        app.Bill_payments__c = '';                                           
        app.Own_defined_payments__c = '';
        app.Future_dated_payments__c = '';
        app.Stop_order_payments__c = '';
        //app.Transactional_Account__c = 'Franchise';
        app.Account_Access__c = 'Cellphone';
        app.Foreign_Services__c = 'Currency Swap (Hedging Instruments);Trade Finance Products';
        app.Surplus_Cash__c = 'Fixed Deposits';   
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Borrowing_requiment_Assest_Acquisition__c = 'Business-Backed Property Finance;Commercial Property Finance';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'dd';                                           
        app.FirstNameSignature__c = 'Litha';
        app.SurnameSignature__c = 'Nosekeleza';
        app.Signing_Date__c = System.today();  
        app.sd_Communication_Plan_Id__c = commPlanCase.Id;
        app.Account_Number__c = '123456789';
        //app.Number_of_days_account_has_not_activated__c = 7;
        insert app;
        
        Task task = new Task();
        task.Subject = 'Test Task';
        task.WhatId = app.Id;
        task.Communication_Rule_Id__c = newrule.Id;
        
        Insert task;
        
        test.startTest();
        CommunicationPlanFunctions.createApplRelatedTasks(new List<Application__c>{app},null);
        CommunicationPlanFunctions.actionTasks(new List<Task>{task});
       // CommunicationPlanFunctions.evaluateApplRelatedTasks(new List<Task>{task});  //emailAction
        test.stopTest();
    }
    @isTest static void createApplRelatedTasks2(){
        sd_Communication_Plan__c commPlanCase = new sd_Communication_Plan__c(Name='Application Plan');
        insert commPlanCase;


        EmailTemplate e = new EmailTemplate();
        User runningUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( runningUser ) {
            
            e.developerName = 'test';
            e.TemplateType= 'Text';
            e.Name = 'test'; 
            e.isActive = true;
            e.FolderId = UserInfo.getUserId();
            insert e;
        }
        
        sd_Communication_Rule__c newrule = new sd_Communication_Rule__c();
        newrule.sd_Communication_Plan__c = commPlanCase.Id;
        newrule.sd_Action__c = 'Email';
        newrule.sd_Before_After__c = 'Before';
        newrule.sd_Rule_Description__c = 'Account Not Activated 14 days';
        newrule.sd_When_to_Trigger__c = 'Immediate';
        newrule.sd_Email_Template_Id__c = e.Id;
		newrule.sd_Email_Template_Id_AFR__c = e.Id;
		newrule.sd_SMS_Template_Id__c = e.Id;
		newrule.sd_SMS_Template_Id_AFR__c = e.Id;
        newrule.sd_Object__c = 'Application';
        newrule.sd_Email_Field__c = 'Owner Email';
        newrule.sd_SMS_Field__c ='Owner Mobile';
        newrule.sd_Action__c = 'Email';
        newrule.sd_Trigger_Condition__c = 'Account Not Activated 14 days';

        insert newrule;
        
        Application__c app= new Application__c();
        app.All_transaction_type__c = '';
        app.Payment__c = '';
        app.Withdrawal__c = '';
        app.Deposit__c = '';
        app.Returned_Transactions__c = '';
        app.Scheduled_transaction__c = '';
        app.Notification_time__c = Date.today();
        app.Minimum_amount__c = '';
        app.Account_to_be_debited_monthly_with_the_c__c = '';
        app.Number_of_authorisations_that_will_be_re__c = '';
        app.Number_of_main_users__c = '';
        app.Fee_Structure_code__c = '';   
        app.Absa_online_for_business_BIB__c = '';
        app.Cell_phone_banking__c = '';
        app.Telephone_banking__c = '';
        app.Notifyme__c = '';
        app.Funds_transfer__c = '';
        app.Bill_payments__c = '';                                           
        app.Own_defined_payments__c = '';
        app.Future_dated_payments__c = '';
        app.Stop_order_payments__c = '';
        //app.Transactional_Account__c = 'Franchise';
        app.Account_Access__c = 'Cellphone';
        app.Foreign_Services__c = 'Currency Swap (Hedging Instruments);Trade Finance Products';
        app.Surplus_Cash__c = 'Fixed Deposits';   
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Borrowing_requiment_Assest_Acquisition__c = 'Business-Backed Property Finance;Commercial Property Finance';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'dd';                                           
        app.FirstNameSignature__c = 'Litha';
        app.SurnameSignature__c = 'Nosekeleza';
        app.Signing_Date__c = System.today();  
        app.sd_Communication_Plan_Id__c = commPlanCase.Id;
        app.Account_Number__c = '123456789';
        //app.Number_of_days_account_has_not_activated__c = 14;
        insert app;
        
        Task task = new Task();
        task.Subject = 'Test Task';
        task.WhatId = app.Id;
        task.Communication_Rule_Id__c = newrule.Id;
        
        Insert task;
        
        test.startTest();
        CommunicationPlanFunctions.createApplRelatedTasks(new List<Application__c>{app},null);
        CommunicationPlanFunctions.actionTasks(new List<Task>{task});
       // CommunicationPlanFunctions.evaluateApplRelatedTasks(new List<Task>{task});  //emailAction
        test.stopTest();
    }
    @isTest static void createApplRelatedTasks3(){
        sd_Communication_Plan__c commPlanCase = new sd_Communication_Plan__c(Name='Application Plan');
        insert commPlanCase;


        EmailTemplate e = new EmailTemplate();
        User runningUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( runningUser ) {
            
            e.developerName = 'test';
            e.TemplateType= 'Text';
            e.Name = 'test'; 
            e.isActive = true;
            e.FolderId = UserInfo.getUserId();
            insert e;
        }
        
        sd_Communication_Rule__c newrule = new sd_Communication_Rule__c();
        newrule.sd_Communication_Plan__c = commPlanCase.Id;
        newrule.sd_Action__c = 'Email';
        newrule.sd_Before_After__c = 'Before';
        newrule.sd_Rule_Description__c = 'Account Not Activated 75 days';
        newrule.sd_When_to_Trigger__c = 'Immediate';
        newrule.sd_Email_Template_Id__c = e.Id;
		newrule.sd_Email_Template_Id_AFR__c = e.Id;
		newrule.sd_SMS_Template_Id__c = e.Id;
		newrule.sd_SMS_Template_Id_AFR__c = e.Id;
        newrule.sd_Object__c = 'Application';
        newrule.sd_Email_Field__c = 'Owner Email';
        newrule.sd_SMS_Field__c ='Owner Mobile';
        newrule.sd_Action__c = 'Email';
        newrule.sd_Trigger_Condition__c = 'Account Not Activated 75 days';

        insert newrule;
        
        Application__c app= new Application__c();
        app.All_transaction_type__c = '';
        app.Payment__c = '';
        app.Withdrawal__c = '';
        app.Deposit__c = '';
        app.Returned_Transactions__c = '';
        app.Scheduled_transaction__c = '';
        app.Notification_time__c = Date.today();
        app.Minimum_amount__c = '';
        app.Account_to_be_debited_monthly_with_the_c__c = '';
        app.Number_of_authorisations_that_will_be_re__c = '';
        app.Number_of_main_users__c = '';
        app.Fee_Structure_code__c = '';   
        app.Absa_online_for_business_BIB__c = '';
        app.Cell_phone_banking__c = '';
        app.Telephone_banking__c = '';
        app.Notifyme__c = '';
        app.Funds_transfer__c = '';
        app.Bill_payments__c = '';                                           
        app.Own_defined_payments__c = '';
        app.Future_dated_payments__c = '';
        app.Stop_order_payments__c = '';
        //app.Transactional_Account__c = 'Franchise';
        app.Account_Access__c = 'Cellphone';
        app.Foreign_Services__c = 'Currency Swap (Hedging Instruments);Trade Finance Products';
        app.Surplus_Cash__c = 'Fixed Deposits';   
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Borrowing_requiment_Assest_Acquisition__c = 'Business-Backed Property Finance;Commercial Property Finance';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'dd';                                           
        app.FirstNameSignature__c = 'Litha';
        app.SurnameSignature__c = 'Nosekeleza';
        app.Signing_Date__c = System.today();  
        app.sd_Communication_Plan_Id__c = commPlanCase.Id;
        app.Account_Number__c = '123456789';
        //app.Number_of_days_account_has_not_activated__c = 75;
        insert app;
        
        Task task = new Task();
        task.Subject = 'Test Task';
        task.WhatId = app.Id;
        task.Communication_Rule_Id__c = newrule.Id;
        
        Insert task;
        
        test.startTest();
        CommunicationPlanFunctions.createApplRelatedTasks(new List<Application__c>{app},null);
        CommunicationPlanFunctions.actionTasks(new List<Task>{task});
       // CommunicationPlanFunctions.evaluateApplRelatedTasks(new List<Task>{task});  //emailAction
        test.stopTest();
    }
     @isTest static void createApplRelatedTasks4(){
        sd_Communication_Plan__c commPlanCase = new sd_Communication_Plan__c(Name='Application Plan');
        insert commPlanCase;


        EmailTemplate e = new EmailTemplate();
        User runningUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( runningUser ) {
            
            e.developerName = 'test';
            e.TemplateType= 'Text';
            e.Name = 'test'; 
            e.isActive = true;
            e.FolderId = UserInfo.getUserId();
            insert e;
        }
        
        sd_Communication_Rule__c newrule = new sd_Communication_Rule__c();
        newrule.sd_Communication_Plan__c = commPlanCase.Id;
        newrule.sd_Action__c = 'Email';
        newrule.sd_Before_After__c = 'Before';
        newrule.sd_Rule_Description__c = 'Account Not Activated 45 days';
        newrule.sd_When_to_Trigger__c = 'Immediate';
        newrule.sd_Email_Template_Id__c = e.Id;
		newrule.sd_Email_Template_Id_AFR__c = e.Id;
		newrule.sd_SMS_Template_Id__c = e.Id;
		newrule.sd_SMS_Template_Id_AFR__c = e.Id;
        newrule.sd_Object__c = 'Application';
        newrule.sd_Email_Field__c = 'Owner Email';
        newrule.sd_SMS_Field__c ='Owner Mobile';
        newrule.sd_Action__c = 'Email';
        newrule.sd_Trigger_Condition__c = 'Account Not Activated 45 days';

        insert newrule;
        
        Application__c app= new Application__c();
        app.All_transaction_type__c = '';
        app.Payment__c = '';
        app.Withdrawal__c = '';
        app.Deposit__c = '';
        app.Returned_Transactions__c = '';
        app.Scheduled_transaction__c = '';
        app.Notification_time__c = Date.today();
        app.Minimum_amount__c = '';
        app.Account_to_be_debited_monthly_with_the_c__c = '';
        app.Number_of_authorisations_that_will_be_re__c = '';
        app.Number_of_main_users__c = '';
        app.Fee_Structure_code__c = '';   
        app.Absa_online_for_business_BIB__c = '';
        app.Cell_phone_banking__c = '';
        app.Telephone_banking__c = '';
        app.Notifyme__c = '';
        app.Funds_transfer__c = '';
        app.Bill_payments__c = '';                                           
        app.Own_defined_payments__c = '';
        app.Future_dated_payments__c = '';
        app.Stop_order_payments__c = '';
        //app.Transactional_Account__c = 'Franchise';
        app.Account_Access__c = 'Cellphone';
        app.Foreign_Services__c = 'Currency Swap (Hedging Instruments);Trade Finance Products';
        app.Surplus_Cash__c = 'Fixed Deposits';   
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Borrowing_requiment_Assest_Acquisition__c = 'Business-Backed Property Finance;Commercial Property Finance';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'dd';                                           
        app.FirstNameSignature__c = 'Litha';
        app.SurnameSignature__c = 'Nosekeleza';
        app.Signing_Date__c = System.today();  
        app.sd_Communication_Plan_Id__c = commPlanCase.Id;
        app.Account_Number__c = '123456789';
        //app.Number_of_days_account_has_not_activated__c = 45;
        insert app;
        
        Task task = new Task();
        task.Subject = 'Test Task';
        task.WhatId = app.Id;
        task.Communication_Rule_Id__c = newrule.Id;
        
        Insert task;
        
        test.startTest();
        CommunicationPlanFunctions.createApplRelatedTasks(new List<Application__c>{app},null);
        CommunicationPlanFunctions.actionTasks(new List<Task>{task});
       // CommunicationPlanFunctions.evaluateApplRelatedTasks(new List<Task>{task});  //emailAction
        test.stopTest();
    }
     @isTest static void createApplRelatedTasks5(){
        sd_Communication_Plan__c commPlanCase = new sd_Communication_Plan__c(Name='Application Plan');
        insert commPlanCase;


        EmailTemplate e = new EmailTemplate();
        User runningUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( runningUser ) {
            
            e.developerName = 'test';
            e.TemplateType= 'Text';
            e.Name = 'test'; 
            e.isActive = true;
            e.FolderId = UserInfo.getUserId();
            insert e;
        }
        
        sd_Communication_Rule__c newrule = new sd_Communication_Rule__c();
        newrule.sd_Communication_Plan__c = commPlanCase.Id;
        newrule.sd_Action__c = 'Email';
        newrule.sd_Before_After__c = 'Before';
        newrule.sd_Rule_Description__c = 'Welcome Letter Day 7';
        newrule.sd_When_to_Trigger__c = 'Immediate';
        newrule.sd_Email_Template_Id__c = e.Id;
		newrule.sd_Email_Template_Id_AFR__c = e.Id;
		newrule.sd_SMS_Template_Id__c = e.Id;
		newrule.sd_SMS_Template_Id_AFR__c = e.Id;
        newrule.sd_Object__c = 'Application';
        newrule.sd_Email_Field__c = 'Owner Email';
        newrule.sd_SMS_Field__c ='Owner Mobile';
        newrule.sd_Action__c = 'Email';
        newrule.sd_Trigger_Condition__c = 'Welcome Letter Day 7';

        insert newrule;
        
        Application__c app= new Application__c();
        app.All_transaction_type__c = '';
        app.Payment__c = '';
        app.Withdrawal__c = '';
        app.Deposit__c = '';
        app.Returned_Transactions__c = '';
        app.Scheduled_transaction__c = '';
        app.Notification_time__c = Date.today();
        app.Minimum_amount__c = '';
        app.Account_to_be_debited_monthly_with_the_c__c = '';
        app.Number_of_authorisations_that_will_be_re__c = '';
        app.Number_of_main_users__c = '';
        app.Fee_Structure_code__c = '';   
        app.Absa_online_for_business_BIB__c = '';
        app.Cell_phone_banking__c = '';
        app.Telephone_banking__c = '';
        app.Notifyme__c = '';
        app.Funds_transfer__c = '';
        app.Bill_payments__c = '';                                           
        app.Own_defined_payments__c = '';
        app.Future_dated_payments__c = '';
        app.Stop_order_payments__c = '';
        //app.Transactional_Account__c = 'Franchise';
        app.Account_Access__c = 'Cellphone';
        app.Foreign_Services__c = 'Currency Swap (Hedging Instruments);Trade Finance Products';
        app.Surplus_Cash__c = 'Fixed Deposits';   
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Borrowing_requiment_Assest_Acquisition__c = 'Business-Backed Property Finance;Commercial Property Finance';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'dd';                                           
        app.FirstNameSignature__c = 'Litha';
        app.SurnameSignature__c = 'Nosekeleza';
        app.Signing_Date__c = System.today();  
        app.sd_Communication_Plan_Id__c = commPlanCase.Id;
        app.Account_Number__c = '123456789';
        //app.Number_of_days_account_has_not_activated__c = 45;
        insert app;
        
        Task task = new Task();
        task.Subject = 'Test Task';
        task.WhatId = app.Id;
        task.Communication_Rule_Id__c = newrule.Id;
        
        Insert task;
        
        test.startTest();
        CommunicationPlanFunctions.createApplRelatedTasks(new List<Application__c>{app},null);
        CommunicationPlanFunctions.actionTasks(new List<Task>{task});
       // CommunicationPlanFunctions.evaluateApplRelatedTasks(new List<Task>{task});  //emailAction
        test.stopTest();
    }
    @isTest static void createApplRelatedTasks6(){
        sd_Communication_Plan__c commPlanCase = new sd_Communication_Plan__c(Name='Application Plan');
        insert commPlanCase;


        EmailTemplate e = new EmailTemplate();
        User runningUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( runningUser ) {
            
            e.developerName = 'test';
            e.TemplateType= 'Text';
            e.Name = 'test'; 
            e.isActive = true;
            e.FolderId = UserInfo.getUserId();
            insert e;
        }
        
        sd_Communication_Rule__c newrule = new sd_Communication_Rule__c();
        newrule.sd_Communication_Plan__c = commPlanCase.Id;
        newrule.sd_Action__c = 'Email';
        newrule.sd_Before_After__c = 'Before';
        newrule.sd_Rule_Description__c = 'No Transactional Activity';
        newrule.sd_When_to_Trigger__c = 'Immediate';
        newrule.sd_Email_Template_Id__c = e.Id;
		newrule.sd_Email_Template_Id_AFR__c = e.Id;
		newrule.sd_SMS_Template_Id__c = e.Id;
		newrule.sd_SMS_Template_Id_AFR__c = e.Id;
        newrule.sd_Object__c = 'Application';
        newrule.sd_Email_Field__c = 'Owner Email';
        newrule.sd_SMS_Field__c ='Owner Mobile';
        newrule.sd_Action__c = 'Email';
        newrule.sd_Trigger_Condition__c = 'No Transactional Activity';

        insert newrule;
        
        Application__c app= new Application__c();
        app.All_transaction_type__c = '';
        app.Payment__c = '';
        app.Withdrawal__c = '';
        app.Deposit__c = '';
        app.Returned_Transactions__c = '';
        app.Scheduled_transaction__c = '';
        app.Notification_time__c = Date.today();
        app.Minimum_amount__c = '';
        app.Account_to_be_debited_monthly_with_the_c__c = '';
        app.Number_of_authorisations_that_will_be_re__c = '';
        app.Number_of_main_users__c = '';
        app.Fee_Structure_code__c = '';   
        app.Absa_online_for_business_BIB__c = '';
        app.Cell_phone_banking__c = '';
        app.Telephone_banking__c = '';
        app.Notifyme__c = '';
        app.Funds_transfer__c = '';
        app.Bill_payments__c = '';                                           
        app.Own_defined_payments__c = '';
        app.Future_dated_payments__c = '';
        app.Stop_order_payments__c = '';
        //app.Transactional_Account__c = 'Franchise';
        app.Account_Access__c = 'Cellphone';
        app.Foreign_Services__c = 'Currency Swap (Hedging Instruments);Trade Finance Products';
        app.Surplus_Cash__c = 'Fixed Deposits';   
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Borrowing_requiment_Assest_Acquisition__c = 'Business-Backed Property Finance;Commercial Property Finance';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'dd';                                           
        app.FirstNameSignature__c = 'Litha';
        app.SurnameSignature__c = 'Nosekeleza';
        app.Signing_Date__c = System.today();  
        app.sd_Communication_Plan_Id__c = commPlanCase.Id;
        app.Account_Number__c = '123456789';
        //app.Number_of_days_account_has_not_activated__c = 45;
        insert app;
        
        Task task = new Task();
        task.Subject = 'Test Task';
        task.WhatId = app.Id;
        task.Communication_Rule_Id__c = newrule.Id;
        
        Insert task;
        
        test.startTest();
        CommunicationPlanFunctions.createApplRelatedTasks(new List<Application__c>{app},null);
        CommunicationPlanFunctions.actionTasks(new List<Task>{task});
       // CommunicationPlanFunctions.evaluateApplRelatedTasks(new List<Task>{task});  //emailAction
        test.stopTest();
    }
    @isTest static void createApplRelatedTasks7(){
        sd_Communication_Plan__c commPlanCase = new sd_Communication_Plan__c(Name='Application Plan');
        insert commPlanCase;


        EmailTemplate e = new EmailTemplate();
        User runningUser = [ Select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( runningUser ) {
            
            e.developerName = 'test';
            e.TemplateType= 'Text';
            e.Name = 'test'; 
            e.isActive = true;
            e.FolderId = UserInfo.getUserId();
            insert e;
        }
        
        sd_Communication_Rule__c newrule = new sd_Communication_Rule__c();
        newrule.sd_Communication_Plan__c = commPlanCase.Id;
        newrule.sd_Action__c = 'Email';
        newrule.sd_Before_After__c = 'Before';
        newrule.sd_Rule_Description__c = 'Welcome Letter';
        newrule.sd_When_to_Trigger__c = 'Immediate';
        newrule.sd_Email_Template_Id__c = e.Id;
		newrule.sd_Email_Template_Id_AFR__c = e.Id;
		newrule.sd_SMS_Template_Id__c = e.Id;
		newrule.sd_SMS_Template_Id_AFR__c = e.Id;
        newrule.sd_Object__c = 'Application';
        newrule.sd_Email_Field__c = 'Owner Email';
        newrule.sd_SMS_Field__c ='Owner Mobile';
        newrule.sd_Action__c = 'Email';
        newrule.sd_Trigger_Condition__c = 'Welcome Letter';

        insert newrule;
        
        Application__c app= new Application__c();
        app.All_transaction_type__c = '';
        app.Payment__c = '';
        app.Withdrawal__c = '';
        app.Deposit__c = '';
        app.Returned_Transactions__c = '';
        app.Scheduled_transaction__c = '';
        app.Notification_time__c = Date.today();
        app.Minimum_amount__c = '';
        app.Account_to_be_debited_monthly_with_the_c__c = '';
        app.Number_of_authorisations_that_will_be_re__c = '';
        app.Number_of_main_users__c = '';
        app.Fee_Structure_code__c = '';   
        app.Absa_online_for_business_BIB__c = '';
        app.Cell_phone_banking__c = '';
        app.Telephone_banking__c = '';
        app.Notifyme__c = '';
        app.Funds_transfer__c = '';
        app.Bill_payments__c = '';                                           
        app.Own_defined_payments__c = '';
        app.Future_dated_payments__c = '';
        app.Stop_order_payments__c = '';
        //app.Transactional_Account__c = 'Franchise';
        app.Account_Access__c = 'Cellphone';
        app.Foreign_Services__c = 'Currency Swap (Hedging Instruments);Trade Finance Products';
        app.Surplus_Cash__c = 'Fixed Deposits';   
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Borrowing_requiment_Assest_Acquisition__c = 'Business-Backed Property Finance;Commercial Property Finance';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'dd';                                           
        app.FirstNameSignature__c = 'Litha';
        app.SurnameSignature__c = 'Nosekeleza';
        app.Signing_Date__c = System.today();  
        app.sd_Communication_Plan_Id__c = commPlanCase.Id;
        app.Account_Number__c = '123456789';
        //app.Number_of_days_account_has_not_activated__c = 45;
        insert app;
        
        Task task = new Task();
        task.Subject = 'Test Task';
        task.WhatId = app.Id;
        task.Communication_Rule_Id__c = newrule.Id;
        
        Insert task;
        
        test.startTest();
        CommunicationPlanFunctions.createApplRelatedTasks(new List<Application__c>{app},null);
        CommunicationPlanFunctions.actionTasks(new List<Task>{task});
       // CommunicationPlanFunctions.evaluateApplRelatedTasks(new List<Task>{task});  //emailAction
        test.stopTest();
    }
}