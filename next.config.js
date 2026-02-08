/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    turbo: {
      // disable turbopack in builds by not enabling it
    }
  }
};

module.exports = nextConfig;
