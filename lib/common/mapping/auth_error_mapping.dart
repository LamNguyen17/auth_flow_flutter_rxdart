const Map<String, String> authErrorMapping = {
  'user-not-found': 'The given user was not found on the server!',
  'weak-password':
      'Please choose a stronger password consisting of more characters!',
  'invalid-email': 'Please double check your email and try again!',
  'operation-not-allowed':
      'You cannot register using this method at this moment',
  'email-already-in-use': 'Please choose another email to register with!',
  'requires-recent-login':
      'You need to log out and log back in again in order to perform this operation',
  'no-current-user': 'No current user with this information was found',
  'invalid-credential':
      'The supplied auth credential is incorrect, malformed or has expired.',
  'too-many-requests':
      'We have blocked all requests from this device due to unusual activity. Try again later.',
};
