const String baseUrl = "http://143.244.143.142:5000/";
const String loinMutation = """
  mutation LoginMutation(\$email: String!, \$password: String!) {
  memberLogin(email: \$email, password: \$password) {
    id
    token
    username
    avatar
    email
  }
}""";
const String getUserServiceRepositories = """
  query getQuery {
  getUserServices {
    createdAt
    servicesName
    servicesPrice
    uniq
  }
}
""";
const String notificationRepositories = """
query ExampleQuery {
  notifications {
    id
    type
    createdAt
    message
  }
}
  """;
const String getUserPaymentRepositories = """
  query getUserPayments {
  getUserPayments {
     id
    status
    createdAt
    month
    list {
      serviceName
      serviceId
      price
    }
  }
}
  """;
const String getActivityRepositories = """
 query ExampleQuery {
  getUserActivities {
    id
    message
    createdAt
    topic
  }
}
  """;
