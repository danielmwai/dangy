import passport from "passport";
import { Strategy as GoogleStrategy } from "passport-google-oauth20";
import session from "express-session";
import connectPg from "connect-pg-simple";
import { storage } from "./storage";

// Google OAuth configuration
export function setupGoogleAuth(app: any) {
  // Session setup
  const sessionTtl = 7 * 24 * 60 * 60 * 1000; // 1 week
  const pgStore = connectPg(session);
  const sessionStore = new pgStore({
    conString: process.env.DATABASE_URL,
    createTableIfMissing: false,
    ttl: sessionTtl,
    tableName: "sessions",
  });

  app.use(session({
    secret: process.env.SESSION_SECRET || "fallback_secret_key_for_development",
    store: sessionStore,
    resave: false,
    saveUninitialized: false,
    cookie: {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      maxAge: sessionTtl,
    },
  }));

  app.use(passport.initialize());
  app.use(passport.session());

  // Only configure Google Strategy if credentials are provided
  if (process.env.GOOGLE_CLIENT_ID && process.env.GOOGLE_CLIENT_SECRET) {
    try {
      // Configure Google Strategy
      passport.use(new GoogleStrategy({
        clientID: process.env.GOOGLE_CLIENT_ID,
        clientSecret: process.env.GOOGLE_CLIENT_SECRET,
        callbackURL: "/api/auth/google/callback"
      }, async (accessToken, refreshToken, profile, done) => {
        try {
          // Check if user already exists
          let user = await storage.getUserByEmail(profile.emails?.[0].value || "");
          
          if (!user) {
            // Create new user if doesn't exist
            user = await storage.createUserWithEmail({
              email: profile.emails?.[0].value || "",
              password: "", // No password for Google auth users
              firstName: profile.name?.givenName || "",
              lastName: profile.name?.familyName || "",
            });
          }
          
          // Update user with Google profile info
          user = await storage.upsertUser({
            id: user.id,
            email: profile.emails?.[0].value || "",
            firstName: profile.name?.givenName || "",
            lastName: profile.name?.familyName || "",
            profileImageUrl: profile.photos?.[0].value || "",
            authProvider: "google",
          });
          
          return done(null, user || undefined);
        } catch (error) {
          console.error("Error in Google OAuth callback:", error);
          return done(error, false);
        }
      }));

      // Google OAuth routes
      app.get("/api/auth/google", (req: any, res: any, next: any) => {
        // Check if Google auth is properly configured
        if (!process.env.GOOGLE_CLIENT_ID || !process.env.GOOGLE_CLIENT_SECRET) {
          return res.status(500).json({ 
            message: "Google OAuth is not properly configured",
            error: "Missing Google Client ID or Secret"
          });
        }
        
        passport.authenticate("google", { scope: ["profile", "email"] })(req, res, next);
      });

      app.get("/api/auth/google/callback",
        (req: any, res: any, next: any) => {
          // Check if Google auth is properly configured
          if (!process.env.GOOGLE_CLIENT_ID || !process.env.GOOGLE_CLIENT_SECRET) {
            return res.status(500).json({ 
              message: "Google OAuth is not properly configured",
              error: "Missing Google Client ID or Secret"
            });
          }
          
          passport.authenticate("google", { failureRedirect: "/login" })(req, res, next);
        },
        (req: any, res: any) => {
          // Successful authentication, redirect to frontend
          res.redirect("/");
        }
      );
    } catch (error) {
      console.error("Failed to configure Google OAuth strategy:", error);
    }
  } else {
    console.warn("Google OAuth credentials not found. Google authentication will be disabled.");
    
    // Provide fallback routes when Google auth is not configured
    app.get("/api/auth/google", (req: any, res: any) => {
      res.status(500).json({ 
        message: "Google OAuth is not configured",
        error: "Missing Google Client ID or Secret"
      });
    });
    
    app.get("/api/auth/google/callback", (req: any, res: any) => {
      res.status(500).json({ 
        message: "Google OAuth is not configured",
        error: "Missing Google Client ID or Secret"
      });
    });
  }

  // Serialize user
  passport.serializeUser((user: any, done) => {
    done(null, user.id);
  });

  // Deserialize user
  passport.deserializeUser(async (id: string, done: any) => {
    try {
      const user = await storage.getUser(id);
      done(null, user);
    } catch (error) {
      done(error, null);
    }
  });

  // Logout route
  app.get("/api/auth/logout", (req: any, res: any) => {
    req.logout(() => {
      res.redirect("/");
    });
  });
}

// Middleware to check if user is authenticated
export const isAuthenticated = (req: any, res: any, next: any) => {
  if (req.isAuthenticated()) {
    return next();
  }
  res.status(401).json({ message: "Unauthorized" });
};