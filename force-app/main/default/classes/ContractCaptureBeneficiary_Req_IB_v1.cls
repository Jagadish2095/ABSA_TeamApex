/*
 * Request Integration Bean for contractCaptureBeneficiary Service
 * @author chandra Bhushan Singh
 * @created 2021-02-03
 */

public class ContractCaptureBeneficiary_Req_IB_v1 extends Base_IB {
    public Contract_Capture_Beneficary Contract_Capture_Beneficary;

    public class Contract_Capture_Beneficary {
        public String pstrSessionGID;
        public String pstrPolicyNumber;
        public PobjBeneficaryInformation pobjBeneficaryInformation;
        public Integer pintSourceofFundsID;
    }

    public class PobjBeneficaryInformation {
        public List<V3_BeneficaryCaptureInformation> V3_BeneficaryCaptureInformation;
    }

    public class V3_BeneficaryCaptureInformation {
        public String AddressLine1;
        public String AddressLine2;
        public String City;
        public String ClientGID;
        public String ContactNumber;
        public String ContactTypeID;
        public String DateOfBirth;
        public String EmailAddress;
        public String FirstName;
        public String IdentificationNumber;
        public String IdentifyTypeID;
        public String Initials;
        public String Percentage;
        public Integer PostalCode;
        public String RelationShipID;
        public String Suburb;
        public String Surname;
        public String TitleID;
    }

    public static ContractCaptureBeneficiary_Req_IB_v1 createDummyRequest() {
        ContractCaptureBeneficiary_Req_IB_v1 requestBean = new ContractCaptureBeneficiary_Req_IB_v1();
        requestBean.Contract_Capture_Beneficary = new ContractCaptureBeneficiary_Req_IB_v1.Contract_Capture_Beneficary();
        requestBean.Contract_Capture_Beneficary.pstrSessionGID = '18adf2f0-7366-4b50-807f-be93cfa21b95';
        requestBean.Contract_Capture_Beneficary.pstrPolicyNumber = '6635635212';
        requestBean.Contract_Capture_Beneficary.pobjBeneficaryInformation = new ContractCaptureBeneficiary_Req_IB_v1.pobjBeneficaryInformation();
        requestBean.Contract_Capture_Beneficary.pintSourceofFundsID = 13540;

        requestBean.Contract_Capture_Beneficary.pobjBeneficaryInformation.V3_BeneficaryCaptureInformation = new List<ContractCaptureBeneficiary_Req_IB_v1.V3_BeneficaryCaptureInformation>();
        ContractCaptureBeneficiary_Req_IB_v1.V3_BeneficaryCaptureInformation v3BeneficaryCaptureInformation = new ContractCaptureBeneficiary_Req_IB_v1.V3_BeneficaryCaptureInformation();
        v3BeneficaryCaptureInformation.AddressLine1 = 'TestAddress1';
        v3BeneficaryCaptureInformation.AddressLine2 = 'TestAddress2';
        v3BeneficaryCaptureInformation.City = 'TestCity';
        v3BeneficaryCaptureInformation.ClientGID = 'B99C4E44-E8B8-45BF-9D94-A06700A72D9F';
        v3BeneficaryCaptureInformation.ContactNumber = '0824139647';

        v3BeneficaryCaptureInformation.ContactTypeID = '4z';
        v3BeneficaryCaptureInformation.DateOfBirth = '19780308';
        v3BeneficaryCaptureInformation.EmailAddress = 'test@absa.co.zaa';
        v3BeneficaryCaptureInformation.FirstName = 'test';
        v3BeneficaryCaptureInformation.IdentificationNumber = '7808035166080z';

        v3BeneficaryCaptureInformation.IdentifyTypeID = '1';
        v3BeneficaryCaptureInformation.Initials = 'R';
        v3BeneficaryCaptureInformation.Percentage = '50';
        v3BeneficaryCaptureInformation.PostalCode = 1401;
        v3BeneficaryCaptureInformation.RelationShipID = '1';

        v3BeneficaryCaptureInformation.Suburb = 'Test Ext';
        v3BeneficaryCaptureInformation.Surname = 'TestSurname';
        v3BeneficaryCaptureInformation.TitleID = '1';

        requestBean.Contract_Capture_Beneficary.pobjBeneficaryInformation.V3_BeneficaryCaptureInformation.add(v3BeneficaryCaptureInformation);

        return requestBean;
    }

    public override void setIntegrationTranslations() {
        integrationTranslationsMap = new Map<String, String>();
        integrationTranslationsMap.put('Contract_Capture_Beneficary.pobjBeneficaryInformation.V3_BeneficaryCaptureInformation.RelationShipID', 'Exergy;Policy Relationship');
        integrationTranslationsMap.put('Contract_Capture_Beneficary.pobjBeneficaryInformation.V3_BeneficaryCaptureInformation.IdentifyTypeID', 'Exergy;Policy ID Type');
        integrationTranslationsMap.put('Contract_Capture_Beneficary.pobjBeneficaryInformation.V3_BeneficaryCaptureInformation.TitleID', 'Exergy;Title');
        integrationTranslationsMap.put('Contract_Capture_Beneficary.pobjBeneficaryInformation.V3_BeneficaryCaptureInformation.ContactTypeID', 'Exergy;Policy Contact Type');
    }
}