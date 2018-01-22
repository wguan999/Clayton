public class MyController {
    @AuraEnabled
    public static List<Contact> getContacts() {
        return [Select id, Name, Email, Title, Phone From Contact];
    }

}