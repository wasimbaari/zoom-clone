import { clerkMiddleware, createRouteMatcher } from '@clerk/nextjs/server';

// 1. Define the routes that REQUIRE authentication
const protectedRoute = createRouteMatcher([
  '/',
  '/upcoming',
  '/meeting(.*)',
  '/previous',
  '/recordings',
  '/personal-room',
]);

// 2. Define the explicit bypass routes (SRE Best Practice)
const isPublicRoute = createRouteMatcher(['/api/health']);

export default clerkMiddleware((auth, req) => {
  // Fast-path the Kubernetes health check so it doesn't consume auth resources
  if (isPublicRoute(req)) return;

  // Protect the main application routes
  if (protectedRoute(req)) auth().protect();
});

export const config = {
  matcher: ['/((?!.+\\.[\\w]+$|_next).*)', '/', '/(api|trpc)(.*)'],
};