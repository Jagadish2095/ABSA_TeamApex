public class CASAPrimaryClientScreening_Req_IB_v1 extends Base_IB{
    
    public String channel;
    public String application;
    public String trace;
    public String firstName;
    public String surnameComp;
    public String idType;
    public String idRegNo;
    public String clientTypeGrp;
    public String dob;
    public String nationality;
    public String town;
    public String territory;
    public String cntryOfRes;
    public String cntryOfBirth;
    public String registerCity;
    public String countryPassport;
    public String headofficeTown;
    public String headofficeCntry;
    public String headofficeOtherCntry1;
    public String headofficeOtherCntry2;
    public String headofficeOtherCntry3;
    public String headofficeOtherCntry4;
    public String headofficeOtherCntry5;
    public String sbu;
    public String originatingSys;
    public String branch;
    public String teller;
    
   /* public override void setRequiredFields(){
        
        requiredFieldsSet = new Set<String>();
        
        requiredFieldsSet.add('firstName');
        requiredFieldsSet.add('surnameComp');
        requiredFieldsSet.add('idType');
        requiredFieldsSet.add('idRegNo');
        requiredFieldsSet.add('clientTypeGrp');
        requiredFieldsSet.add('dob');
        requiredFieldsSet.add('nationality');
        requiredFieldsSet.add('cntryOfRes');
        requiredFieldsSet.add('sbu');
        requiredFieldsSet.add('originatingSys');
        requiredFieldsSet.add('branch');
        requiredFieldsSet.add('teller');
    }
     */
    public void createDummyRequest(){
        
        this.channel = 'AFS';
        this.application = 'SALESFORCE';
        this.trace = 'N';
        this.firstName = 'Joe';
        this.surnameComp = 'Smit';
        this.idType = '1';
        this.idRegNo = '5712085410087';
        this.clientTypeGrp = 'I';
        this.dob = '19571208';
        this.nationality = 'SOU01';
        this.town = 'HATFIELD';
        this.territory = '';
        this.cntryOfRes = 'SO003';
        this.cntryOfBirth = 'SO003';
        this.registerCity = '';
        this.countryPassport = 'SO003';
        this.headofficeTown = '';
        this.headofficeCntry = '';
        this.headofficeOtherCntry1 = '';
        this.headofficeOtherCntry2 = '';
        this.headofficeOtherCntry3 = '';
        this.headofficeOtherCntry4 = '';
        this.headofficeOtherCntry5 = '';
        this.sbu = '61';
        this.originatingSys = 'SIEBEL';
        this.branch = '3456';
        this.teller = 'SADMIN';
    }
}