/*
 * Request Integration Bean for CCApplicationService applyPreScreen
 * @author Aaron Castelyn : Absa
 * @created 2020-11-12 
 */

public class CCApplicationService_PreScreen_Req_IB_v1 extends Base_IB {
    public class KnockOutQuestions {
        public String casaClauseRead;
        public String curatorship;
    }

    public class RequestCommons {
        public String channelCode;
        public String employeeNumber;
        public String messageLanguage;
        public String siteId;
        public String systemName;
        public String userId;
    }

    public Apply apply;

    public class Arg0 {
        public Application application;
        public RequestCommons requestCommons;
        public String validateDetails;
    }

    public class ExternalConsumerData {
        public String customerId;
        public String customerSourceCode;
        public String customerSourceReferenceNumber;
    }

    public class Apply {
        public Arg0 arg0;
    }

    public class PrimaryApplicant {
        public String clientCode;
        public String idOrRegistrationNo;
        public String identificationType;
        public String placeOfResidence;
        public String titleType; 
        public String initials;
        public String surname;
        public String firstNames;
        public String emailAddress;
        public cellPhoneNumber cellPhoneNumber;
        
    }

    public class Rehabilitation {
        public String debtCounsellingClearanceDate;
        public String everBeenDeclaredInsolvent;
        public String everUndergoneDebtCounselling;
        public String rehabilitationDate;
    }

    public class Application {
        public String applicationNumber;
        public String applicationType;
        public String campaignId;
        public String channelCode;
        public String corpCode;
        public String creditStatus;
        public String customerType;
        public ExternalConsumerData externalConsumerData;
        public KnockOutQuestions knockOutQuestions;
        public String marketingSiteId;
        public String productGroupId;
        public String transactionType;
        public PrimaryApplicant primaryApplicant;
    }

    public class cellPhoneNumber{
    public String z_number;	// in json: number	
	}

	public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"number":', '"z_number":');        
	}
    
    public static CCApplicationService_PreScreen_Req_IB_v1 getNewInstance()
    {
        CCApplicationService_PreScreen_Req_IB_v1 requestBean =  new CCApplicationService_PreScreen_Req_IB_v1();
        
        requestBean.apply = new CCApplicationService_PreScreen_Req_IB_v1.apply();
        
        requestBean.apply.arg0 = new CCApplicationService_PreScreen_Req_IB_v1.Arg0();
        requestBean.apply.arg0.requestCommons = new CCApplicationService_PreScreen_Req_IB_v1.RequestCommons();   
        
        requestBean.apply.arg0.application = new CCApplicationService_PreScreen_Req_IB_v1.Application();
        requestBean.apply.arg0.application.externalConsumerData = new CCApplicationService_PreScreen_Req_IB_v1.ExternalConsumerData();
        requestBean.apply.arg0.application.knockOutQuestions = new CCApplicationService_PreScreen_Req_IB_v1.KnockOutQuestions();
        requestBean.apply.arg0.application.primaryApplicant = new CCApplicationService_PreScreen_Req_IB_v1.PrimaryApplicant();
        requestBean.apply.arg0.application.primaryApplicant.cellPhoneNumber =new CCApplicationService_PreScreen_Req_IB_v1.cellPhoneNumber();

		return requestBean;
    }
    
    public override void setIntegrationTranslations()
    {
        integrationTranslationsMap = new Map<String, String>();
        integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.titleType','CIFCodesList;Titles' ); 
    }

   public static CCApplicationService_PreScreen_Req_IB_v1 createDummyRequest(){
        CCApplicationService_PreScreen_Req_IB_v1 requestBean = CCApplicationService_PreScreen_Req_IB_v1.getNewInstance();
        
        requestBean.apply.arg0.application.applicationNumber = '';	
        requestBean.apply.arg0.application.applicationType = 'P';
        requestBean.apply.arg0.application.campaignId = '';	
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        
        requestBean.apply.arg0.application.externalConsumerData.customerId = '9407229216088';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'ABSA';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = 'This is a test3';

        requestBean.apply.arg0.application.knockOutQuestions.curatorship = 'true';
        requestBean.apply.arg0.application.knockOutQuestions.casaClauseRead = 'true';
        
        requestBean.apply.arg0.application.marketingSiteId = '4592';
        requestBean.apply.arg0.application.productGroupId = '1';
        requestBean.apply.arg0.application.transactionType = '';
        
        requestBean.apply.arg0.application.primaryApplicant.firstNames = 'FABIAN GERONE';
        requestBean.apply.arg0.application.primaryApplicant.idOrRegistrationNo ='ddddddddddddddddddddddddddddddddddddddddddddddddddddddddd';
        requestBean.apply.arg0.application.primaryApplicant.identificationType = '01';
        requestBean.apply.arg0.application.primaryApplicant.initials = 'FG';
        requestBean.apply.arg0.application.primaryApplicant.titleType = '01';
        requestBean.apply.arg0.application.primaryApplicant.surname = 'PALADI';
        requestBean.apply.arg0.application.primaryApplicant.placeOfResidence = '01';

        requestBean.apply.arg0.application.primaryApplicant.cellPhoneNumber.z_number =  '0725845698';

        requestBean.apply.arg0.requestCommons.channelCode = 'B';
        requestBean.apply.arg0.requestCommons.employeeNumber = '9019050';
        requestBean.apply.arg0.requestCommons.messageLanguage ='E';
        requestBean.apply.arg0.requestCommons.siteId = '4592';
        requestBean.apply.arg0.requestCommons.systemName = 'BSF';
        requestBean.apply.arg0.requestCommons.userId ='ABAJ013';

        requestBean.apply.arg0.validateDetails ='true';

        return requestBean;
    }
}