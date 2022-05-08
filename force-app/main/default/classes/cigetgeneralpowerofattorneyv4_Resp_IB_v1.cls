public class cigetgeneralpowerofattorneyv4_Resp_IB_v1 extends Base_IB{
    
    @AuraEnabled public Integer statusCode{get;set;}
    @AuraEnabled public String StatusMessage {get;set;}
    @AuraEnabled public String status{get;set;}
    
    @AuraEnabled public CIgetGeneralPowerOfAttorneyV4Response CIgetGeneralPowerOfAttorneyV4Response{get;set;}
	public class outputTable{
		@AuraEnabled public String dateIssued{get;set;}
		@AuraEnabled public String idNbr{get;set;}
		@AuraEnabled public String consentCollChqsInd{get;set;}
		@AuraEnabled public String idType{get;set;}
		@AuraEnabled public String existClientCode{get;set;}
		@AuraEnabled public String name{get;set;}
		@AuraEnabled public String physicalAdd1{get;set;}
		@AuraEnabled public String surname{get;set;}
		@AuraEnabled public String physicalAdd2{get;set;}
		@AuraEnabled public String initials{get;set;}
		@AuraEnabled public String physicalSuburb{get;set;}
		@AuraEnabled public String title{get;set;}
		@AuraEnabled public String physicalTown{get;set;}
		@AuraEnabled public String clientNationality{get;set;}
		@AuraEnabled public String physicalPostal{get;set;}
		@AuraEnabled public String countryOfOrigin{get;set;}
		@AuraEnabled public String gender{get;set;}
		@AuraEnabled public String emailAddress{get;set;}
		@AuraEnabled public String birthDate{get;set;}
		@AuraEnabled public String homeTelephone{get;set;}
		@AuraEnabled public String occupationStatus{get;set;}
		@AuraEnabled public String homeTelCode{get;set;}
		@AuraEnabled public String occupationCode{get;set;}
		@AuraEnabled public String birthOpCountry{get;set;}
		@AuraEnabled public String designation{get;set;}
		@AuraEnabled public String countryResAddress{get;set;}
	}
	public class nbsmsgo3{
		@AuraEnabled public list<msgEntry> msgEntry{get;set;}
		@AuraEnabled public String nbrUserErrs{get;set;}
		@AuraEnabled public String nbrUserMsgs{get;set;}
		@AuraEnabled public String sysErrTxt{get;set;}
		@AuraEnabled public String version{get;set;}
	}
	public class nbsapdpo{
		@AuraEnabled public String serviceVersion{get;set;}
		@AuraEnabled public String reasonCode{get;set;}
		@AuraEnabled public String returnCode{get;set;}
	}
	public class msgEntry{
		@AuraEnabled public String msgClass{get;set;}
		@AuraEnabled public String msgTxt{get;set;}
		@AuraEnabled public String msgErrInd{get;set;}
		@AuraEnabled public String msgCode{get;set;}
	}
	public class cip081do{
		@AuraEnabled public String restartKeyOutput{get;set;}
		@AuraEnabled public String nbrSignRetrieved{get;set;}
		@AuraEnabled public String clientCodeOut{get;set;}
		@AuraEnabled public outputTable outputTable{get;set;}
	}
	public class CIgetGeneralPowerOfAttorneyV4Response{
		@AuraEnabled public nbsmsgo3 nbsmsgo3{get;set;}
		@AuraEnabled public cip081do cip081do{get;set;}
		@AuraEnabled public nbsapdpo nbsapdpo{get;set;}
	}
     public static cigetgeneralpowerofattorneyv4_Resp_IB_v1 dummyResponse(){
        cigetgeneralpowerofattorneyv4_Resp_IB_v1 responseBean = new cigetgeneralpowerofattorneyv4_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.StatusMessage='SUCCESS';
        cigetgeneralpowerofattorneyv4_Resp_IB_v1.msgEntry msgEntrybean = new cigetgeneralpowerofattorneyv4_Resp_IB_v1.msgEntry(); 
        List<cigetgeneralpowerofattorneyv4_Resp_IB_v1.msgEntry> msgEntrybeanList = new List<cigetgeneralpowerofattorneyv4_Resp_IB_v1.msgEntry>();
        msgEntrybean.msgTxt = 'test';
        msgEntrybean.msgErrInd = 'test';
        msgEntrybean.msgCode = 'test';
        msgEntrybean.msgClass = 'test';
        cigetgeneralpowerofattorneyv4_Resp_IB_v1.nbsmsgo3 nbsmsgo3bean = new cigetgeneralpowerofattorneyv4_Resp_IB_v1.nbsmsgo3();
        msgEntrybeanList.add(msgEntrybean);
        nbsmsgo3bean.msgEntry = msgEntrybeanList;
        nbsmsgo3bean.nbrUserErrs = 'test';
        nbsmsgo3bean.version = 'test';
        nbsmsgo3bean.sysErrTxt = 'test';
        nbsmsgo3bean.nbrUserMsgs = 'test';
        
        cigetgeneralpowerofattorneyv4_Resp_IB_v1.outputTable outputTablebean = new cigetgeneralpowerofattorneyv4_Resp_IB_v1.outputTable();
        outputTablebean.dateIssued = 'test';
        outputTablebean.idNbr = 'test';
        outputTablebean.consentCollChqsInd = 'test';
        outputTablebean.idType = 'test';
        outputTablebean.existClientCode = 'test';
        outputTablebean.name = 'test';
        outputTablebean.physicalAdd1 = 'test';
        outputTablebean.surname = 'test';
        outputTablebean.physicalAdd2= 'test';
        outputTablebean.initials = 'test';
        outputTablebean.physicalSuburb = 'test';
        outputTablebean.title= 'test';
        outputTablebean.physicalTown= 'test';
        outputTablebean.clientNationality = 'test';
        outputTablebean.physicalPostal = 'test';
        outputTablebean.countryOfOrigin = 'test';
        outputTablebean.gender = 'test';
        outputTablebean.emailAddress = 'test';
        outputTablebean.birthDate = 'test';
        outputTablebean.homeTelephone = 'test';
        outputTablebean.occupationStatus = 'test';
        outputTablebean.homeTelCode = 'test';
        outputTablebean.occupationCode = 'test';
        outputTablebean.birthOpCountry = 'test';
        outputTablebean.designation = 'test';
        outputTablebean.countryResAddress = 'test';
		
        cigetgeneralpowerofattorneyv4_Resp_IB_v1.cip081do cip081dobean = new cigetgeneralpowerofattorneyv4_Resp_IB_v1.cip081do();
		cip081dobean.restartKeyOutput = 'test';
		cip081dobean.nbrSignRetrieved = 'test';
		cip081dobean.clientCodeOut = 'test';
        cip081dobean.outputTable = outputTablebean;
		
		
        cigetgeneralpowerofattorneyv4_Resp_IB_v1.nbsapdpo nbsapdpobean = new cigetgeneralpowerofattorneyv4_Resp_IB_v1.nbsapdpo();
        nbsapdpobean.reasonCode = 'test';
        nbsapdpobean.returnCode = 'test';
        cigetgeneralpowerofattorneyv4_Resp_IB_v1.cigetgeneralpowerofattorneyv4Response cigetgeneralpowerofattorneyv4Responsebean=  new cigetgeneralpowerofattorneyv4_Resp_IB_v1.cigetgeneralpowerofattorneyv4Response();
        cigetgeneralpowerofattorneyv4Responsebean.nbsmsgo3 = nbsmsgo3bean;
        cigetgeneralpowerofattorneyv4Responsebean.nbsapdpo = nbsapdpobean; 
        responsebean.cigetgeneralpowerofattorneyv4Response = cigetgeneralpowerofattorneyv4Responsebean;
        return responseBean;
    }
}