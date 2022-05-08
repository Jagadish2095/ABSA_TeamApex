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
// 4.000 Mazhar Nazeer 20-Sep-2019
// Class Name is updated with 400. This should be incremented for every version release.
//

@isTest
public class AccountRetrievalTest400{
    static testMethod void getCallerAccount() {
        Account a = new Account(Name='My AccountCC',Phone='87837743123456789');
        insert a;

        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = a.Id;
        Test.setFixedSearchResults(fixedSearchResults);

        String jsonInp = AccountRetrieval400.getCaller('87837743123456789');

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

        String jsonInp = AccountRetrieval400.getCaller('87837743123456789');

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

        String jsonInp = AccountRetrieval400.adhocQuery('FIND \'87837743123456789\' IN PHONE FIELDS RETURNING ACCOUNT(Type,AccountNumber,Name,Id)');

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
        String jsonInp = AccountRetrieval400.objectQuery('0',JSON.serialize(strArr));
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

        String jsonInp = AccountRetrieval400.objectQuery('77837743123456787',JSON.serialize(strArr));
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

        String jsonInp = AccountRetrieval400.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(4,allInfo.size());
        List<Object> accountInfos=(List<Object>)allInfo[0];
        System.assertEquals(1,accountInfos.size());

        Map<String,Object> info = (Map<String,Object>)accountInfos[0];

        System.assertEquals(a.Id,info.get('Id'));
    }
    static testMethod void objectQueryCase()
    {
        Case c = new Case(Description='My Case',SuppliedPhone='87837743123456780');
        insert c;

        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = c.Id;
        Test.setFixedSearchResults(fixedSearchResults);

        List<String> strArr=new List<String>();
        strArr.add('IQ\tCase.SuppliedPhone=87837743123456780');

        String jsonInp = AccountRetrieval400.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(4,allInfo.size());
        List<Object> caseInfos=(List<Object>)allInfo[1];
        System.assertEquals(1,caseInfos.size());

        Map<String,Object> info = (Map<String,Object>)caseInfos[0];

        System.assertEquals(c.Id,info.get('Id'));
    }
    static testMethod void objectQueryCase2()
    {
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

        String jsonInp = AccountRetrieval400.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(4,allInfo.size());
        List<Object> caseInfos=(List<Object>)allInfo[1];
        System.assertEquals(1,caseInfos.size());

        Map<String,Object> info = (Map<String,Object>)caseInfos[0];

        System.assertEquals(c.Id,info.get('Id'));
    }
    static testMethod void objectQueryCase3()
    {
        Case c = new Case(Priority='1');
        insert c;

        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = c.Id;
        Test.setFixedSearchResults(fixedSearchResults);

        List<String> strArr=new List<String>();
        c= [select id, casenumber from case where id = : c.id];
        strArr.add('IQ\tCase.CaseNumber='+c.CaseNumber);

        String jsonInp = AccountRetrieval400.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(4,allInfo.size());
        List<Object> caseInfos=(List<Object>)allInfo[1];
        System.assertEquals(1,caseInfos.size());
    }
    static testMethod void objectQueryLead()
    {
        Lead l = new Lead(Description='My Lead',Phone='0794465556',Company='Company1',LastName='Lead');
        insert l;

        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = l.Id;
        Test.setFixedSearchResults(fixedSearchResults);

        List<String> strArr=new List<String>();
        strArr.add('IQ\tLead.Phone=0794465556');

        String jsonInp = AccountRetrieval400.objectQuery('0',JSON.serialize(strArr));
        List<Object> allInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

        System.assertEquals(4,allInfo.size());
        List<Object> leadInfos=(List<Object>)allInfo[3];
        System.assertEquals(1,leadInfos.size());

        Map<String,Object> info = (Map<String,Object>)leadInfos[0];

        System.assertEquals(l.Id,info.get('Id'));
    }
    static testMethod void objectQueryLead2()
    {
        Lead l = new Lead(Description='My Lead',Phone='0794465556',Company='Company1',LastName='Lead');
        insert l;

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

        String jsonInp = AccountRetrieval400.objectQuery('0794465556',JSON.serialize(strArr));
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
        String jsonInp = AccountRetrieval400.objectQuery('0',JSON.serialize(strArr));
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

        String jsonInp = AccountRetrieval400.objectQuery('0',JSON.serialize(strArr));
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

        String jsonInp = AccountRetrieval400.objectQuery('0',JSON.serialize(strArr));
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
            String jsonInp = AccountRetrieval400.getAutoLoginInfo();

            List<Object> userInfo = (List<Object>)JSON.deserializeUntyped(jsonInp);

            System.assertEquals(1,userInfo.size());

            Map<String,Object> info = (Map<String,Object>)userInfo[0];
            System.assertEquals('my user',info.get('Name'));
            System.assertEquals('7647623764646762374627',info.get('Phone'));
        }
    }
    static testMethod void getTodayTest()
    {
        String temp=AccountRetrieval400.getToday();
        System.assert(String.isNotBlank(temp), 'Assert Failed'); // 20210302: Custom Absa code
    }
    static testMethod void getNowTest()
    {
        String temp=AccountRetrieval400.getNow();
        System.assert(String.isNotBlank(temp), 'Assert Failed'); // 20210302: Custom Absa code
    }
    static testMethod void GetEIApexVersionTest()
    {
        String temp=AccountRetrieval400.GetEIApexVersion();
        System.assert(String.isNotBlank(temp), 'Assert Failed'); // 20210302: Custom Absa code
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
        Lead myLead = new Lead(LastName = 'Fry', Company='Fry And Sons');
        insert myLead;

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

        //Database.LeadConvertResult lcr = Database.convertLead(lc);
        //System.assert(lcr.isSuccess());

        Lead myLead2 = new Lead(LastName = 'Fry2', Company='Fry And Sons2');
        insert myLead2;

        Lead myLead3 = new Lead(LastName = 'Fry3', Company='Fry And Sons3');
        insert myLead3;

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
        saveParams.put('CallObject',AccountRetrieval400.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');

        String temp=AccountRetrieval400.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),1);

        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);
        //System.assertEquals(false,objectMap.containsKey('Error'));
        //System.assertEquals(lcr.opportunityid,objectMap.get('relatedId'));
        //System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        /*
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);*/
       // System.assertEquals(lcr.opportunityid,tasks[0].WhatId);
    }
    static testMethod void saveTaskInfoTest2()
    {
        Lead myLead = new Lead(LastName = 'Fry', Company='Fry And Sons');
        insert myLead;

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

        //Database.LeadConvertResult lcr = Database.convertLead(lc);
        //System.assert(lcr.isSuccess());

        Lead myLead2 = new Lead(LastName = 'Fry2', Company='Fry And Sons2');
        insert myLead2;

        Lead myLead3 = new Lead(LastName = 'Fry3', Company='Fry And Sons3');
        insert myLead3;

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
        saveParams.put('CallObject',AccountRetrieval400.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');

        String temp=AccountRetrieval400.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),2);

        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);
        //System.assertEquals(false,objectMap.containsKey('Error'));
        //System.assertEquals(lcr.contactid,objectMap.get('relatedId'));
        //System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        /*
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);*/
       // System.assertEquals(lcr.contactid,tasks[0].WhoId);
    }
    static testMethod void saveTaskInfoTest3()
    {
        Lead myLead = new Lead(LastName = 'Fry', Company='Fry And Sons');
        insert myLead;

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

       // Database.LeadConvertResult lcr = Database.convertLead(lc);
        //System.assert(lcr.isSuccess());

        Lead myLead2 = new Lead(LastName = 'Fry2', Company='Fry And Sons2');
        insert myLead2;

        Lead myLead3 = new Lead(LastName = 'Fry3', Company='Fry And Sons3');
        insert myLead3;

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
        saveParams.put('CallObject',AccountRetrieval400.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');

        String temp=AccountRetrieval400.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),4);

        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);
        //System.assertEquals(false,objectMap.containsKey('Error'));
        //System.assertEquals(lcr.accountid,objectMap.get('relatedId'));
        //System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        /*
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);*/
       // System.assertEquals(lcr.accountid,tasks[0].WhatId);
    }
    static testMethod void saveTaskInfoTest4()
    {
        Lead myLead = new Lead(LastName = 'Fry', Company='Fry And Sons');
        insert myLead;

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

        //Database.LeadConvertResult lcr = Database.convertLead(lc);
        //System.assert(lcr.isSuccess());

        Lead myLead2 = new Lead(LastName = 'Fry2', Company='Fry And Sons2');
        insert myLead2;

        Lead myLead3 = new Lead(LastName = 'Fry3', Company='Fry And Sons3');
        insert myLead3;

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
        saveParams.put('CallObject',AccountRetrieval400.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');

        String temp=AccountRetrieval400.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),0);

        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);
        //System.assertEquals(false,objectMap.containsKey('Error'));
        //System.assertEquals(myLead2.id,objectMap.get('relatedId'));
        //System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        /*
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(myLead2.id,tasks[0].WhoId);*/
    }
    static testMethod void saveTaskInfoTest5()
    {
        Lead myLead = new Lead(LastName = 'Fry', Company='Fry And Sons');
        insert myLead;

        Lead myLead2 = new Lead(LastName = 'Fry2', Company='Fry And Sons2');
        insert myLead2;

        Lead myLead3 = new Lead(LastName = 'Fry3', Company='Fry And Sons3');
        insert myLead3;

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
        saveParams.put('CallObject',AccountRetrieval400.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');

        String temp=AccountRetrieval400.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),0);

        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);
        //System.assertEquals(false,objectMap.containsKey('Error'));
        //System.assertEquals(myLead.id,objectMap.get('relatedId'));
        //System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        /*
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(myLead.id,tasks[0].WhoId);*/

        //see if we can still convert myLead

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

        //Database.LeadConvertResult lcr = Database.convertLead(lc);
        //System.assert(lcr.isSuccess());
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
        saveParams.put('CallObject',AccountRetrieval400.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');

        String temp=AccountRetrieval400.saveTaskInfo(JSON.serialize(strArr),
            acc.id,'','',JSON.serialize(saveParams),0);

        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);
        //System.assertEquals(false,objectMap.containsKey('Error'));
        //System.assertEquals(acc.id,objectMap.get('relatedId'));
        //System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        /*
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(acc.id,tasks[0].WhatId);*/
    }
    static testMethod void saveTaskInfoTest7()
    {
        Lead myLead = new Lead(LastName = 'Fry', Company='Fry And Sons');
        insert myLead;

        Lead myLead2 = new Lead(LastName = 'Fry2', Company='Fry And Sons2');
        insert myLead2;

        Lead myLead3 = new Lead(LastName = 'Fry3', Company='Fry And Sons3');
        insert myLead3;

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
        saveParams.put('CallObject',AccountRetrieval400.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');

        String temp=AccountRetrieval400.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),0);

        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);
       // System.assertEquals(false,objectMap.containsKey('Error'));
        //System.assertEquals(myLead2.id,objectMap.get('relatedId'));
        //System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        /*
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(myLead2.id,tasks[0].WhoId);*/

        //see if we can still convert myLead2

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(myLead2.id);

        LeadStatus convertStatus=findConvertedLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);

        //Database.LeadConvertResult lcr = Database.convertLead(lc);
        //System.assert(lcr.isSuccess());
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
        saveParams.put('CallObject',AccountRetrieval400.getNow());
        saveParams.put('Description','jfdkidjfij');
        saveParams.put('CallDurationInSeconds','123');

        String temp=AccountRetrieval400.saveTaskInfo(JSON.serialize(strArr),
            '','','',JSON.serialize(saveParams),0);

        Map<String, String> objectMap = (Map<String, String>)JSON.deserialize(temp,Map<String,String>.class);
        //System.assertEquals(false,objectMap.containsKey('Error'));
        //System.assertEquals('',objectMap.get('relatedId'));
        //System.assertEquals(true,objectMap.containsKey('sfTaskId'));

        Task[] tasks=[SELECT Subject,Status,CallType,Description,CallDurationInSeconds,WhoId,WhatId From Task WHERE id=:objectMap.get('sfTaskId')];
        /*
        System.assertEquals(1,tasks.size());
        System.assertEquals('Hello World',tasks[0].Subject);
        System.assertEquals('Completed',tasks[0].Status);
        System.assertEquals('Inbound',tasks[0].CallType);
        System.assertEquals('jfdkidjfij',tasks[0].Description);
        System.assertEquals(123,tasks[0].CallDurationInSeconds);
        System.assertEquals(null,tasks[0].WhoId);*/
    }

    static testMethod void HandleConvertedLeadInfoPositive()
    {
         AccountRetrieval400.HandleConvertedLeadInfo handleConvertedLeadInfoRequest = new AccountRetrieval400.HandleConvertedLeadInfo('','','','',null);
         AccountRetrieval400.HandleConvertedLeadInfo handleConvertedLeadInfo = new AccountRetrieval400.HandleConvertedLeadInfo('','');
         Account a = new Account(Name='TestAccount');
         insert a;

         // String listString;
          //listString.add(a.Id);
         AccountRetrieval400.HandleConvertedLeadInfo handleConvertedLeadInfoTest = AccountRetrieval400.HandleConvertedLeadInfo.handleConvertedLead('["'+ a.Id +'"]','',1,'','');

         Task task = new Task();
         task.Subject = 'Call';
         insert task;

         Map<String, String> m = new Map<String, String>();
         Map<String, String> n = new Map<String, String>();
         m.put('CTI_ANI__c' , 'CTI_ANI__c');
         m.put('CTI_DNIS__c' , 'CTI_DNIS__c');
         m.put('ANI_Match__c' , 'ANI_Match__c');
         m.put('GlobalRefId__c' , 'GlobalRefId__c');
         m.put('Agent_ID__c' , 'Agent_ID__c');

         AccountRetrieval400.actuallySaveTaskInfo(task,null,'','',0,'','',true);
         AccountRetrieval400.copyTaskInfo(task,m,n);

    }

    static testMethod void HandleConvertedLeadInfoPositiveGetMethod()
    {
        AccountRetrieval400.HandleConvertedLeadInfo handleConvertedLeadInfoRequest = new AccountRetrieval400.HandleConvertedLeadInfo('','','',null,null);
    	AccountRetrieval400.HandleConvertedLeadInfo HandleConvert = new AccountRetrieval400.HandleConvertedLeadInfo('','');

       // List<List<SObject>> SbJC = AccountRetrieval400.getCallerInt('+00123');
        System.debug(HandleConvert.WhoId);
        System.debug(HandleConvert.WhatId);
        System.debug(HandleConvert.RelatedName);
        System.debug(HandleConvert.RelatedId);
        System.debug(HandleConvert.LockedLead);

        try
		{
           AccountRetrieval400.copyTaskInfo(null,null,null);
           AccountRetrieval400.actuallySaveTaskInfo(null,null,'','',0,'','',true);
		system.assert(false);
		}
		Catch(exception e)
		{
            System.debug('Exception: ' + e); // 20210302: Custom Absa code to add System.debug
		}



    }

    static testMethod void HandleConvertedLeadInfoPositiveExecption()
    {
         try
		{
           AccountRetrieval400.actuallySaveTaskInfo(null,null,null,null,null,null,null,true);
		system.assert(false);
		}
		Catch(exception e)
		{
            System.debug('Exception: ' + e); // 20210302: Custom Absa code to add System.debug
		}
    }

}