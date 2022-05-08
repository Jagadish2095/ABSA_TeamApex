//**********************************************************************************
//
//            Copyright 2016 Enghouse Interactive. All rights reserved
//
// The source code contained or described herein and all documents related to the
// source code ("Material") are owned by Enghouse Interactive or its suppliers or
// licensors.  Title to the Material remains with Enghouse Interactive or its
// suppliers and licensors.  The Material contains trade secrets and proprietary
// and confidential information of Enghouse or its suppliers and licensors.  The
// Material is protected by worldwide copyright and trade secret laws and treaty
// provisions. No part of the Material may be used, copied, reproduced, modified,
// published, uploaded, posted, transmitted, distributed, or disclosed in any way
// without Enghouse's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials,  either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be express
// and approved by Enghouse in writing.
//
//**********************************************************************************

//
// Modification History
//
// 3.004    Philip Simons   4-Sep-2015
// Inititial Test version
//
// 3.008    Philip Simons   20-Sep-2015
//
//
// 3.100 Mazhar Nazeer 28-Nov-2017
// Class Name is updated with 100. This should be incremented for every version release.
//

@isTest
public class AccountRetrievalTest100{    
    static testMethod void getCallerAccount() {
        Account a = new Account(Name='My AccountCC',Phone='87837743123456789');
        insert a;
        
        Id [] fixedSearchResults= new Id[1]; 
        fixedSearchResults[0] = a.Id; 
        Test.setFixedSearchResults(fixedSearchResults); 
        
        String jsonInp = AccountRetrieval100.getCaller('87837743123456789');

        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);
        System.assertEquals(4,allInfo.size());
        List<Object> accountInfos=(List<Object>)allInfo[0];
        System.assertEquals(1,accountInfos.size());
        
        Map<String,Object> info = (Map<String,Object>)accountInfos[0];
        System.assertEquals('My AccountCC',info.get('Name'));
    }
    static testMethod void getCallerMulti() {
        Account a = new Account(Name='My AccountCX',Phone='87837743123456789');
        insert a;
        
        Contact c = new Contact(Title='My ContactDX',Phone='87837743123456789',LastName='ContactDX');
        insert c;
        
        Id [] fixedSearchResults= new Id[2]; 
        fixedSearchResults[0] = a.Id; 
        fixedSearchResults[1] = c.Id; 
        Test.setFixedSearchResults(fixedSearchResults); 
        
        String jsonInp = AccountRetrieval100.getCaller('87837743123456789');
 
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);
        System.assertEquals(4,allInfo.size());
        
        List<Object> accountInfos=(List<Object>)allInfo[0];
        System.assertEquals(1,accountInfos.size());
        
        Map<String,Object> info = (Map<String,Object>)accountInfos[0];
        System.assertEquals('My AccountCX',info.get('Name'));
        
        List<Object> caseInfos=(List<Object>)allInfo[1];
        System.assertEquals(0,caseInfos.size());

        List<Object> contactInfos=(List<Object>)allInfo[2];
        System.assertEquals(1,contactInfos.size());

        Map<String,Object> info2 = (Map<String,Object>)contactInfos[0];
        System.assertEquals('My ContactDX',info2.get('Title'));
        
        List<Object> leadInfos=(List<Object>)allInfo[1];
        System.assertEquals(0,leadInfos.size());
    }   
    static testMethod void adhocQuery() {
        Account a = new Account(Name='My AccountXZ',Phone='87837743123456789');
        insert a;

        Id [] fixedSearchResults= new Id[1]; 
        fixedSearchResults[0] = a.Id; 
        Test.setFixedSearchResults(fixedSearchResults); 

        String jsonInp = AccountRetrieval100.adhocQuery('FIND \'87837743123456789\' IN PHONE FIELDS RETURNING ACCOUNT(Type,AccountNumber,Name,Id)');
        
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);
        System.assertEquals(1,allInfo.size());
        List<Object> accountInfos=(List<Object>)allInfo[0];
        System.assertEquals(1,accountInfos.size());
        
        Map<String,Object> info = (Map<String,Object>)accountInfos[0];
        System.assertEquals('My AccountXZ',info.get('Name'));
    }
    
    static testMethod void objectQueryAccount()
    {
        Account a = new Account(Name='My AccountXX',Phone='87837743123456786');
        insert a;
        
         Id [] fixedSearchResults= new Id[1]; 
        fixedSearchResults[0] = a.Id; 
        Test.setFixedSearchResults(fixedSearchResults); 
            
        List<String> strArr=new List<String>();
        strArr.add('IQ\tAccount.Phone=87837743123456786');     
        String jsonInp = AccountRetrieval100.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(4,allInfo.size());
        List<Object> accountInfos=(List<Object>)allInfo[0];
        System.assertEquals(1,accountInfos.size());
        
        Map<String,Object> info = (Map<String,Object>)accountInfos[0];
        System.assertEquals('My AccountXX',info.get('Name'));
    }
    static testMethod void objectQueryAccount2()
    {
        Account a = new Account(Name='My AccountCC',Phone='77837743123456787');
        insert a;
     
        Id [] fixedSearchResults= new Id[1]; 
        fixedSearchResults[0] = a.Id; 
        Test.setFixedSearchResults(fixedSearchResults); 
        
        List<String> strArr=new List<String>();
        strArr.add('IQ\tAccount.Phone=87837743123995677');
        strArr.add('IQ\tAccount.NumberOfEmployees=45');
    
        String jsonInp = AccountRetrieval100.objectQuery('77837743123456787',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(4,allInfo.size());
        List<Object> accountInfos=(List<Object>)allInfo[0];
        System.assertEquals(1,accountInfos.size());
        
        Map<String,Object> info = (Map<String,Object>)accountInfos[0];
        
        System.assertEquals(a.Id,info.get('Id'));
    }
    static testMethod void objectQueryAccount3()
    {
        Account a = new Account(Name='My AccountCC',Phone='99837743123456787');
        insert a;
     
        Id [] fixedSearchResults= new Id[1]; 
        fixedSearchResults[0] = a.Id; 
        Test.setFixedSearchResults(fixedSearchResults); 
        
        List<String> strArr=new List<String>();
        strArr.add('OA=99837743123456787');
    
        String jsonInp = AccountRetrieval100.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(4,allInfo.size());
        List<Object> accountInfos=(List<Object>)allInfo[0];
        System.assertEquals(1,accountInfos.size());
        
        Map<String,Object> info = (Map<String,Object>)accountInfos[0];
        
        System.assertEquals(a.Id,info.get('Id'));
    }
    static testMethod void objectQueryCase()
    {
        Contact con = new Contact(Title='My ContactEX',Phone='87837743123456769',LastName='ContactDX');
        insert con;
        Case c = new Case(Description='My Case',SuppliedPhone='87837743123456780');
        insert c;        
        Id [] fixedSearchResults= new Id[1]; 
        fixedSearchResults[0] = c.Id; 
        Test.setFixedSearchResults(fixedSearchResults);          
        List<String> strArr=new List<String>();
        strArr.add('IQ\tCase.SuppliedPhone=87837743123456780');   
        String jsonInp = AccountRetrieval100.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);
        System.assertEquals(4,allInfo.size());
        List<Object> caseInfos=(List<Object>)allInfo[1];
        System.assertEquals(1,caseInfos.size());        
        Map<String,Object> info = (Map<String,Object>)caseInfos[0];        
        System.assertEquals(c.Id,info.get('Id'));
    }
    static testMethod void objectQueryCase2()
    {
        Contact con = new Contact(Title='My ContactEX',Phone='87837743123456769',LastName='ContactDX');
        insert con;
        Case c = new Case(Priority='1');
        insert c;
        Case c2 = new Case(Priority='2');
        insert c2;
        Case c3 = new Case(Priority='0');
        insert c3;   
        Id [] fixedSearchResults= new Id[3]; 
        fixedSearchResults[0] = c.Id; 
        fixedSearchResults[1] = c2.Id; 
        fixedSearchResults[2] = c3.Id; 
        Test.setFixedSearchResults(fixedSearchResults);             
        List<String> strArr=new List<String>();
        c= [select id, casenumber from case where id = : c.id];
        strArr.add('IQ\tCase.CaseNumber='+c.CaseNumber);
        strArr.add('IQ\tCase.Priority=1');   
        String jsonInp = AccountRetrieval100.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);
        System.assertEquals(4,allInfo.size());
        List<Object> caseInfos=(List<Object>)allInfo[1];
        System.assertEquals(1,caseInfos.size());        
        Map<String,Object> info = (Map<String,Object>)caseInfos[0];        
        System.assertEquals(c.Id,info.get('Id'));
    }
    static testMethod void objectQueryCase3()
    {
        Contact con = new Contact(Title='My ContactEX',Phone='87837743123456769',LastName='ContactDX');
        insert con;
        Case c = new Case(Priority='1');
        insert c;     
        Id [] fixedSearchResults= new Id[1]; 
        fixedSearchResults[0] = c.Id; 
        Test.setFixedSearchResults(fixedSearchResults);               
        List<String> strArr=new List<String>();
        c= [select id, casenumber from case where id = : c.id];
        strArr.add('IQ\tCase.CaseNumber='+c.CaseNumber);   
        String jsonInp = AccountRetrieval100.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);
        System.assertEquals(4,allInfo.size());
        List<Object> caseInfos=(List<Object>)allInfo[1];
        System.assertEquals(1,caseInfos.size());
    } 
    static testMethod void objectQueryLead()
    {
 		// Start: Modified original code to accommodate Absa customizations of Lead
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id recTypeId = rtInfo.get('Business_Bank_Lead').getRecordTypeId();        
        Financial_Product__c newProd = new Financial_Product__c(
            Name = 'BB - Borrow - Loans - Business Term Loan',
            Description__c = 'test product', 
            Product__c = 'Borrow', 
            Sub_Product__c = 'Business Term Loan', 
            Product_Type__c = 'Borrow',
            Business_Unit__c = 'Business Banking'
        );
        insert newProd;

        Lead l = new Lead(Description='My Lead',Company='Company1',
                          Status='Assigned',FirstName='Test',LastName='Lead',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert l;
 		// End: Modified original code to accommodate Absa customizations of Lead
     
        Id [] fixedSearchResults= new Id[1]; 
        fixedSearchResults[0] = l.Id; 
        Test.setFixedSearchResults(fixedSearchResults); 
        
        List<String> strArr=new List<String>();
        strArr.add('IQ\tLead.Phone=87837743123456787');
    
        String jsonInp = AccountRetrieval100.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(4,allInfo.size());
        List<Object> leadInfos=(List<Object>)allInfo[3];
        System.assertEquals(1,leadInfos.size());
        
        Map<String,Object> info = (Map<String,Object>)leadInfos[0];
        
        System.assertEquals(l.Id,info.get('Id'));
    }
    static testMethod void objectQueryLead2()
    {
 		// Start: Modified original code to accommodate Absa customizations of Lead
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id recTypeId = rtInfo.get('Business_Bank_Lead').getRecordTypeId();        
        Financial_Product__c newProd = new Financial_Product__c(
            Name = 'BB - Borrow - Loans - Business Term Loan',
            Description__c = 'test product', 
            Product__c = 'Borrow', 
            Sub_Product__c = 'Business Term Loan', 
            Product_Type__c = 'Borrow',
            Business_Unit__c = 'Business Banking'
        );
        insert newProd;

        Lead l = new Lead(Description='My Lead',Company='Company1',
                          Status='Assigned',FirstName='Test',LastName='Lead',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert l;
 		// End: Modified original code to accommodate Absa customizations of Lead
        
        Id [] fixedSearchResults= new Id[1]; 
        fixedSearchResults[0] = l.Id; 
        Test.setFixedSearchResults(fixedSearchResults); 
        
        List<String> strArr=new List<String>();
        strArr.add('IQ\tLead.Phone=87837743123995677');
        strArr.add('IQ\tLead.ConvertedDate=1999-01-01');
        strArr.add('IQ\tLead.Company=Company1');
        strArr.add('IQ\tLead.LastName=Lead');
        strArr.add('IQ\tLead.IsConverted=true');
        strArr.add('IQ\tLead.Latitude=49.5');

        String jsonInp = AccountRetrieval100.objectQuery('97837743123456787',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(4,allInfo.size());
        List<Object> leadInfos=(List<Object>)allInfo[3];
        System.assertEquals(1,leadInfos.size());
        
        Map<String,Object> info = (Map<String,Object>)leadInfos[0];
        
        System.assertEquals(l.Id,info.get('Id'));
    }

    static testMethod void objectQueryContact()
    {
        Contact c = new Contact(Title='My ContactEX',Phone='87837743123456769',LastName='ContactDX');
        insert c;
     
        Id [] fixedSearchResults= new Id[1]; 
        fixedSearchResults[0] = c.Id; 
        Test.setFixedSearchResults(fixedSearchResults); 
        
        List<String> strArr=new List<String>();
        strArr.add('');  
        strArr.add('');
        strArr.add('IQ\tContact.Phone=87837743123456769');
        strArr.add('');
        strArr.add('');     
        String jsonInp = AccountRetrieval100.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(4,allInfo.size());
        List<Object> contactInfos=(List<Object>)allInfo[2];
        System.assertEquals(1,contactInfos.size());
        
        Map<String,Object> info = (Map<String,Object>)contactInfos[0];
        
        System.assertEquals(c.Id,info.get('Id'));
    }
    static testMethod void objectQuery4()
    {        
        List<String> strArr=new List<String>();
        strArr.add('IQ\tP=RCS');
    
        String jsonInp = AccountRetrieval100.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(5,allInfo.size());
        List<Object> urlInfos=(List<Object>)allInfo[4];
        System.assertEquals(1,urlInfos.size());
                
        System.assertEquals('P=RCS',urlInfos[0]);
    }
    static testMethod void objectQuery5()
    {        
        List<String> strArr=new List<String>();
        strArr.add('IQ\tP=RCS');
        strArr.add('IQ\tB=Account Balance');

        String jsonInp = AccountRetrieval100.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(5,allInfo.size());
        List<Object> urlInfos=(List<Object>)allInfo[4];
        System.assertEquals(1,urlInfos.size());
                
        System.assertEquals('P=RCS&B=Account+Balance',urlInfos[0]);
    }
    static testMethod void getAutoLoginInfo()
    {
        User u = new User(FirstName='my',LastName='user',phone='7647623764646762374627',
            extension='726672547532785443377766',Alias='my user',CommunityNickname='my user',
            Email='myuser@blah.com',Username='myuser@blah.com',TimeZoneSidKey='Europe/London',LocaleSidKey='en_GB',
            EmailEncodingKey='UTF-8',ProfileId=UserInfo.getProfileid(),LanguageLocaleKey='en_US'    );
        insert u;
         
        System.runAs(u) {
            String jsonInp = AccountRetrieval100.getAutoLoginInfo();
                        
            List<Object> userInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);
                        
            System.assertEquals(1,userInfo.size());
            
            Map<String,Object> info = (Map<String,Object>)userInfo[0];
            System.assertEquals('my user',info.get('Name'));
            System.assertEquals('7647623764646762374627',info.get('Phone'));
        }
    }
    static testMethod void getTodayTest()
    {
        String temp=AccountRetrieval100.getToday();
    }
    static testMethod void getNowTest()
    {
        String temp=AccountRetrieval100.getNow();
    }
    static testMethod void GetEIApexVersionTest()
    {
        String temp=AccountRetrieval100.GetEIApexVersion();
    }
    static LeadStatus findConvertedLeadStatus()
    {
        LeadStatus[] convertStatuses = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true];
        if(convertStatuses.size()>1)
        {
            //choose a lead status that starts with Closed
            for(Integer n=0;n<convertStatuses.size();n++)
            {
                if(convertStatuses[n].MasterLabel.startsWithIgnoreCase('Closed'))
                {
                    System.debug('findConvertedLeadStatus returns:-'+convertStatuses[n].MasterLabel);
                    return convertStatuses[n];
                }
            }
        }
        System.debug('findConvertedLeadStatus returns:-'+convertStatuses[0].MasterLabel);
        return convertStatuses[0];  
    }
    static testMethod void saveTaskInfoTest()
    {
 		// Start: Modified original code to accommodate Absa customizations of Lead
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id recTypeId = rtInfo.get('Business_Bank_Lead').getRecordTypeId();        
        Financial_Product__c newProd = new Financial_Product__c(
            Name = 'BB - Borrow - Loans - Business Term Loan',
            Description__c = 'test product', 
            Product__c = 'Borrow', 
            Sub_Product__c = 'Business Term Loan', 
            Product_Type__c = 'Borrow',
            Business_Unit__c = 'Business Banking'
        );
        insert newProd;

        Lead myLead = new Lead(Description='My Lead',Company='Fry And Sons',
                          Status='Assigned',FirstName='Test',LastName='Fry',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead;

        Lead myLead2 = new Lead(Description='My Lead',Company='Fry And Sons2',
                          Status='Assigned',FirstName='Test',LastName='Fry2',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead2;
        
        Lead myLead3 = new Lead(Description='My Lead',Company='Fry And Sons3',
                          Status='Assigned',FirstName='Test',LastName='Fry3',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead3;  
 		// End: Modified original code to accommodate Absa customizations of Lead
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        List<String> strArr=new List<String>();
        strArr.add(myLead.id);
        strArr.add(myLead2.id);
        strArr.add(myLead3.id);
        
        Map<String,String> saveParams=new Map<String,String>();
        saveParams.put('Subject','Hello World');
        saveParams.put('Status','Completed');
        saveParams.put('CallType','inbound');
        Date d=date.today();
        saveParams.put('ActivitydateYear',string.valueof(d.year()));
        saveParams.put('ActivitydateMonth',string.valueof(d.month()));
        saveParams.put('ActivitydateDay',string.valueof(d.day()));
        saveParams.put('CallObject',AccountRetrieval100.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');
        
        String temp=AccountRetrieval100.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),1);
            
        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);   
        System.assertEquals(false,objectMap.containsKey('Error'));
        System.assertEquals(lcr.opportunityid,objectMap.get('relatedId'));
        System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(lcr.opportunityid,tasks[0].WhatId);
    }
    static testMethod void saveTaskInfoTest2()
    {
 		// Start: Modified original code to accommodate Absa customizations of Lead
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id recTypeId = rtInfo.get('Business_Bank_Lead').getRecordTypeId();        
        Financial_Product__c newProd = new Financial_Product__c(
            Name = 'BB - Borrow - Loans - Business Term Loan',
            Description__c = 'test product', 
            Product__c = 'Borrow', 
            Sub_Product__c = 'Business Term Loan', 
            Product_Type__c = 'Borrow',
            Business_Unit__c = 'Business Banking'
        );
        insert newProd;

        Lead myLead = new Lead(Description='My Lead',Company='Fry And Sons',
                          Status='Assigned',FirstName='Test',LastName='Fry',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead;

        Lead myLead2 = new Lead(Description='My Lead',Company='Fry And Sons2',
                          Status='Assigned',FirstName='Test',LastName='Fry2',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead2;
        
        Lead myLead3 = new Lead(Description='My Lead',Company='Fry And Sons3',
                          Status='Assigned',FirstName='Test',LastName='Fry3',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead3;  
 		// End: Modified original code to accommodate Absa customizations of Lead

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        List<String> strArr=new List<String>();
        strArr.add(myLead.id);
        strArr.add(myLead2.id);
        strArr.add(myLead3.id);
        
        Map<String,String> saveParams=new Map<String,String>();
        saveParams.put('Subject','Hello World');
        saveParams.put('Status','Completed');
        saveParams.put('CallType','inbound');
        Date d=date.today();
        saveParams.put('ActivitydateYear',string.valueof(d.year()));
        saveParams.put('ActivitydateMonth',string.valueof(d.month()));
        saveParams.put('ActivitydateDay',string.valueof(d.day()));
        saveParams.put('CallObject',AccountRetrieval100.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');
        
        String temp=AccountRetrieval100.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),2);
            
        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);   
        System.assertEquals(false,objectMap.containsKey('Error'));
        System.assertEquals(lcr.contactid,objectMap.get('relatedId'));
        System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(lcr.contactid,tasks[0].WhoId);
    } 
    static testMethod void saveTaskInfoTest3()
    {
 		// Start: Modified original code to accommodate Absa customizations of Lead
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id recTypeId = rtInfo.get('Business_Bank_Lead').getRecordTypeId();        
        Financial_Product__c newProd = new Financial_Product__c(
            Name = 'BB - Borrow - Loans - Business Term Loan',
            Description__c = 'test product', 
            Product__c = 'Borrow', 
            Sub_Product__c = 'Business Term Loan', 
            Product_Type__c = 'Borrow',
            Business_Unit__c = 'Business Banking'
        );
        insert newProd;

        Lead myLead = new Lead(Description='My Lead',Company='Fry And Sons',
                          Status='Assigned',FirstName='Test',LastName='Fry',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead;

        Lead myLead2 = new Lead(Description='My Lead',Company='Fry And Sons2',
                          Status='Assigned',FirstName='Test',LastName='Fry2',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead2;
        
        Lead myLead3 = new Lead(Description='My Lead',Company='Fry And Sons3',
                          Status='Assigned',FirstName='Test',LastName='Fry3',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead3;  
 		// End: Modified original code to accommodate Absa customizations of Lead

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        List<String> strArr=new List<String>();
        strArr.add(myLead.id);
        strArr.add(myLead2.id);
        strArr.add(myLead3.id);
        
        Map<String,String> saveParams=new Map<String,String>();
        saveParams.put('Subject','Hello World');
        saveParams.put('Status','Completed');
        saveParams.put('CallType','inbound');
        Date d=date.today();
        saveParams.put('ActivitydateYear',string.valueof(d.year()));
        saveParams.put('ActivitydateMonth',string.valueof(d.month()));
        saveParams.put('ActivitydateDay',string.valueof(d.day()));
        saveParams.put('CallObject',AccountRetrieval100.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');
        
        String temp=AccountRetrieval100.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),4);
            
        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);   
        System.assertEquals(false,objectMap.containsKey('Error'));
        System.assertEquals(lcr.accountid,objectMap.get('relatedId'));
        System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(lcr.accountid,tasks[0].WhatId);
    } 
    static testMethod void saveTaskInfoTest4()
    {
 		// Start: Modified original code to accommodate Absa customizations of Lead
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id recTypeId = rtInfo.get('Business_Bank_Lead').getRecordTypeId();        
        Financial_Product__c newProd = new Financial_Product__c(
            Name = 'BB - Borrow - Loans - Business Term Loan',
            Description__c = 'test product', 
            Product__c = 'Borrow', 
            Sub_Product__c = 'Business Term Loan', 
            Product_Type__c = 'Borrow',
            Business_Unit__c = 'Business Banking'
        );
        insert newProd;

        Lead myLead = new Lead(Description='My Lead',Company='Fry And Sons',
                          Status='Assigned',FirstName='Test',LastName='Fry',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead;

        Lead myLead2 = new Lead(Description='My Lead',Company='Fry And Sons2',
                          Status='Assigned',FirstName='Test',LastName='Fry2',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead2;
        
        Lead myLead3 = new Lead(Description='My Lead',Company='Fry And Sons3',
                          Status='Assigned',FirstName='Test',LastName='Fry3',
                          MobilePhone='0745028191',Phone='0745028192',
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead3;  
 		// End: Modified original code to accommodate Absa customizations of Lead

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        List<String> strArr=new List<String>();
        strArr.add(myLead.id);
        strArr.add(myLead2.id);
        strArr.add(myLead3.id);
        
        Map<String,String> saveParams=new Map<String,String>();
        saveParams.put('Subject','Hello World');
        saveParams.put('Status','Completed');
        saveParams.put('CallType','inbound');
        Date d=date.today();
        saveParams.put('ActivitydateYear',string.valueof(d.year()));
        saveParams.put('ActivitydateMonth',string.valueof(d.month()));
        saveParams.put('ActivitydateDay',string.valueof(d.day()));
        saveParams.put('CallObject',AccountRetrieval100.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');
        
        String temp=AccountRetrieval100.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),0);
            
        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);   
        System.assertEquals(false,objectMap.containsKey('Error'));
        System.assertEquals(myLead2.id,objectMap.get('relatedId'));
        System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(myLead2.id,tasks[0].WhoId);
    } 
    static testMethod void saveTaskInfoTest5()
    {
 		// Start: Modified original code to accommodate Absa customizations of Lead
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id recTypeId = rtInfo.get('Business_Bank_Lead').getRecordTypeId();        
        Financial_Product__c newProd = new Financial_Product__c(
            Name = 'BB - Borrow - Loans - Business Term Loan',
            Description__c = 'test product', 
            Product__c = 'Borrow', 
            Sub_Product__c = 'Business Term Loan', 
            Product_Type__c = 'Borrow',
            Business_Unit__c = 'Business Banking'
        );
        insert newProd;

        Lead myLead = new Lead(Description='My Lead',Company='Fry And Sons',
                          Status='Assigned',FirstName='Test',LastName='Fry',
                          MobilePhone='0745028191',Phone='0745028192',Bypass_Validation_Rules__c = True,
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead;

        Lead myLead2 = new Lead(Description='My Lead',Company='Fry And Sons2',
                          Status='Assigned',FirstName='Test',LastName='Fry2',
                          MobilePhone='0745028191',Phone='0745028192',Bypass_Validation_Rules__c = True,
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead2;
        
        Lead myLead3 = new Lead(Description='My Lead',Company='Fry And Sons3',
                          Status='Assigned',FirstName='Test',LastName='Fry3',
                          MobilePhone='0745028191',Phone='0745028192',Bypass_Validation_Rules__c = True,
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead3;  
 		// End: Modified original code to accommodate Absa customizations of Lead
        
        List<String> strArr=new List<String>();
        strArr.add(myLead.id);
        strArr.add(myLead2.id);
        strArr.add(myLead3.id);
        
        Map<String,String> saveParams=new Map<String,String>();
        saveParams.put('Subject','Hello World');
        saveParams.put('Status','Completed');
        saveParams.put('CallType','inbound');
        Date d=date.today();
        saveParams.put('ActivitydateYear',string.valueof(d.year()));
        saveParams.put('ActivitydateMonth',string.valueof(d.month()));
        saveParams.put('ActivitydateDay',string.valueof(d.day()));
        saveParams.put('CallObject',AccountRetrieval100.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');
        
        String temp=AccountRetrieval100.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),0);
            
        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);   
        System.assertEquals(false,objectMap.containsKey('Error'));
        System.assertEquals(myLead.id,objectMap.get('relatedId'));
        System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(myLead.id,tasks[0].WhoId);
        
        //see if we can still convert myLead
        
        Database.LeadConvert lc = new Database.LeadConvert();
        myLead.Bypass_Validation_Rules__c = True;
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
    } 
    static testMethod void saveTaskInfoTest6()
    {
        Account acc = new Account(Name = 'Fry', Phone='34345353');
        insert acc;
        
        List<String> strArr=new List<String>();
        
        Map<String,String> saveParams=new Map<String,String>();
        saveParams.put('Subject','Hello World');
        saveParams.put('Status','Completed');
        saveParams.put('CallType','inbound');
        Date d=date.today();
        saveParams.put('ActivitydateYear',string.valueof(d.year()));
        saveParams.put('ActivitydateMonth',string.valueof(d.month()));
        saveParams.put('ActivitydateDay',string.valueof(d.day()));
        saveParams.put('CallObject',AccountRetrieval100.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');
        
        String temp=AccountRetrieval100.saveTaskInfo(JSON.serialize(strArr),
            acc.id,'','',JSON.serialize(saveParams),0);
            
        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);   
        System.assertEquals(false,objectMap.containsKey('Error'));
        System.assertEquals(acc.id,objectMap.get('relatedId'));
        System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(acc.id,tasks[0].WhatId);
    } 
    static testMethod void saveTaskInfoTest7()
    {
 		// Start: Modified original code to accommodate Absa customizations of Lead
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id recTypeId = rtInfo.get('Business_Bank_Lead').getRecordTypeId();        
        Financial_Product__c newProd = new Financial_Product__c(
            Name = 'BB - Borrow - Loans - Business Term Loan',
            Description__c = 'test product', 
            Product__c = 'Borrow', 
            Sub_Product__c = 'Business Term Loan', 
            Product_Type__c = 'Borrow',
            Business_Unit__c = 'Business Banking'
        );
        insert newProd;

        Lead myLead = new Lead(Description='My Lead',Company='Fry And Sons',
                          Status='Assigned',FirstName='Test',LastName='Fry',
                          MobilePhone='0745028191',Phone='0745028192', Bypass_Validation_Rules__c = True,
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead;

        Lead myLead2 = new Lead(Description='My Lead',Company='Fry And Sons2',
                          Status='Assigned',FirstName='Test',LastName='Fry2',
                          MobilePhone='0745028191',Phone='0745028192',Bypass_Validation_Rules__c = True,
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead2;
        
        Lead myLead3 = new Lead(Description='My Lead',Company='Fry And Sons3',
                          Status='Assigned',FirstName='Test',LastName='Fry3',
                          MobilePhone='0745028191',Phone='0745028192',Bypass_Validation_Rules__c = True,
                          Financial_Product__c=newProd.Id,RecordTypeId=recTypeId);
        insert myLead3;  
 		// End: Modified original code to accommodate Absa customizations of Lead
        
        List<String> strArr=new List<String>();
        strArr.add(myLead.id);
        strArr.add(myLead2.id);
        strArr.add(myLead3.id);
        
        delete myLead;
        
        Map<String,String> saveParams=new Map<String,String>();
        saveParams.put('Subject','Hello World');
        saveParams.put('Status','Completed');
        saveParams.put('CallType','inbound');
        Date d=date.today();
        saveParams.put('ActivitydateYear',string.valueof(d.year()));
        saveParams.put('ActivitydateMonth',string.valueof(d.month()));
        saveParams.put('ActivitydateDay',string.valueof(d.day()));
        saveParams.put('CallObject',AccountRetrieval100.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');
        
        String temp=AccountRetrieval100.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),0);
            
        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);   
        System.assertEquals(false,objectMap.containsKey('Error'));
        System.assertEquals(myLead2.id,objectMap.get('relatedId'));
        System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(myLead2.id,tasks[0].WhoId);
        
        //see if we can still convert myLead2
        
        Database.LeadConvert lc = new Database.LeadConvert();
        myLead2.Bypass_Validation_Rules__c = True;
        lc.setLeadId(myLead2.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
    } 
    static testMethod void saveTaskInfoTest8()
    {        
         List<String> strArr=new List<String>();
        
        Map<String,String> saveParams=new Map<String,String>();
        saveParams.put('Subject','Hello World');
        saveParams.put('Status','Completed');
        saveParams.put('CallType','inbound');
        Date d=date.today();
        saveParams.put('ActivitydateYear',string.valueof(d.year()));
        saveParams.put('ActivitydateMonth',string.valueof(d.month()));
        saveParams.put('ActivitydateDay',string.valueof(d.day()));
        saveParams.put('CallObject',AccountRetrieval100.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');
        
        String temp=AccountRetrieval100.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),0);
            
        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);   
        System.assertEquals(false,objectMap.containsKey('Error'));
        System.assertEquals('',objectMap.get('relatedId'));
        System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(null,tasks[0].WhoId);
    }           
}