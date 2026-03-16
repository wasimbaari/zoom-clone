/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone', // <-- Added for Docker multi-stage build optimization
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'img.clerk.com',
      },
    ],
  },
};

export default nextConfig;