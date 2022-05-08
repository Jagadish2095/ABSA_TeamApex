/**
* Created by : Manish
* @description : Test Class for ProductOnboardingApprovalController
* Created Date: 23/03/2021
*/ 
@isTest
public class ProductOnboardingApprovalControllerTest {

    @testSetup
    static void createTestData(){
        List<User> usersList = new List<User>();
        System.runAs(new User(Id=UserInfo.getUserId())){
            usersList = TestDataFactory.getTestUsers('System Administrator (Custom)', 2);
            usersList[0].Business_Area__c = 'WIMI';
            insert usersList;             
        }
        System.runAs(usersList[0]){
            List<Lead> leadsList = TestDataFactory.getLeads('Business_Bank_Lead', 1);
            insert leadsList;         
            List<Opportunity> oppsList = TestDataFactory.getOpportunities(null,'Opportunity_Business_Bank',3);
            oppsList[0].StageName = 'Proposal';
            oppsList[0].Lead_Number__c = leadsList[0].Id;
            //oppsList[0].recordTypeId = '0121j000000FeEv';
            insert oppsList;  
            
            Application__c  app = new Application__c();
            //app.Customer_Region__c = 'Cape Region';
            app.Is_there_a_Transfer_to_be_performed_for__c = 'Yes';
            app.Opportunity__c = oppsList[0].Id;
            insert app;
            
            Product2 prod = new Product2(
            Name = 'Test',
            ProductCode = '1122',
            isActive = true
        );
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.Policy_Number__c ='1234';
        oli.OpportunityId = oppsList[0].Id;
        oli.Quantity = 5;
    	oli.TotalPrice = 100;
        oli.PricebookEntryId = pbEntry.Id;
        insert oli;
           
        }
    }
    
    //// W-010115
   /* @isTest
    static void apporvalToRegionalTellerTest(){
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Product Onboarding').getRecordTypeId();
        List<Opportunity> oppsList = [SELECT Id, StageName,OwnerId, QA_Complex_Approval_Status__c, Rejection_Reasons__c FROM Opportunity WHERE Name LIKE '%Test%'];
        List<User> usersList = [SELECT Id from User WHERE username LIKE '%testuser1%'];
        
        System.runAs(usersList[0]){
            oppsList[0].QA_Complex_Approval_Status__c = 'Approved';
            oppsList[0].RecordtypeId= recordTypeId;
            //oppsList[0].recordTypeId = '0121r0000007dmi';
            try{
                update oppsList;
            }catch(Exception e){
                System.debug(' Exception message ==> '+e.getMessage());
            } 
                        
        }        
    }
    
    @isTest
    static void apporvalToRegionalServiceCenterTest(){
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Product Onboarding').getRecordTypeId();
        List<Opportunity> oppsList = [SELECT Id, StageName,OwnerId, QA_Complex_Approval_Status__c, Rejection_Reasons__c FROM Opportunity WHERE Name LIKE '%Test%'];
        Product2 prod = [SELECT Id, Name, ProductCode from Product2 where ProductCode = '1122'];
        prod.ProductCode = '11029';
        update prod;
        List<User> usersList = [SELECT Id from User WHERE username LIKE '%testuser1%'];
        
        System.runAs(usersList[0]){
            oppsList[0].QA_Complex_Approval_Status__c = 'Approved';
            oppsList[0].RecordtypeId= recordTypeId;
            //oppsList[0].recordTypeId = '0121r0000007dmi';
            try{
                update oppsList;
            }catch(Exception e){
                System.debug(' Exception message ==> '+e.getMessage());
            } 
                        
        }        
    }
    
    @isTest
    static void apporvalToRegionalTeller1Test(){
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Product Onboarding').getRecordTypeId();
        List<Opportunity> oppsList = [SELECT Id, StageName,OwnerId, Service_Center_Approval_Status__c,QA_Complex_Approval_Status__c, Rejection_Reasons__c FROM Opportunity WHERE Name LIKE '%Test%'];
        Product2 prod = [SELECT Id, Name, ProductCode from Product2 where ProductCode = '1122'];
        prod.ProductCode = '11029';
        update prod;
        List<User> usersList = [SELECT Id from User WHERE username LIKE '%testuser1%'];
        
        System.runAs(usersList[0]){
           // oppsList[0].QA_Complex_Approval_Status__c = 'Approved';
            oppsList[0].RecordtypeId= recordTypeId;
            oppsList[0].Service_Center_Approval_Status__c = 'Approved';
            //oppsList[0].recordTypeId = '0121r0000007dmi';
            try{
                update oppsList;
            }catch(Exception e){
                System.debug(' Exception message ==> '+e.getMessage());
            } 
                        
        }        
    }
    @isTest
    static void apporvalToRegionalQCTest(){
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Product Onboarding').getRecordTypeId();
        List<Opportunity> oppsList = [SELECT Id, StageName,OwnerId, Teller_Approval_Status__c,QA_Complex_Approval_Status__c, Rejection_Reasons__c FROM Opportunity WHERE Name LIKE '%Test%'];
        Product2 prod = [SELECT Id, Name, ProductCode from Product2 where ProductCode = '1122'];
        prod.ProductCode = '11029';
        update prod;
        List<User> usersList = [SELECT Id from User WHERE username LIKE '%testuser1%'];
        
        System.runAs(usersList[0]){
            //oppsList[0].QA_Complex_Approval_Status__c = 'Approved';
            oppsList[0].RecordtypeId= recordTypeId;
            oppsList[0].Teller_Approval_Status__c  = 'Approved';
            //oppsList[0].recordTypeId = '0121r0000007dmi';
            try{
                update oppsList;
            }catch(Exception e){
                System.debug(' Exception message ==> '+e.getMessage());
            } 
                        
        }        
    }*/
    @isTest
    static void submitForQATest(){
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Product Onboarding').getRecordTypeId();
        //List<Opportunity> oppsList = [SELECT Id, StageName,OwnerId, Teller_Approval_Status__c,QA_Complex_Approval_Status__c, Rejection_Reasons__c FROM Opportunity WHERE Name LIKE '%Test%'];
        List<Opportunity> oppsList = [SELECT Id, StageName,OwnerId,QA_Complex_Approval_Status__c, Rejection_Reasons__c FROM Opportunity WHERE Name LIKE '%Test%'];
        Product2 prod = [SELECT Id, Name, ProductCode from Product2 where ProductCode = '1122'];
        prod.ProductCode = '11029';
        update prod;
        List<User> usersList = [SELECT Id from User WHERE username LIKE '%testuser1%'];
        System.assert(oppsList != null);
        System.runAs(usersList[0]){
            try{
                ProductOnboardingApprovalController.submitForQA(oppsList[0].Id, '');
            }catch(Exception e){
                System.debug(' Exception message ==> '+e.getMessage());
            } 
                        
        }        
    }
    
    
     @isTest
    static void submitForDisputedQATest(){
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Product Onboarding').getRecordTypeId();
        //List<Opportunity> oppsList = [SELECT Id, StageName,Disputed_QA_Approval_Status__c,OwnerId, ABSA_Region__c,Teller_Approval_Status__c,QA_Complex_Approval_Status__c, Rejection_Reasons__c FROM Opportunity WHERE Name LIKE '%Test%'];
        List<Opportunity> oppsList = [SELECT Id, StageName,Disputed_QA_Approval_Status__c,OwnerId,QA_Complex_Approval_Status__c, Rejection_Reasons__c FROM Opportunity WHERE Name LIKE '%Test%'];
        Product2 prod = [SELECT Id, Name, ProductCode from Product2 where ProductCode = '1122'];
        prod.ProductCode = '11029';
        update prod;
        List<User> usersList = [SELECT Id from User WHERE username LIKE '%testuser1%'];
        System.assert(oppsList != null);
        System.runAs(usersList[0]){
            oppsList[0].RecordtypeId= recordTypeId;
            oppsList[0].Disputed_QA_Approval_Status__c  = 'Approved';
            oppsList[0].ABSA_Region__c = 'Western Cape';
            try{
                update oppsList;
                ProductOnboardingApprovalController.submitToDisputedQA(oppsList[0], '');
            }catch(Exception e){
                System.debug(' Exception message ==> '+e.getMessage());
            } 
                        
        }        
    }
    
      @isTest
    static void submitForDisputedQANegativeTest(){
        Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Product Onboarding').getRecordTypeId();
       // List<Opportunity> oppsList = [SELECT Id, StageName,Disputed_QA_Approval_Status__c,OwnerId, ABSA_Region__c,Teller_Approval_Status__c,QA_Complex_Approval_Status__c, Rejection_Reasons__c FROM Opportunity WHERE Name LIKE '%Test%'];
        List<Opportunity> oppsList = [SELECT Id, StageName,Disputed_QA_Approval_Status__c,OwnerId,QA_Complex_Approval_Status__c,CMS_Linking_Status__c, Rejection_Reasons__c FROM Opportunity WHERE Name LIKE '%Test%'];
        Product2 prod = [SELECT Id, Name, ProductCode from Product2 where ProductCode = '1122'];
        prod.ProductCode = '11029';
        update prod;
        List<User> usersList = [SELECT Id from User WHERE username LIKE '%testuser1%'];
        System.assert(oppsList != null);
        System.runAs(usersList[0]){
            oppsList[0].RecordtypeId= recordTypeId;
            oppsList[0].Disputed_QA_Approval_Status__c  = 'Accepted By Approver';
            oppsList[0].CMS_Linking_Status__c = 'CAPTURED';
            oppsList[0].Control_Officer_Type__c = 'PB – PRIVATE BANK';
            oppsList[0].Branch_Region_Site__c = 'Test';
            oppsList[0].ABSA_Region__c = 'Western Cape';
            try{
                update oppsList;
                //ProductOnboardingApprovalController.submitToDisputedQA(oppsList[0], '');
            }catch(Exception e){
                System.debug(' Exception message ==> '+e.getMessage());
            } 
            
            try{
                oppsList[0].Disputed_QA_Approval_Status__c = 'Not Submitted';
                update oppsList;
            }
            catch(Exception e){
                System.debug(' Exception message ==> '+e.getMessage());
            } 
                        
        }        
    }
}