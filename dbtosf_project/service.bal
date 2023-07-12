import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name) returns string|error {
        // Send a response back to the caller.
        if name is "" {
            return error("name should not be empty!");
        }
        return "Hello, " + name;
    }

    resource function post contacts(@http:Payload ContactsInput contactsInput) returns error?|ContactsOutput {
        ContactsOutput contactsOutput = transform(contactsInput);
        return contactsOutput;
    }
}

type Attributes record {
    string 'type;
    string url;
};

type RecordsItem record {
    Attributes attributes;
    string Id;
    string FirstName;
    string LastName;
    string Email;
    string Phone;
};

type ContactsInput record {
    int totalSize;
    boolean done;
    RecordsItem[] records;
};

type ContactsItem record {
    string fullName;
    string phoneNumber;
    string email;
    string id;
};

type ContactsOutput record {
    int numberOfContacts;
    ContactsItem[] contacts;
};

function transform(ContactsInput contactsInput) returns ContactsOutput => {
    numberOfContacts: contactsInput.totalSize,
    contacts: from var recordsItem in contactsInput.records
        select {
            fullName: recordsItem.FirstName + recordsItem.LastName,
            phoneNumber: recordsItem.Phone,
            email: recordsItem.Email,
            id: recordsItem.Id
        }
};
