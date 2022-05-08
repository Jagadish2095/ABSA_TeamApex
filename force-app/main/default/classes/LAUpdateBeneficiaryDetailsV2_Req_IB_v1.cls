/*
 * Request Integration Bean for LAUpdateBeneficiaryDetailsV2 Service
 * @author Nelson Chisoko
 * @created 2020-10-15
 */
public class LAUpdateBeneficiaryDetailsV2_Req_IB_v1 extends Base_IB {
    public LAupdateBeneficiaryDetailsV2 LAupdateBeneficiaryDetailsV2;

    public class Nbsapdpi {
        public String channel;
        public String application;
        public String trace;
    }

    public class PercentSplitArray {
        public String lifeClientCodeCounter;
        public String lifeClientCodeArray;
        public String roleType;
        public String roleNumber;
        public String percentSplit;
    }

    public class La950p9i {
        public String action;
        public String policyNumber;
        public String businessSourceIndicator;
        public String sourceOfIncome;
        public String sourceOfFund;
        public String lifeClientCode;
        public String changeEffectiveDate;
        public String surname;
        public String initial;
        public String dateOfBirth;
        public String titleCode;
        public String language;
        public String identityNumber;
        public String idType;
        public String contactPerson;
        public String contactTelephoneNumber;
        public String preferredCommunication;
        public String emailAddress;
        public String addressLine1;
        public String addressLine2;
        public String suburb;
        public String city;
        public String postalCode;
        public String relationshipCode;
        public String lifeClientCodeCount;
        public List<PercentSplitArray> percentSplitArray;
    }

    public class LAupdateBeneficiaryDetailsV2 {
        public Nbsapdpi nbsapdpi;
        public La950p9i la950p9i;
    }

    public override void setIntegrationTranslations(){

        integrationTranslationsMap = new Map<String,String>();
        integrationTranslationsMap.put('LAupdateBeneficiaryDetailsV2.la950p9i.relationshipCode', 'CIF;Policy Relationship');
        integrationTranslationsMap.put('LAupdateBeneficiaryDetailsV2.la950p9i.percentSplitArray.roleType', 'CIF;Role Type');
        integrationTranslationsMap.put('LAupdateBeneficiaryDetailsV2.la950p9i.idType', 'CIF;Policy ID Type');
        integrationTranslationsMap.put('LAupdateBeneficiaryDetailsV2.la950p9i.titleCode', 'CIF;Title');
    }

    public static LAUpdateBeneficiaryDetailsV2_Req_IB_v1 createDummyRequest() {
        LAUpdateBeneficiaryDetailsV2_Req_IB_v1 requestBean = new LAUpdateBeneficiaryDetailsV2_Req_IB_v1();
        requestBean.LAupdateBeneficiaryDetailsV2 = new LAUpdateBeneficiaryDetailsV2_Req_IB_v1.LAupdateBeneficiaryDetailsV2();
        requestBean.LAupdateBeneficiaryDetailsV2.nbsapdpi = new LAUpdateBeneficiaryDetailsV2_Req_IB_v1.Nbsapdpi();
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i = new LAUpdateBeneficiaryDetailsV2_Req_IB_v1.La950p9i();

        requestBean.LAupdateBeneficiaryDetailsV2.nbsapdpi.channel = 'Salesforce';
        requestBean.LAupdateBeneficiaryDetailsV2.nbsapdpi.application = 'Salesforce';
        requestBean.LAupdateBeneficiaryDetailsV2.nbsapdpi.trace = 'N';

        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.action = 'M';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.policyNumber = '6440946981';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.businessSourceIndicator = 'AO';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.sourceOfIncome = '20';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.sourceOfFund = '20';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.lifeClientCode = '0001220158';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.changeEffectiveDate = '2019-08-16';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.surname = 'Grey';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.initial = 'JG';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.dateOfBirth = '1992-01-01';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.titleCode = '2';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.language = 'E';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.identityNumber = 'M123456';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.idType = '3';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.contactPerson = 'Jean';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.contactTelephoneNumber = '0710000000';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.preferredCommunication = '1';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.emailAddress = 'abc@absa.co.za';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.addressLine1 = '12 abc';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.addressLine2 = 'test';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.suburb = 'BETHAL';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.city = 'BETHAL';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.postalCode = '2309';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.relationshipCode = 'SPOU';
        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.lifeClientCodeCount = '1';

        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.percentSplitArray = new List<LAUpdateBeneficiaryDetailsV2_Req_IB_v1.PercentSplitArray>();
        LAUpdateBeneficiaryDetailsV2_Req_IB_v1.PercentSplitArray percentSplitObj = new LAUpdateBeneficiaryDetailsV2_Req_IB_v1.PercentSplitArray();
        percentSplitObj.lifeClientCodeCounter = '1';
        percentSplitObj.lifeClientCodeArray = '0001167007';
        percentSplitObj.roleType = 'BEN';
        percentSplitObj.roleNumber = '1';
        percentSplitObj.percentSplit = '100';

        requestBean.LAupdateBeneficiaryDetailsV2.la950p9i.percentSplitArray.add(percentSplitObj);

        return requestBean;
    }
}