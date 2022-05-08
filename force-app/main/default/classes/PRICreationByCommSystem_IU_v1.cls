/*
 * Integration Utility class for PRICreationByCommSystem Service
 * @author Poulami Banerjee
 * @created 2021-28-06
 */

public class PRICreationByCommSystem_IU_v1 {
    
    public static PRICreationByCommSystem_Req_IB_v1 mapRequestFieldsfotAtwork(Id opportunityP){
        
        PRICreationByCommSystem_Req_IB_v1 requestBean = new PRICreationByCommSystem_Req_IB_v1();
        List<Opportunity> opportunityList = new OpportunitiesSelector().selectByOpportunityId(opportunityP, 1);
        User userP = new UsersSelector().selectById(opportunityList[0].OwnerId);
        Account accountP = new AccountsSelector().selectByOpportunityId(opportunityList[0].AccountId, 1);
        List<OpportunityLineItem> oppItems = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityP);
        PRICreationByCommSystem_Req_IB_v1.ListOfPRI_Contact listOfPriCls = new PRICreationByCommSystem_Req_IB_v1.ListOfPRI_Contact();
        List<PRICreationByCommSystem_Req_IB_v1.PRI_Contact> priContactList = new List<PRICreationByCommSystem_Req_IB_v1.PRI_Contact>();
        PRICreationByCommSystem_Req_IB_v1.PRI_Contact priContact = new PRICreationByCommSystem_Req_IB_v1.PRI_Contact();
        priContact.ContactIdentityInformation = accountP.ID_Number__pc;
        priContact.ContactCIFCode = accountP.CIF__c;
        priContact.ContactFirstName = accountP.FirstName;
        priContact.ContactIdentityType = accountP.ID_Type__pc;
        priContact.ContactLastName = accountP.LastName;
        if (accountP.Phone != '' && accountP.Phone != null) 
        	priContact.ContactCellularPhone = formatPhoneNumber(accountP.Phone);
        if (accountP.PersonHomePhone != '' && accountP.PersonHomePhone != null)
        	priContact.ContactHomePhone = formatPhoneNumber(accountP.PersonHomePhone);
        if (accountP.Work_Phone__c != '' && accountP.Work_Phone__c != null)
        	priContact.ContactWorkPhone = formatPhoneNumber(accountP.Work_Phone__c);
        
        priContactList.add(priContact);
        listOfPriCls.PRI_Contact = priContactList;
        
        PRICreationByCommSystem_Req_IB_v1.Header header = new PRICreationByCommSystem_Req_IB_v1.Header();
        header.Source = 'Salesforce';
        header.MessageId = '4635-6457-5765-7689';
        header.TransactionId = '66666465354654';
        header.ComponentName = 'Test';
        header.Action = 'InsertOrUpdatePRI';
        header.Version = '1.0';
        
        List<PRICreationByCommSystem_Req_IB_v1.ListOfPRI> priListCls = new List<PRICreationByCommSystem_Req_IB_v1.ListOfPRI>();
        PRICreationByCommSystem_Req_IB_v1.ListOfPRI listPRI = new PRICreationByCommSystem_Req_IB_v1.ListOfPRI();
        //List<PRICreationByCommSystem_Req_IB_v1.PRI> priList = new List<PRICreationByCommSystem_Req_IB_v1.PRI>();
        
        if (opportunityList[0].Product_Interest__r.Product__c == 'STI'){
            PRICreationByCommSystem_Req_IB_v1.PRI pri = new PRICreationByCommSystem_Req_IB_v1.PRI();
            pri.CommissionBrokerCode = userP.Advisor_Code__c;
        	pri.CommissionPaymentMethodCode = '1';
        	pri.ExpectedCommission = '0';
        	pri.PremiumFrequency = '1';
        	pri.PolicyIncomeTypeCode = '54';//hard-coded constant value
            if (opportunityList[0].Policy_Inception_Date__c != null) {
                Date dToday = opportunityList[0].Policy_Inception_Date__c;
                Datetime Policy_Inception_Raw = datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
				pri.InceptionDate = Policy_Inception_Raw.format('MM/dd/yyyy');
			}
            else{
        		DateTime Commencement_Date_Raw = System.today();
                pri.InceptionDate = Commencement_Date_Raw.format('dd/MM/yyyy');
            }
        	if (opportunityList[0].Product_Provider__c != null) {
				String providerCode;
				if (opportunityList[0].Product_Provider__c.contains('AIC- ABSA Insurance Company'))
					providerCode = '110';
				else if (opportunityList[0].Product_Provider__c.contains('AIC/WEBSURE'))
					providerCode = '267';
				else if (opportunityList[0].Product_Provider__c.contains('AIC/PLATINUM INSURE WEBSURE'))
					providerCode = '112';
				else if (opportunityList[0].Product_Provider__c.contains('AUTO&GENERAL INSURANCE CO'))
					providerCode = '121';
				pri.ProductProviderCode = providerCode;
			} else
				pri.ProductProviderCode = '002'; 
            if (opportunityList[0].STI_Policy_Number__c != null)
				pri.PolicyNumber = opportunityList[0].STI_Policy_Number__c;
        	pri.ProposalNumber = opportunityList[0].Id;
        	pri.SourceCode = '999999';//hard-coded constant value
        	pri.ListOfPRI_Contact = listOfPriCls;
            listPRI.PRI = pri;
        	priListCls.add(listPRI);
            System.debug('priListCls'+priListCls);
        }else{
        	System.debug('oppItems'+oppItems);
        	for(OpportunityLineItem oppItem : oppItems){
            	PRICreationByCommSystem_Req_IB_v1.PRI pri = new PRICreationByCommSystem_Req_IB_v1.PRI();
            	pri.CommissionBrokerCode = userP.Advisor_Code__c;
        		pri.CommissionPaymentMethodCode = '1';
        		pri.ExpectedCommission = '568';
        		pri.PremiumFrequency = '1';
        		pri.PolicyIncomeTypeCode = '54';//hard-coded constant value
        		DateTime Commencement_Date_Raw = System.today();
        		pri.InceptionDate = Commencement_Date_Raw.format('MM/dd/yyyy');
        		pri.ProductProviderCode = oppItem.Vendor_Code__c;
        		pri.ProposalNumber = oppItem.Id;
        		pri.SourceCode = '999999';//hard-coded constant value
        		pri.ListOfPRI_Contact = listOfPriCls;
                listPRI.PRI = pri;
        		priListCls.add(listPRI);
        	}
        }

        PRICreationByCommSystem_Req_IB_v1.SiebelMessage PRISiebelMessage = new PRICreationByCommSystem_Req_IB_v1.SiebelMessage();
        PRISiebelMessage.ListOfPRI = priListCls;
        
        PRICreationByCommSystem_Req_IB_v1.InsertOrUpdatePRI PRICASA = new PRICreationByCommSystem_Req_IB_v1.InsertOrUpdatePRI();
        PRICASA.SiebelMessage = PRISiebelMessage;
        
        PRICreationByCommSystem_Req_IB_v1.Message PRIMessage = new PRICreationByCommSystem_Req_IB_v1.Message();
        PRIMessage.InsertOrUpdatePRI = PRICASA;
        
        PRICreationByCommSystem_Req_IB_v1.Request PRIRequest = new PRICreationByCommSystem_Req_IB_v1.Request();
        PRIRequest.Header = header;
        PRIRequest.Message = PRIMessage;
        
        requestBean.Request = PRIRequest;
        return requestBean;
    }
    
    private static string formatPhoneNumber (string unformatedPhoneNumber) {
        String formatedPhoneNumber = unformatedPhoneNumber.deleteWhitespace();
    	return formatedPhoneNumber;
    }

}