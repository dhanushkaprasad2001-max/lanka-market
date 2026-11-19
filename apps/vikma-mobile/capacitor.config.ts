import type { CapacitorConfig } from '@capacitor/cli';
const config: CapacitorConfig = {
  appId: 'lk.vikma.market',
  appName: 'VIKMA',
  webDir: 'www',
  server: { androidScheme: 'https' },
  android: { allowMixedContent: false }
};
export default config;
