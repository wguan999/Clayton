public class AccountUtils {
    public static List<Account> accountsByState(String state) {
        return [SELECT ID, Name FROM Account WHERE BillingState  = :state];
    }
}