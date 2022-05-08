@isTest
global class GetWillDetailsMock_ApiRest implements HttpCalloutMock{

    Private String typeTest;
    
    global GetWillDetailsMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"RCMessage": "","WillNo": 41000014420,"ProductType":"WILL","ProductStatus": "FILED","EffectiveDate": 11122003,"BrokerCode": 420044,"BrokerName": "G MILLAR","CIFKey": "BREEDH 007","DomicileSite": 3232,"LanguageCode": "","BigPrint": "","UsrId": "","Testator": "","Testatrix": "","DeliverMethod": "A","AdvisorCode": 0,"AdvisorName": "","SpecialistCode": 0,"SpecialistName": "","SubmittedBy": "CHARISSA VAN DER POGGENPOEL","SubmitterTelno": "0115078272","OldWillNo": "","OldFilingNumber": "","WillFiled": "N","WillLegal": "","FillNo": "280409WHITE   100","DateSigned": 9082005,"DateFiled": 24112003,"DateWithdrawn": 0,"TimeWithdrawn": "00:00:00","ReasonWithdrawn": "","WithdrawnCode": "","WithdrawUserId": "ABJS111","ReferalReason": "","WhoDied": "","CorpCode": "ABS","TransactionSite": "27","CurrentBalance": 0,"BranchCode": "8057","DeceasedDate": 0,"RegistrationDate": 23042007,"WillStatus": "L","WillError": "N","NewAmendRevise": "N","WillOrigin": "I","AcknowledgeLetter": "Y","TrackerStatus": "A","PricingFlag": "Y","CaseNo": 0,"SalaryNo": 0,"DispatchDate": 0,"DraftingBranch": 7023,"Correction": "N","RevisionDate": 0,"ExecutorFeePlan": "Y","FirstFileDate": 1122008,"safeCustodyFee": "Y","EmergencyWill": "N","DateReturned": 0,"StandAlone": "C","Date1stScfLetter": 31012010,"EisDate": 7042004,"LeadCode": 0,"LeadName": "","CSASent": "N","TrustIndicator": "N","SpecialBequestVal": 0,"CasaNo": "","CasaDate": 0,"CasaIndicator": "","FeePaid": "N","AmountDue": 84,"PayDate": 0,"FilePath": "","FileName": "","FileAction": "","FileSize": 0}');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
}