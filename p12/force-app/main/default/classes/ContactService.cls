public class ContactService {
    public static void updateUuid(List<Contact> contacts) {
        
        for (Contact contact : contacts) {
            UUID randomUuid = UUID.randomUUID();
            String uuidStr = randomUUID.toString();
            contact.UUID__c = uuidStr;
        }
    }
}