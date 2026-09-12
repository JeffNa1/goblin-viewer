import React from 'react';
import { AbsoluteFill, interpolate, useCurrentFrame, staticFile, Img, Easing } from 'remotion';
import { MONSTERS } from '../monsterData';

export const OutroScene: React.FC = () => {
  const frame = useCurrentFrame();

  const entranceOpacity = interpolate(frame, [0, 20], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
  });

  const titleScale = interpolate(frame, [0, 30], [0.9, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  return (
    <AbsoluteFill
      style={{
        backgroundColor: '#0a0d14',
        backgroundImage: `
          radial-gradient(circle at 50% 30%, rgba(224, 122, 56, 0.18) 0%, transparent 70%),
          linear-gradient(rgba(255, 255, 255, 0.03) 1px, transparent 1px),
          linear-gradient(90deg, rgba(255, 255, 255, 0.03) 1px, transparent 1px)
        `,
        backgroundSize: '100% 100%, 48px 48px, 48px 48px',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        padding: '50px 60px',
        opacity: entranceOpacity,
        fontFamily: 'system-ui, -apple-system, sans-serif',
        color: '#ffffff',
        overflow: 'hidden',
      }}
    >
      {/* Title */}
      <div
        style={{
          scale: titleScale,
          fontSize: '56px',
          fontWeight: 900,
          letterSpacing: '4px',
          textTransform: 'uppercase',
          textAlign: 'center',
          background: 'linear-gradient(180deg, #ffffff 40%, #f97316 100%)',
          WebkitBackgroundClip: 'text',
          WebkitTextFillColor: 'transparent',
          marginBottom: '10px',
          textShadow: '0 0 40px rgba(249, 115, 22, 0.4)',
        }}
      >
        THE GOBLIN HORDE AWAITS
      </div>

      <div
        style={{
          fontSize: '20px',
          fontWeight: 600,
          letterSpacing: '2px',
          color: '#cbd5e1',
          marginBottom: '40px',
        }}
      >
        Complete 3D Procedural Voxel Combat Lineup • Built for Godot Engine 4
      </div>

      {/* 5-Card Lineup Grid */}
      <div
        style={{
          display: 'flex',
          gap: '20px',
          width: '100%',
          maxWidth: '1760px',
          justifyContent: 'center',
          marginBottom: '40px',
        }}
      >
        {MONSTERS.map((monster, idx) => {
          const cardDelay = 10 + idx * 5;
          const cardOpacity = interpolate(frame, [cardDelay, cardDelay + 15], [0, 1], {
            extrapolateLeft: 'clamp',
            extrapolateRight: 'clamp',
          });
          const cardTranslateY = interpolate(frame, [cardDelay, cardDelay + 15], [30, 0], {
            extrapolateLeft: 'clamp',
            extrapolateRight: 'clamp',
            easing: Easing.out(Easing.cubic),
          });

          const isBoss = monster.id === 'ogre';

          return (
            <div
              key={monster.id}
              style={{
                flex: isBoss ? '1 1 24%' : '1 1 19%',
                opacity: cardOpacity,
                translate: `0px ${cardTranslateY}px`,
                backgroundColor: 'rgba(15, 20, 32, 0.85)',
                border: `2px solid ${monster.primaryColor}${isBoss ? 'cc' : '66'}`,
                borderRadius: '16px',
                overflow: 'hidden',
                display: 'flex',
                flexDirection: 'column',
                boxShadow: `0 10px 30px rgba(0,0,0,0.6), 0 0 20px ${monster.primaryColor}25`,
              }}
            >
              {/* Image viewport */}
              <div
                style={{
                  height: '240px',
                  position: 'relative',
                  overflow: 'hidden',
                  backgroundColor: '#000000',
                }}
              >
                <Img
                  src={staticFile(monster.actionImage)}
                  style={{
                    width: '100%',
                    height: '100%',
                    objectFit: 'cover',
                  }}
                />
                <div
                  style={{
                    position: 'absolute',
                    top: 10,
                    right: 10,
                    padding: '3px 8px',
                    borderRadius: '4px',
                    backgroundColor: `${monster.primaryColor}cc`,
                    fontSize: '11px',
                    fontWeight: 800,
                    color: '#ffffff',
                    letterSpacing: '1px',
                  }}
                >
                  {isBoss ? 'WORLD BOSS' : `TIER ${monster.difficulty}`}
                </div>
              </div>

              {/* Card Meta */}
              <div style={{ padding: '16px 18px', display: 'flex', flexDirection: 'column', gap: '6px' }}>
                <div
                  style={{
                    fontSize: '18px',
                    fontWeight: 900,
                    color: '#ffffff',
                    letterSpacing: '1px',
                  }}
                >
                  {monster.name}
                </div>
                <div
                  style={{
                    fontSize: '12px',
                    fontWeight: 700,
                    color: monster.primaryColor,
                    letterSpacing: '1px',
                    textTransform: 'uppercase',
                  }}
                >
                  {monster.role}
                </div>
                <div
                  style={{
                    fontSize: '11px',
                    color: '#94a3b8',
                    marginTop: '4px',
                    whiteSpace: 'nowrap',
                    overflow: 'hidden',
                    textOverflow: 'ellipsis',
                  }}
                >
                  🗡️ {monster.weapon}
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Footer Specs / Engine Callout */}
      <div
        style={{
          display: 'flex',
          gap: '30px',
          padding: '14px 32px',
          borderRadius: '999px',
          backgroundColor: 'rgba(255, 255, 255, 0.04)',
          border: '1px solid rgba(255, 255, 255, 0.1)',
          fontSize: '16px',
          fontWeight: 700,
          letterSpacing: '1.5px',
          color: '#cbd5e1',
        }}
      >
        <span>🔥 50,000+ VOXELS</span>
        <span>•</span>
        <span>✨ 0 CHECKERBOARD ARTIFACTS</span>
        <span>•</span>
        <span>🎮 GODOT 4.7.2 READY</span>
        <span>•</span>
        <span>🎬 REMOTION POWERED</span>
      </div>
    </AbsoluteFill>
  );
};
