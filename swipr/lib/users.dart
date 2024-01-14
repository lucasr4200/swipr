

class User {
  String username;
  String password;

  User(
    {
    required this.username,
    required this.password
    }
  );
}

List<User> users = [
  User(username: "user1", password: "password1"),
  User(username: "user2", password: "password2"),
];