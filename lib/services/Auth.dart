import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:scanner/models/User.dart';

class AuthService {
  UserProfile userProfile;
  GoogleSignInAccount googleUser;

  final GoogleSignIn googleSignIn =
      GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);

  // constructor
  AuthService();

  Future<GoogleSignInAccount> signIn() async {
    googleUser = await googleSignIn.signIn();
    userProfile = UserProfile(
        id: googleUser.id,
        name: googleUser.displayName,
        email: googleUser.email,
        photoUrl: googleUser.photoUrl);
    return googleUser;
  }

  Future<bool> isSignedIn() {
    return googleSignIn.isSignedIn();
  }

  void signOut() {
    googleSignIn.signOut();
  }

  //getter setters
  UserProfile get getUserProfile => this.userProfile;
  GoogleSignInAccount get getGoogleUser => this.googleUser;
}

final AuthService authService = AuthService();
