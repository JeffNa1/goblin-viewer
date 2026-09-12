import React from 'react';
import { Sequence } from 'remotion';
import { IntroScene } from './components/IntroScene';
import { MonsterCard } from './components/MonsterCard';
import { BossAlert } from './components/BossAlert';
import { OutroScene } from './components/OutroScene';
import { MONSTERS } from './monsterData';

export const MonsterShowcase: React.FC = () => {
  const warrior = MONSTERS.find((m) => m.id === 'warrior')!;
  const archer = MONSTERS.find((m) => m.id === 'archer')!;
  const shaman = MONSTERS.find((m) => m.id === 'shaman')!;
  const rogue = MONSTERS.find((m) => m.id === 'rogue')!;
  const ogre = MONSTERS.find((m) => m.id === 'ogre')!;

  return (
    <div style={{ flex: 1, backgroundColor: '#0a0d14' }}>
      {/* 1. Intro Scene (0s - 4s) */}
      <Sequence from={0} durationInFrames={120}>
        <IntroScene />
      </Sequence>

      {/* 2. Goblin Warrior (4s - 10s) */}
      <Sequence from={120} durationInFrames={180}>
        <MonsterCard monster={warrior} durationInFrames={180} />
      </Sequence>

      {/* 3. Goblin Archer (10s - 16s) */}
      <Sequence from={300} durationInFrames={180}>
        <MonsterCard monster={archer} durationInFrames={180} />
      </Sequence>

      {/* 4. Goblin Shaman (16s - 22s) */}
      <Sequence from={480} durationInFrames={180}>
        <MonsterCard monster={shaman} durationInFrames={180} />
      </Sequence>

      {/* 5. Goblin Rogue (22s - 28s) */}
      <Sequence from={660} durationInFrames={180}>
        <MonsterCard monster={rogue} durationInFrames={180} />
      </Sequence>

      {/* 6. Boss Alert Siren (28s - 31s) */}
      <Sequence from={840} durationInFrames={90}>
        <BossAlert />
      </Sequence>

      {/* 7. Mace Ogre Boss (31s - 39s) */}
      <Sequence from={930} durationInFrames={240}>
        <MonsterCard monster={ogre} durationInFrames={240} />
      </Sequence>

      {/* 8. Outro Lineup & Roster (39s - 44s) */}
      <Sequence from={1170} durationInFrames={150}>
        <OutroScene />
      </Sequence>
    </div>
  );
};
