import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:scanner/models/User.dart';

class AuthService {
  bool isLoggedIn;

  UserProfile userProfile;
  GoogleSignInAccount googleUser;

  final GoogleSignIn googleSignIn =
      GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);

  // constructor
  AuthService() {
    isSignedIn().then((value) => isLoggedIn = value);
  }

  Future<GoogleSignInAccount> signIn() async {
    googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      userProfile = UserProfile(
          id: googleUser.id,
          name: googleUser.displayName,
          email: googleUser.email,
          photoUrl: googleUser.photoUrl);
    }
    return googleUser;
  }

  Future<GoogleSignInAccount> getCurrentUser() async {
    return await googleSignIn.signInSilently();
  }

  Future<bool> isSignedIn() async {
    return await googleSignIn.isSignedIn();
  }

  Future<GoogleSignInAccount> signOut() {
    return googleSignIn.signOut();
  }

  //getter setters
  UserProfile get getUserProfile => this.userProfile;
  GoogleSignInAccount get getGoogleUser => this.googleUser;
}

final AuthService authService = AuthService();
