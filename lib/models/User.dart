class UserProfile {
  String id;
  String name;
  String email;
  String photoUrl;

  UserProfile({
    this.id,
    this.name,
    this.email,
    this.photoUrl,
  });

  String get getId => this.id;

  set setId(String id) => this.id = id;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getEmail => this.email;

  set setEmail(email) => this.email = email;

  get getPhotoUrl => this.photoUrl;

  set setPhotoUrl(photoUrl) => this.photoUrl = photoUrl;
}
