import { useEmailAuth } from "./useEmailAuth";

export function useUnifiedAuth() {
  const emailAuth = useEmailAuth();

  // Authentication status
  const isAuthenticated = emailAuth.isAuthenticated;
  
  // Get the current user from email auth
  const user = emailAuth.user;
  
  // Loading state
  const isLoading = emailAuth.isLoading;

  // Auth provider type is always email now
  const authProvider = isAuthenticated ? "email" : null;

  // Logout function
  const logout = async () => {
    await emailAuth.logout();
  };

  return {
    // Authentication status
    isAuthenticated,
    isLoading,
    user,
    authProvider,
    
    // Email specific
    isEmailAuthenticated: emailAuth.isAuthenticated,
    emailUser: emailAuth.user,
    signIn: emailAuth.signIn,
    signUp: emailAuth.signUp,
    isSignInLoading: emailAuth.isSignInLoading,
    isSignUpLoading: emailAuth.isSignUpLoading,
    signInError: emailAuth.signInError,
    signUpError: emailAuth.signUpError,
    
    // Common actions
    logout,
  };
}