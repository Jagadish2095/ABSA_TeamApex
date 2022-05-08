/**
 * @description       : Response Class for Entity Create (Credit Lens)
 * @author            : Tawanda M.
 * @group             :
 * @last modified on  : 08-11-2021
 * @last modified by  : Tawanda M.
 **/
public class CreditLens_Create_Entity_Resp_IB_v1 extends Base_IB {
  public List<PayLoad> payLoad;
  public status status_z;

  /**
   * @description Structure Element
   * @author Tawanda M. | 07-20-2021
   **/
  public class status {
  }

  /**
   * @description Structure Element
   * @author Tawanda M. | 07-20-2021
   **/
  public class PayLoad {
    public Integer EntityId;
  }

  public override void setFieldNameSubstitutions() {
    fieldNameSubstitutionMap = new Map<String, String>();
    fieldNameSubstitutionMap.put('status', 'status_z');
  }
}