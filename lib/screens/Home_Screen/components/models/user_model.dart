

class User {
  final int id;
  final String name;
  final String imageUrl;
  final bool isOnline;

  User({
    this.id,
    this.name,
    this.imageUrl,
    this.isOnline,
  });
}

// YOU - current user
final User user = User(
  id: 0,
  name: 'Nick Fury',
  imageUrl: 'assets/images/shafiqueimg.jpeg',
  isOnline: true,
);

// USERS
final User ironMan = User(
  id: 1,
  name: 'Iron Man',
  imageUrl: 'assets/images/shafiqueimg.jpeg',
  isOnline: true,
);