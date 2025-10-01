import * as migration_20251001_185011 from './20251001_185011';

export const migrations = [
  {
    up: migration_20251001_185011.up,
    down: migration_20251001_185011.down,
    name: '20251001_185011'
  },
];
