@isTest
public class ROTSchedulerHandlerTest {
    @isTest static void rotSchedulerTestPositive(){
        //Account account = [SELECT Id FROM Account LIMIT 1];
        //BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        //Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
       
        //Case testCase = new Case(RecordTypeId = caseRecordTypeId, Account = account);
       
        //insert testCase;
        
       //RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
        
        Test.startTest();
        try{
            
        
            
            Account acc = new Account();
            acc.Name = 'testAccount';
            insert acc;
            Case cs = new Case();
            cs.Status = 'In Progress';
            cs.Type__c = 'Create New Restriction Groups';
            cs.ROT_Approval_Status__c = 'Submitted';
            cs.Priority = 'Medium';
            cs.Origin = 'Email';
            cs.AccountId = acc.Id;
            cs.ROT_Start_Date__c = system.today();
            cs.ROT_End_Date__c = system.today();
            insert cs;
            RestrictionGroup__c rg = new RestrictionGroup__c();
            rg.Description__c = 'Test';
            rg.EffectiveStartDate__c = system.today();
            rg.EffectiveEndDate__c = system.today();
            rg.Case__c = cs.Id;
        	rg.GroupID__c = 'AAA';
            insert rg;
            RestrictionGroupAccount__c rgAcc = new RestrictionGroupAccount__c();
            //rgAcc.Id = Acc.Id;
            rgAcc.Name = 'Test Account';
            rgAcc.EffectiveStartDate__c = system.today();
            rgAcc.EffectiveEndDate__c = system.today();
            rgAcc.RestrictionGroupId__c = rg.Id;
            insert rgAcc;
            RestrictionGroupTransactionType__c rgTT = new RestrictionGroupTransactionType__c();
            rgTT.Name = 'Test TT';
            rgTT.Effective_Start_Date__c = system.today();
            rgTT.Effective_End_Date__c = system.today();
            rgTT.Restriction_Group_ID__c = rg.Id;
            insert rgTT;
            Case tCase = [select id from case where Status like 'In Progress' and ROT_Approval_Status__c = 'Submitted'
                         and Type__c = 'Create New Restriction Groups' limit 1];
            Id testId = tCase.Id;
            
            CasesSelector cSS = new CasesSelector();
            cSS.selectByServiceTypeROT(cs.Type__c, cs.Status, cs.ROT_Approval_Status__c);
            
            ROTScheduler sched = new ROTScheduler();
            String cronExp = '0 0 0 * * ?';  // 8:30am every 1st day of the month 
            String jobID = System.schedule('Something', cronExp, sched);
            
            
        }catch(Exception e){
            system.debug('error message....' +e.getMessage());
            system.debug('error line.........' +e.getLineNumber());
            system.debug('error cause.........' +e.getCause());
        }
        
        Test.stopTest();
    }
    
    @isTest static void rotcaseROTStartDateUpdateTestPositive(){
        Test.startTest();
        try{
            
        /*Account account = [SELECT Id FROM Account LIMIT 1];
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
       
        Case testCase = new Case(RecordTypeId = caseRecordTypeId, Account = account);
       
        insert testCase;
        */
       //RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
            
            Account acc = new Account();
            acc.Name = 'testAccount';
            insert acc;
            Case cs = new Case();            
            cs.Status = 'In Progress';
            cs.Type__c = 'Create New Restriction Groups';
            cs.ROT_Approval_Status__c = 'Submitted';
            cs.Priority = 'Medium';
            cs.Origin = 'Email';
            cs.AccountId = acc.Id;
            cs.ROT_Start_Date__c = system.today();
            cs.ROT_End_Date__c = system.today();
            insert cs;
            RestrictionGroup__c rg = new RestrictionGroup__c();
            rg.Description__c = 'Test';
            rg.EffectiveStartDate__c = system.today();
            rg.EffectiveEndDate__c = system.today();
            rg.Case__c = cs.Id;
            rg.GroupID__c = 'AAA';
            insert rg;
            RestrictionGroupAccount__c rgAcc = new RestrictionGroupAccount__c();
            //rgAcc.Id = Acc.Id;
            rgAcc.Name = 'Test Account';
            rgAcc.EffectiveStartDate__c = system.today();
            rgAcc.EffectiveEndDate__c = system.today();
            rgAcc.RestrictionGroupId__c = rg.Id;
            insert rgAcc;
            RestrictionGroupTransactionType__c rgTT = new RestrictionGroupTransactionType__c();
            rgTT.Name = 'Test TT';
            rgTT.Effective_Start_Date__c = system.today();
            rgTT.Effective_End_Date__c = system.today();
            rgTT.Restriction_Group_ID__c = rg.Id;
            insert rgTT;
            Case tCase = [select id from case where Status like 'In Progress' and ROT_Approval_Status__c = 'Submitted'
                         and Type__c = 'Create New Restriction Groups' limit 1];
            Id testId = tCase.Id;
            
           // ROTSchedulerHandler.preLapseStartDateEmailContext(cs.Id);
           // ROTSchedulerHandler.preLapseEndDateEmailContext(cs.Id);
            ROTSchedulerHandler.lapseStartDateEmailContext(cs.Id);
            ROTSchedulerHandler.lapseEndDateEmailContext(cs.Id);
            
            
        }catch(Exception e){
            system.debug('error message....' +e.getMessage());
            system.debug('error line.........' +e.getLineNumber());
        }
        
        
        Test.stopTest();
    }
    
    @isTest static void rotcaseROTStartDatePreLapseTestPositive(){
        Test.startTest();
        try{
            
        //Account account = [SELECT Id FROM Account LIMIT 1];
        Account accT = new Account();
        accT.Name = 'testAccountTT';
        insert accT;
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
       
        Case testCase = new Case(RecordTypeId = caseRecordTypeId, Account = accT);
       
        insert testCase;
        
       //RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
            
            Account acc = new Account();
            acc.Name = 'testAccount';
            insert acc;
            Case cs = new Case();
            cs.Status = 'In Progress';
            cs.Type__c = 'Create New Restriction Groups';
            cs.ROT_Approval_Status__c = 'Submitted';
            cs.Priority = 'Medium';
            cs.Origin = 'Email';
            cs.AccountId = acc.Id;
            cs.ROT_Start_Date__c = system.today() + 2;
            cs.ROT_End_Date__c = system.today() + 2;
            insert cs;
            RestrictionGroup__c rg = new RestrictionGroup__c();
            rg.Description__c = 'Test';
            rg.EffectiveStartDate__c = system.today() + 2;
            rg.EffectiveEndDate__c = system.today() + 2;
            rg.Case__c = cs.Id;
            rg.GroupID__c = 'AAA';
            insert rg;
            RestrictionGroupAccount__c rgAcc = new RestrictionGroupAccount__c();
            //rgAcc.Id = Acc.Id;
            rgAcc.Name = 'Test Account';
            rgAcc.EffectiveStartDate__c = system.today() + 2;
            rgAcc.EffectiveEndDate__c = system.today() + 2;
            rgAcc.RestrictionGroupId__c = rg.Id;
            insert rgAcc;
            RestrictionGroupTransactionType__c rgTT = new RestrictionGroupTransactionType__c();
            rgTT.Name = 'Test TT';
            rgTT.Effective_Start_Date__c = system.today() + 2;
            rgTT.Effective_End_Date__c = system.today() + 2;
            rgTT.Restriction_Group_ID__c = rg.Id;
            insert rgTT;
            Case tCase = [select id from case where Status like 'In Progress' and ROT_Approval_Status__c = 'Submitted'
                         and Type__c = 'Create New Restriction Groups' limit 1];
            Id testId = tCase.Id;
            
            
            ROTSchedulerHandler.preLapseStartDateEmailContext(cs.Id);
            ROTSchedulerHandler.preLapseEndDateEmailContext(cs.Id);
           // ROTSchedulerHandler.lapseStartDateEmailContext(cs.Id);
           // ROTSchedulerHandler.lapseEndDateEmailContext(cs.Id);
            
            
        }catch(Exception e){
            system.debug('error message....' +e.getMessage());
            system.debug('error line.........' +e.getLineNumber());
        }
        
        
        Test.stopTest();
    }
    
    @isTest static void rotcaseROTTestPositive(){
        Test.startTest();
        try{
            
        //Account account = [SELECT Id FROM Account LIMIT 1];
        Account accT = new Account();
        accT.Name = 'testAccountTT';
        insert accT;
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
       
        Case testCase = new Case(RecordTypeId = caseRecordTypeId, Account = accT);
       
        insert testCase;
        
      // RestrictionGroup__c currentRestriction = [SELECT Id , Restriction_ID__c FROM RestrictionGroup__c LIMIT 1];
            
            Account acc = new Account();
            acc.Name = 'testAccount';
            insert acc;
            Case cs = new Case();
            cs.Status = 'In Progress';
            cs.Type__c = 'Create New Restriction Groups';
            cs.ROT_Approval_Status__c = 'Submitted';
            cs.Priority = 'Medium';
            cs.Origin = 'Email';
            cs.AccountId = acc.Id;
            cs.ROT_Start_Date__c = system.today() + 2;
            cs.ROT_End_Date__c = system.today() + 2;
            insert cs;
            RestrictionGroup__c rg = new RestrictionGroup__c();
            rg.Description__c = 'Test';
            rg.EffectiveStartDate__c = system.today() + 2;
            rg.EffectiveEndDate__c = system.today() + 2;
            rg.Case__c = cs.Id;
            rg.GroupID__c = 'AAA';
            insert rg;
            RestrictionGroupAccount__c rgAcc = new RestrictionGroupAccount__c();
            //rgAcc.Id = Acc.Id;
            rgAcc.Name = 'Test Account';
            rgAcc.EffectiveStartDate__c = system.today() + 2;
            rgAcc.EffectiveEndDate__c = system.today() + 2;
            rgAcc.RestrictionGroupId__c = rg.Id;
            insert rgAcc;
            RestrictionGroupTransactionType__c rgTT = new RestrictionGroupTransactionType__c();
            rgTT.Name = 'Test TT';
            rgTT.Effective_Start_Date__c = system.today() + 2;
            rgTT.Effective_End_Date__c = system.today() + 2;
            rgTT.Restriction_Group_ID__c = rg.Id;
            insert rgTT;
            Case tCase = [select id from case where Status like 'In Progress' and ROT_Approval_Status__c = 'Submitted'
                         and Type__c = 'Create New Restriction Groups' limit 1];
            Id testId = tCase.Id;
            
            ROTSchedulerHandler.caseROTStartDateUpdate(cs.Id);
            
            
            
        }catch(Exception e){
            system.debug('error message....' +e.getMessage());
            system.debug('error line.........' +e.getLineNumber());
        }
        
        
        Test.stopTest();
    }
}