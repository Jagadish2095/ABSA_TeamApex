/**
  * Mock class for Will registration Lightning Component
  * @author  Himanshu Nimje
  * @created 2019-02-26
  * 
*/

@isTest
global  class WillRegistrationMock_ApiRest implements HttpCalloutMock {
    Private String typeTest;
    Private String typeTest2;
    
    global WillRegistrationMock_ApiRest (final String typeTest, final String typeTest2){
        this.typeTest = typeTest;
        this.typeTest2 = typeTest2;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) { 
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(500);
        }
        
        if(request.getEndpoint().contains('HL Allocate Stock Number')){
            if(typeTest2 == 'Stock Number Fail'){
                String body = '{"stockNumber": null}';
                response.setBody(body);
                response.setStatusCode(500);
            }
            String body = '{"stockNumber": "41000049999"}';
            response.setBody(body);
        }
        
        else if(request.getEndpoint().contains('Create Will Record')){
            if(typeTest2 == 'Create Will Record Fail'){
                
                String body = '{"RC":26,"RCMessage":"TRANSACTION UNSUCCESSFUL","WillNo":41000049999}';
                body = body.replaceAll('\n','').replaceAll('\r','');
                response.setBody(body);
                response.setStatusCode(500);
            }
            String body = '{"RC":0,"RCMessage":"TRANSACTION SUCCESSFUL","WillNo":41000049999}';
            body = body.replaceAll('\n','').replaceAll('\r','');
            response.setBody(body);
        }   
        
        else if(request.getEndpoint().contains('Create Tracker Record')){
            if(typeTest2 == 'Create Tracker Entry Fail'){
                
                String body ='{"nbsapdpo":{"version":"APLO003","returnCode":"0","reasonCode":"0","serviceVersion":"BUSO002","echoKey":"DP78001833596461693"},"awp200so":{"tran":"WILU","func":"TRKA","rc":"101","rcMessage":"AWM200D WILL NO NOT FOUND      04100001442","willNo":"+00000004100001442","updateStatus":""}}' ;
                body = body.replaceAll('\n','').replaceAll('\r','');
                response.setBody(body);
                response.setStatusCode(400);
            }
            String body ='{"nbsapdpo":{"version":"APLO003","returnCode":"0","reasonCode":"0","serviceVersion":"BUSO002","echoKey":"DP78004353188417773"},"awp200so":{"tran":"WILU","func":"TRKA","rc":"0","rcMessage":"TRANSACTION SUCCESSFUL","willNo":"+00000041000049999","updateStatus":""}}' ;
            body = body.replaceAll('\n','').replaceAll('\r','');
            response.setBody(body);
        }
        
        else if(request.getEndpoint().contains('Get Will Details')){
            if(typeTest2 == 'Get Will Details Fail'){
                
                String body ='{"RC":25,"RCMessage":"TRANSACTION SUCCESSFUL","WillNo":41000049999,"ProductType":"WILL","ProductStatus":"OPEN","EffectiveDate":20190306,"BrokerCode":0,"BrokerName":"","CIFKey":"WILLM 0778","DomicileSite":3232,"LanguageCode":"","BigPrint":"","UsrId":"","Testator":"","Testatrix":"","DeliverMethod":"","AdvisorCode":0,"AdvisorName":"","SpecialistCode":0,"SpecialistName":"","SubmittedBy":"","SubmitterTelno":"","OldWillNo":"","OldFilingNumber":"","WillFiled":"N","WillLegal":"","FillNo":"","DateSigned":0,"DateFiled":0,"DateWithdrawn":0,"TimeWithdrawn":"00:00:00","ReasonWithdrawn":"","WithdrawnCode":"","WithdrawUserId":0,"ReferalReason":"","WhoDied":"","CorpCode":"0","TransactionSite":"3232","CurrentBalance":0.0,"BranchCode":"0","DeceasedDate":0,"RegistrationDate":0,"WillStatus":"S","WillError":"N","NewAmendRevise":"N","WillOrigin":"","AcknowledgeLetter":"N","TrackerStatus":"","PricingFlag":"N","CaseNo":0,"SalaryNo":0,"DispatchDate":0,"DraftingBranch":3232,"Correction":"N","RevisionDate":0,"ExecutorFeePlan":"","FirstFileDate":0,"safeCustodyFee":"N","EmergencyWill":"N","DateReturned":0,"StandAlone":"","Date1stScfLetter":0,"EisDate":0,"LeadCode":0,"LeadName":"","CSASent":"","TrustIndicator":"N","SpecialBequestVal":0.0,"CasaNo":"","CasaDate":0,"CasaIndicator":"","FeePaid":"N","AmountDue":0.0,"PayDate":0,"FilePath":"","FileName":"","FileAction":"","FileSize":0}';
                body = body.replaceAll('\n','').replaceAll('\r','');
                response.setBody(body);
                response.setStatusCode(500);
            }
            String body ='{"RC":0,"RCMessage":"TRANSACTION SUCCESSFUL","WillNo":41000049999,"ProductType":"WILL","ProductStatus":"OPEN","EffectiveDate":20190306,"BrokerCode":0,"BrokerName":"","CIFKey":"WILLM 0778","DomicileSite":3232,"LanguageCode":"","BigPrint":"","UsrId":"","Testator":"","Testatrix":"","DeliverMethod":"","AdvisorCode":0,"AdvisorName":"","SpecialistCode":0,"SpecialistName":"","SubmittedBy":"","SubmitterTelno":"","OldWillNo":"","OldFilingNumber":"","WillFiled":"N","WillLegal":"","FillNo":"","DateSigned":0,"DateFiled":0,"DateWithdrawn":0,"TimeWithdrawn":"00:00:00","ReasonWithdrawn":"","WithdrawnCode":"","WithdrawUserId":0,"ReferalReason":"","WhoDied":"","CorpCode":"0","TransactionSite":"3232","CurrentBalance":0.0,"BranchCode":"0","DeceasedDate":0,"RegistrationDate":0,"WillStatus":"S","WillError":"N","NewAmendRevise":"N","WillOrigin":"","AcknowledgeLetter":"N","TrackerStatus":"","PricingFlag":"N","CaseNo":0,"SalaryNo":0,"DispatchDate":0,"DraftingBranch":3232,"Correction":"N","RevisionDate":0,"ExecutorFeePlan":"","FirstFileDate":0,"safeCustodyFee":"N","EmergencyWill":"N","DateReturned":0,"StandAlone":"","Date1stScfLetter":0,"EisDate":0,"LeadCode":0,"LeadName":"","CSASent":"","TrustIndicator":"N","SpecialBequestVal":0.0,"CasaNo":"","CasaDate":0,"CasaIndicator":"","FeePaid":"N","AmountDue":0.0,"PayDate":0,"FilePath":"","FileName":"","FileAction":"","FileSize":0}';
            body = body.replaceAll('\n','').replaceAll('\r','');
            response.setBody(body);
        }
        
        else if(request.getEndpoint().contains('Update Wills Details')){
            if(typeTest2 == 'Update Will Details Fail'){
                
                String body ='{"tran":"WILU","func":"UPDT","rc":"25","rcMessage":"TRANSACTION SUCCESSFUL","willNo":"41000049999","languageCode":"E","bigPrint":"Y","cifkey":"DOEJ   005","usrid":"INTERNET","testator":"JOHN DOE","testatrix":"","deliverMethod":"","advisorCode":"0","brokerCode":"420077","specialistCode":"0","submittedBy":"","submitterTelno":"0112345678","oldWillNo":"0000001747","oldFilingNumber":"0000001747","willFiled":"N","willLegal":"","fillNo":"80409WHITE   099","dateSigned":"10082005","dateFiled":"29082006","dateWithdrawn":"0","timeWithdrawn":"0","reasonWithdrawn":"New will with another Company","withdrawnCode":"","withdrawUserId":"","referalReason":"","whoDied":"","domicileSite":"3232","corpCode":"ABS","transactionSite":"27","tellerNo":"747","effectiveDate":"1012004","currentBalance":"0","productType":"WILL","productStatus":"FILED","branchCode":"8418","deceasedDate":"0","registrationDate":"16012008","willStatus":"?","willError":"?","newAmendRevise":"N","willOrigin":"","acknowledgeLetter":"Y","trackerStatus":"A","pricingFlag":"Y","advisorName":"Henry Cobb","brokerName":"","specialistName":"","caseNo":"0","salaryNo":"0","dispatchDate":"10072003","draftingBranch":"3232","correction":"N","revisionDate":"16012019","executorFeePlan":"Y","firstFileDate":"1122008","safeCustodyFee":"Y","emergencyWill":"N","dateReturned":"0","standAlone":"I","date1stScfLetter":"31012007","eisDate":"10072003","leadCode":"0","leadName":"","csaSent":"N","trustIndicator":"N","specialBequestVal":"0","casaNo":"","casaDate":"0","casaIndicator":"","feePaid":"N","amountDue":"60","payDate":"20120307"}';
                body = body.replaceAll('\n','').replaceAll('\r','');
                response.setBody(body);
                response.setStatusCode(500);
            }
            String body ='{"tran":"WILU","func":"UPDT","rc":"0","rcMessage":"TRANSACTION SUCCESSFUL","willNo":"41000049999","languageCode":"E","bigPrint":"Y","cifkey":"DOEJ   005","usrid":"INTERNET","testator":"JOHN DOE","testatrix":"","deliverMethod":"","advisorCode":"0","brokerCode":"420077","specialistCode":"0","submittedBy":"","submitterTelno":"0112345678","oldWillNo":"0000001747","oldFilingNumber":"0000001747","willFiled":"N","willLegal":"","fillNo":"80409WHITE   099","dateSigned":"10082005","dateFiled":"29082006","dateWithdrawn":"0","timeWithdrawn":"0","reasonWithdrawn":"New will with another Company","withdrawnCode":"","withdrawUserId":"","referalReason":"","whoDied":"","domicileSite":"3232","corpCode":"ABS","transactionSite":"27","tellerNo":"747","effectiveDate":"1012004","currentBalance":"0","productType":"WILL","productStatus":"FILED","branchCode":"8418","deceasedDate":"0","registrationDate":"16012008","willStatus":"?","willError":"?","newAmendRevise":"N","willOrigin":"","acknowledgeLetter":"Y","trackerStatus":"A","pricingFlag":"Y","advisorName":"Henry Cobb","brokerName":"","specialistName":"","caseNo":"0","salaryNo":"0","dispatchDate":"10072003","draftingBranch":"3232","correction":"N","revisionDate":"16012019","executorFeePlan":"Y","firstFileDate":"1122008","safeCustodyFee":"Y","emergencyWill":"N","dateReturned":"0","standAlone":"I","date1stScfLetter":"31012007","eisDate":"10072003","leadCode":"0","leadName":"","csaSent":"N","trustIndicator":"N","specialBequestVal":"0","casaNo":"","casaDate":"0","casaIndicator":"","feePaid":"N","amountDue":"60","payDate":"20120307"}';
            body = body.replaceAll('\n','').replaceAll('\r','');
            response.setBody(body);
            
        }
        
        else if(request.getEndpoint().contains('Debit Order Instruction')){
            if(typeTest2 == 'Debit Order Instruction Fail'){
                
                String body ='{"RC":25,"RCMessage":"Transaction Successful","WillNo":41000049999}';
                body = body.replaceAll('\n','').replaceAll('\r','');
                response.setBody(body);
                response.setStatusCode(500);
            }
            String body ='{"RC":0,"RCMessage":"Transaction Successful","WillNo":41000049999}';
            body = body.replaceAll('\n','').replaceAll('\r','');
            response.setBody(body);
        }
        
        else if(request.getEndpoint().contains('Create Will Banking Details')){
            if(typeTest2 == 'Create Will banking Details Fail'){
                
                String body ='{"RC":25,"RCMessage": "","WillNo": 41000049999,"BranchCode": 632008,"BankName": "ABSA","SiteCode": 8145,"BranchName": "ABSA CENTURION MALL","AccountType": "SAVINGS","AccountNumber": 9573338765,"ClientName": "MRS GINA XABA","EffectiveDate": 20190130}';
                body = body.replaceAll('\n','').replaceAll('\r','');
                response.setBody(body);
                response.setStatusCode(500);
            }
            String body ='{"RC":0,"RCMessage": "","WillNo": 41000049999,"BranchCode": 632008,"BankName": "ABSA","SiteCode": 8145,"BranchName": "ABSA CENTURION MALL","AccountType": "SAVINGS","AccountNumber": 9573338765,"ClientName": "MRS GINA XABA","EffectiveDate": 20190130}';
            body = body.replaceAll('\n','').replaceAll('\r','');
            response.setBody(body);
        }
        
        else if(request.getEndpoint().contains('Add Account To Portfolio')){
            if(typeTest2 == 'Add Account To Portfolio Fail'){
                
                String body ='{"version":"MSG3001","nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":[]}';
                body = body.replaceAll('\n','').replaceAll('\r','');
                response.setBody(body);
                response.setStatusCode(500);
            }
            String body ='{"version":"MSG3001","nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":[]}';
            body = body.replaceAll('\n','').replaceAll('\r','');
            response.setBody(body);
        }
        
        
        else if(request.getEndpoint().contains('Create Assets Liabilities')){
            if(typeTest2 == 'Create Assets Liabilities Fail'){
                
                String body ='{"RC":25,"RCMessage":"AWM150S ASSETS AND LIABILITIES UPDATED","WillNo":41000049999,"Assets":"Y","FarmingTestator":250,"FarmingTestatrix":250,"FixedPropTestator":180,"FixedPropTestatrix":180,"MineralTestator":300,"MineralTestatrix":300,"MovAssetsTestator":275,"MovAssetsTestatrix":275,"BusIntTestator":170,"BusIntTestatrix":170,"LiquidAssTestator":170,"LiquidAssTestatrix":170,"AssetsPayTestator":299,"AssetsPayTestatrix":299,"OtherAssTestator":160,"OtherAssTestatrix":160,"Liabilities":"","MortgaugeTestator":100,"MortgaugeTestatrix":100,"OverDraftTestator":200,"OverDraftTestatrix":200,"CreditTestator":100,"CreditTestatrix":100,"TaxTestator":0,"TaxTestatrix":0,"SuretyTestator":100,"SuretyTestatrix":100,"LoanLTestator":100,"LoanLTestatrix":100,"OtherLTestator":100,"OtherLTestatrix":100,"Assurance":"","MortgageAssTestator":0,"MortgageAssTestatrix":238,"OutCededAssTestator":100,"OutCededAssTestatrix":150,"AssetAmt":3374,"LiabilAmt":1910}';
                body = body.replaceAll('\n','').replaceAll('\r','');
                response.setBody(body);
                response.setStatusCode(500);
            }
            String body ='{"RC":0,"RCMessage":"AWM150S ASSETS AND LIABILITIES UPDATED","WillNo":41000049999,"Assets":"Y","FarmingTestator":250,"FarmingTestatrix":250,"FixedPropTestator":180,"FixedPropTestatrix":180,"MineralTestator":300,"MineralTestatrix":300,"MovAssetsTestator":275,"MovAssetsTestatrix":275,"BusIntTestator":170,"BusIntTestatrix":170,"LiquidAssTestator":170,"LiquidAssTestatrix":170,"AssetsPayTestator":299,"AssetsPayTestatrix":299,"OtherAssTestator":160,"OtherAssTestatrix":160,"Liabilities":"","MortgaugeTestator":100,"MortgaugeTestatrix":100,"OverDraftTestator":200,"OverDraftTestatrix":200,"CreditTestator":100,"CreditTestatrix":100,"TaxTestator":0,"TaxTestatrix":0,"SuretyTestator":100,"SuretyTestatrix":100,"LoanLTestator":100,"LoanLTestatrix":100,"OtherLTestator":100,"OtherLTestatrix":100,"Assurance":"","MortgageAssTestator":0,"MortgageAssTestatrix":238,"OutCededAssTestator":100,"OutCededAssTestatrix":150,"AssetAmt":3374,"LiabilAmt":1910}';
            body = body.replaceAll('\n','').replaceAll('\r','');
            response.setBody(body);
        }
        
        else if(request.getEndpoint().contains('Get Will Banking Details')){
            if(typeTest2 == 'Get Will Banking Details Fail'){
                
                String body ='{"RCMessage": "","WillNo": 41000014420,"ProductType":"WILL","ProductStatus": "FILED","EffectiveDate": 11122003,"BrokerCode": 420044,"BrokerName": "G MILLAR","CIFKey": "BREEDH 007","DomicileSite": 3232,"LanguageCode": "","BigPrint": "","UsrId": "","Testator": "","Testatrix": "","DeliverMethod": "A","AdvisorCode": 0,"AdvisorName": "","SpecialistCode": 0,"SpecialistName": "","SubmittedBy": "CHARISSA VAN DER POGGENPOEL","SubmitterTelno": "0115078272","OldWillNo": "","OldFilingNumber": "","WillFiled": "N","WillLegal": "","FillNo": "280409WHITE   100","DateSigned": 9082005,"DateFiled": 24112003,"DateWithdrawn": 0,"TimeWithdrawn": "00:00:00","ReasonWithdrawn": "","WithdrawnCode": "","WithdrawUserId": 0,"ReferalReason": "","WhoDied": "","CorpCode": "ABS","TransactionSite": "27","CurrentBalance": 0,"BranchCode": "8057","DeceasedDate": 0,"RegistrationDate": 23042007,"WillStatus": "L","WillError": "N","NewAmendRevise": "N","WillOrigin": "I","AcknowledgeLetter": "Y","TrackerStatus": "A","PricingFlag": "Y","CaseNo": 0,"SalaryNo": 0,"DispatchDate": 0,"DraftingBranch": 7023,"Correction": "N","RevisionDate": 0,"ExecutorFeePlan": "Y","FirstFileDate": 1122008,"safeCustodyFee": "Y","EmergencyWill": "N","DateReturned": 0,"StandAlone": "C","Date1stScfLetter": 31012010,"EisDate": 7042004,"LeadCode": 0,"LeadName": "","CSASent": "N","TrustIndicator": "N","SpecialBequestVal": 0,"CasaNo": "","CasaDate": 0,"CasaIndicator": "","FeePaid": "N","AmountDue": 84,"PayDate": 0,"FilePath": "","FileName": "","FileAction": "","FileSize": 0}';
                body = body.replaceAll('\n','').replaceAll('\r','');
                response.setBody(body);
                response.setStatusCode(500);
            }
            String body ='{"RCMessage": "","WillNo": 41000014420,"ProductType":"WILL","ProductStatus": "FILED","EffectiveDate": 11122003,"BrokerCode": 420044,"BrokerName": "G MILLAR","CIFKey": "BREEDH 007","DomicileSite": 3232,"LanguageCode": "","BigPrint": "","UsrId": "","Testator": "","Testatrix": "","DeliverMethod": "A","AdvisorCode": 0,"AdvisorName": "","SpecialistCode": 0,"SpecialistName": "","SubmittedBy": "CHARISSA VAN DER POGGENPOEL","SubmitterTelno": "0115078272","OldWillNo": "","OldFilingNumber": "","WillFiled": "N","WillLegal": "","FillNo": "280409WHITE   100","DateSigned": 9082005,"DateFiled": 24112003,"DateWithdrawn": 0,"TimeWithdrawn": "00:00:00","ReasonWithdrawn": "","WithdrawnCode": "","WithdrawUserId": 0,"ReferalReason": "","WhoDied": "","CorpCode": "ABS","TransactionSite": "27","CurrentBalance": 0,"BranchCode": "8057","DeceasedDate": 0,"RegistrationDate": 23042007,"WillStatus": "L","WillError": "N","NewAmendRevise": "N","WillOrigin": "I","AcknowledgeLetter": "Y","TrackerStatus": "A","PricingFlag": "Y","CaseNo": 0,"SalaryNo": 0,"DispatchDate": 0,"DraftingBranch": 7023,"Correction": "N","RevisionDate": 0,"ExecutorFeePlan": "Y","FirstFileDate": 1122008,"safeCustodyFee": "Y","EmergencyWill": "N","DateReturned": 0,"StandAlone": "C","Date1stScfLetter": 31012010,"EisDate": 7042004,"LeadCode": 0,"LeadName": "","CSASent": "N","TrustIndicator": "N","SpecialBequestVal": 0,"CasaNo": "","CasaDate": 0,"CasaIndicator": "","FeePaid": "N","AmountDue": 84,"PayDate": 0,"FilePath": "","FileName": "","FileAction": "","FileSize": 0}';
            body = body.replaceAll('\n','').replaceAll('\r','');
            response.setBody(body);
        }

        else if(request.getEndpoint().contains('Update Will Banking Details')){
            if(typeTest2 == 'Update Will Banking Details Fail'){
                String body ='{"tran":"WILU","func":"UPDT","rc":"25","rcMessage":"TRANSACTION SUCCESSFUL","willNo":"41000010670","languageCode":"E","bigPrint":"Y","cifkey":"DOEJ   005","usrid":"INTERNET","testator":"JOHN DOE","testatrix":"","deliverMethod":"","advisorCode":"0","brokerCode":"420077","specialistCode":"0","submittedBy":"","submitterTelno":"0112345678","oldWillNo":"0000001747","oldFilingNumber":"0000001747","willFiled":"N","willLegal":"","fillNo":"80409WHITE   099","dateSigned":"10082005","dateFiled":"29082006","dateWithdrawn":"0","timeWithdrawn":"0","reasonWithdrawn":"New will with another Company","withdrawnCode":"","withdrawUserId":"","referalReason":"","whoDied":"","domicileSite":"3232","corpCode":"ABS","transactionSite":"27","tellerNo":"747","effectiveDate":"1012004","currentBalance":"0","productType":"WILL","productStatus":"FILED","branchCode":"8418","deceasedDate":"0","registrationDate":"16012008","willStatus":"?","willError":"?","newAmendRevise":"N","willOrigin":"","acknowledgeLetter":"Y","trackerStatus":"A","pricingFlag":"Y","advisorName":"Henry Cobb","brokerName":"","specialistName":"","caseNo":"0","salaryNo":"0","dispatchDate":"10072003","draftingBranch":"3232","correction":"N","revisionDate":"16012019","executorFeePlan":"Y","firstFileDate":"1122008","safeCustodyFee":"Y","emergencyWill":"N","dateReturned":"0","standAlone":"I","date1stScfLetter":"31012007","eisDate":"10072003","leadCode":"0","leadName":"","csaSent":"N","trustIndicator":"N","specialBequestVal":"0","casaNo":"","casaDate":"0","casaIndicator":"","feePaid":"N","amountDue":"60","payDate":"20120307"}';
                body = body.replaceAll('\n','').replaceAll('\r','');
                response.setBody(body);
                response.setStatusCode(500);
            }
            String body ='{"tran":"WILU","func":"UPDT","rc":"0","rcMessage":"TRANSACTION SUCCESSFUL","willNo":"41000010670","languageCode":"E","bigPrint":"Y","cifkey":"DOEJ   005","usrid":"INTERNET","testator":"JOHN DOE","testatrix":"","deliverMethod":"","advisorCode":"0","brokerCode":"420077","specialistCode":"0","submittedBy":"","submitterTelno":"0112345678","oldWillNo":"0000001747","oldFilingNumber":"0000001747","willFiled":"N","willLegal":"","fillNo":"80409WHITE   099","dateSigned":"10082005","dateFiled":"29082006","dateWithdrawn":"0","timeWithdrawn":"0","reasonWithdrawn":"New will with another Company","withdrawnCode":"","withdrawUserId":"","referalReason":"","whoDied":"","domicileSite":"3232","corpCode":"ABS","transactionSite":"27","tellerNo":"747","effectiveDate":"1012004","currentBalance":"0","productType":"WILL","productStatus":"FILED","branchCode":"8418","deceasedDate":"0","registrationDate":"16012008","willStatus":"?","willError":"?","newAmendRevise":"N","willOrigin":"","acknowledgeLetter":"Y","trackerStatus":"A","pricingFlag":"Y","advisorName":"Henry Cobb","brokerName":"","specialistName":"","caseNo":"0","salaryNo":"0","dispatchDate":"10072003","draftingBranch":"3232","correction":"N","revisionDate":"16012019","executorFeePlan":"Y","firstFileDate":"1122008","safeCustodyFee":"Y","emergencyWill":"N","dateReturned":"0","standAlone":"I","date1stScfLetter":"31012007","eisDate":"10072003","leadCode":"0","leadName":"","csaSent":"N","trustIndicator":"N","specialBequestVal":"0","casaNo":"","casaDate":"0","casaIndicator":"","feePaid":"N","amountDue":"60","payDate":"20120307"}';
            body = body.replaceAll('\n','').replaceAll('\r','');
            response.setBody(body);
        }
        
        else if(request.getEndpoint().contains('Create Will Banking Details')){
            if(typeTest2 == 'Create Will Banking Details Fail'){
                
                String body ='{"WillNo":41000003904,"CIFKey":"WILLM 0778","DomicileSite":3232,"CorpCode":"ABS","TransactionSite":3232,"TellerNo":0,"EffectiveDate":20190128}';
                body = body.replaceAll('\n','').replaceAll('\r','');
                response.setBody(body);
                response.setStatusCode(500);
            }
            String body ='{"WillNo":41000003904,"CIFKey":"WILLM 0778","DomicileSite":3232,"CorpCode":"ABS","TransactionSite":3232,"TellerNo":0,"EffectiveDate":20190128}';
            body = body.replaceAll('\n','').replaceAll('\r','');
            response.setBody(body);
        }
        
        
        System.debug('ENDPOINT: ' + request.getEndpoint());
        return response;    
    }
}