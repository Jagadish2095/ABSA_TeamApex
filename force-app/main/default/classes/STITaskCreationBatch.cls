global class STITaskCreationBatch implements Database.Batchable < sObject > , Schedulable {
    global void execute(SchedulableContext SC) {
        STITaskCreationBatch  batch = new STITaskCreationBatch();
        ID batchprocessid = Database.executeBatch(batch, 4);
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query;
        if(!Test.isRunningTest())
            query = 'SELECT id,Five_Business_Days__c,OwnerId,Task_Creation_Date_For_5_Days__c,STI_Sub_Status__c,StageName from Opportunity WHERE Five_Business_Days__c=TODAY AND RecordType.Name=\'STI\' AND StageName=\'Closed Won (Success)\'';
        else
            query = 'SELECT id,Five_Business_Days__c,OwnerId,Task_Creation_Date_For_5_Days__c,STI_Sub_Status__c,StageName from Opportunity WHERE RecordType.Name=\'STI\' AND StageName=\'Closed Won (Success)\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List <Opportunity> ListOfprocessrec) {
    system.debug('ProcessList'+ListOfprocessrec);
     List <Task > ProcessList = new List <Task> ();
      List <Opportunity > OpprList = new List <Opportunity> ();
     for (Opportunity OppList: ListOfprocessrec) 
    {
        Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('STI Task').getRecordTypeId();
        Task   tskobj = new Task();
        tskobj.Subject ='Update Opportunity With Policy Number';
        tskobj.Description = 'Please update your opportunity with Policy Number Received Via Email';
        tskobj.WhatId =OppList.id;
        tskobj.RecordTypeId = devRecordTypeId;
        tskobj.OwnerId= OppList.OwnerId;
        tskobj.Status= 'Open';
        tskobj.IsReminderSet= True;
        //tskobj.ActivityDate= system.today();
        tskobj.ReminderDateTime = System.now();
        Opportunity opp = new Opportunity();
        opp.id= OppList.id;
        opp.STI_Sub_Status__c ='Await Policy Number';
        OpprList.add(opp);
        ProcessList.add(tskobj);
        
    }
    integer InsertList=0;
    integer updateList=0;
    updateList = OpprList.size();
    InsertList = ProcessList.size();
    System.debug('InsertList'+InsertList);
    if(OpprList !=null){
        Database.update(OpprList,false);
    }
    if(InsertList !=null){
        Database.insert(ProcessList,false);
    }
    }
    global void finish(Database.BatchableContext BC) {
    }
 }