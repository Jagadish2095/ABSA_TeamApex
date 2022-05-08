/**
 * @description       : Request Class for Entity Create (Credit Lens)
 * @author            : Tawanda M.
 * @group             :
 * @last modified on  : 12-02-2021
 * @last modified by  : Tawanda M.
 **/
public class CreditLens_Create_Entity_Req_IB_v1 extends Base_IB {
  public String EntityType;
  public String ShortName;
  public String BusinessPortfolio;
  public String CreditPortfolio;
  public String LongName;
  public String SystemId;
  public Integer PlaceOfResidence;
  public String CountryOfInc;
  public String ClientCode;
  public String FirmType;
  public String CountryOfRisk;
  public String Currency_Z;
  public String SaSicCode;

  
  /**
  * @description Structure Element
  * @author Tawanda M. | 11-15-2021 
  * @param EntityType 
  * @param ShortName 
  * @param BusinessPortfolio 
  * @param CreditPortfolio 
  * @param LongName 
  * @param SystemId 
  * @param PlaceOfResidence 
  * @param CountryOfInc 
  * @param ClientCode 
  * @param FirmType 
  * @param CountryOfRisk 
  * @param Currency_Z 
  * @param SaSicCode 
  **/
  public CreditLens_Create_Entity_Req_IB_v1(
    String EntityType,
    String ShortName,
    String BusinessPortfolio,
    String CreditPortfolio,
    String LongName,
    String SystemId,
    Integer PlaceOfResidence,
    String CountryOfInc,
    String ClientCode,
    String FirmType,
    String CountryOfRisk,
    String Currency_Z,
    String SaSicCode
  ) {
    this.EntityType = EntityType;
    this.ShortName = ShortName;
    this.BusinessPortfolio = BusinessPortfolio;
    this.CreditPortfolio = CreditPortfolio;
    this.LongName = LongName;
    this.SystemId = SystemId;
    this.PlaceOfResidence = PlaceOfResidence;
    this.CountryOfInc = CountryOfInc;
    this.ClientCode = ClientCode;
    this.FirmType = FirmType;
    this.CountryOfRisk = CountryOfRisk;
    this.Currency_Z = Currency_Z;
    this.SaSicCode = SaSicCode;
  }

  public override void setFieldNameSubstitutions() {
    fieldNameSubstitutionMap = new Map<String, String>();
    fieldNameSubstitutionMap.put('Currency', 'Currency_Z');
  }
}